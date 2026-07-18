import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config/api_config.dart';
import '../models/crop_model.dart';
import '../utils/token_storage.dart';

class CropService {
  static Future<List<dynamic>> fetchFarmerCrops() async {
    final token = await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/crops/'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return decoded;
      }

      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return List<dynamic>.from(decoded['data']);
      }

      return [];
    }

    throw Exception(
      'Failed to load farmer crops (${response.statusCode}): '
          '${response.body}',
    );
  }

  static Future<List<dynamic>> fetchMarketplaceCrops() async {
    final token = await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/crops/marketplace/'),
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return decoded;
      }

      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return List<dynamic>.from(decoded['data']);
      }

      return [];
    }

    throw Exception(
      'Failed to load marketplace crops (${response.statusCode}): '
          '${response.body}',
    );
  }

  static Future<Map<String, dynamic>> addCrop(
      CropModel crop, {
        XFile? imageFile,
        Uint8List? imageBytes,
      }) async {
    final token = await TokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Access token not found. Please login again.',
      );
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/crops/'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'name': crop.name.trim(),
      'category': _cleanCategory(crop.category),
      'description': crop.description.trim(),
      'quantity': _cleanNumber(crop.quantity),
      'unit': _cleanUnit(crop.unit),
      'price_per_unit': _cleanNumber(crop.price),
      'farm_location': crop.location.trim(),
      'estimated_harvest_date': _formatDate(crop.harvestDate),
      'is_organic': crop.isOrganic.toString(),
      'is_delivery_available': crop.isReadyToShip.toString(),
      'is_premium_grade': crop.isPremiumGrade.toString(),
      'status': _cleanStatus(crop.status),
    });

    await _attachImage(
      request: request,
      imageFile: imageFile,
      imageBytes: imageBytes,
    );

    print('Crop URL: ${ApiConfig.baseUrl}/crops/');
    print('Crop fields: ${request.fields}');
    print('Crop image name: ${imageFile?.name}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(
      streamedResponse,
    );

    print('Crop add status: ${response.statusCode}');
    print('Crop add response: ${response.body}');

    if (response.statusCode == 201 ||
        response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw Exception(
        'Invalid crop response format.',
      );
    }

    throw Exception(
      'Crop add failed (${response.statusCode}): '
          '${response.body}',
    );
  }

  static Future<Map<String, dynamic>> updateCrop(
      CropModel crop, {
        XFile? imageFile,
        Uint8List? imageBytes,
      }) async {
    final token = await TokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Access token not found. Please login again.',
      );
    }

    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse(
        '${ApiConfig.baseUrl}/crops/${crop.id}/',
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'name': crop.name.trim(),
      'category': _cleanCategory(crop.category),
      'description': crop.description.trim(),
      'quantity': _cleanNumber(crop.quantity),
      'unit': _cleanUnit(crop.unit),
      'price_per_unit': _cleanNumber(crop.price),
      'farm_location': crop.location.trim(),
      'estimated_harvest_date': _formatDate(crop.harvestDate),
      'is_organic': crop.isOrganic.toString(),
      'is_delivery_available': crop.isReadyToShip.toString(),
      'is_premium_grade': crop.isPremiumGrade.toString(),
      'status': _cleanStatus(crop.status),
    });

    await _attachImage(
      request: request,
      imageFile: imageFile,
      imageBytes: imageBytes,
    );

    print(
      'Crop update URL: '
          '${ApiConfig.baseUrl}/crops/${crop.id}/',
    );
    print('Crop update fields: ${request.fields}');
    print('Crop update image name: ${imageFile?.name}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(
      streamedResponse,
    );

    print('Crop update status: ${response.statusCode}');
    print('Crop update response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw Exception(
        'Invalid crop response format.',
      );
    }

    throw Exception(
      'Crop update failed (${response.statusCode}): '
          '${response.body}',
    );
  }

  static Future<void> deleteCrop(String id) async {
    final token = await TokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Access token not found. Please login again.',
      );
    }

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/crops/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204 &&
        response.statusCode != 200) {
      throw Exception(
        'Failed to delete crop (${response.statusCode}): '
            '${response.body}',
      );
    }
  }

  static Future<void> _attachImage({
    required http.MultipartRequest request,
    XFile? imageFile,
    Uint8List? imageBytes,
  }) async {
    if (imageFile == null) {
      return;
    }

    final bytes = imageBytes ?? await imageFile.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('Selected image is empty.');
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: imageFile.name,
      ),
    );
  }

  static String _cleanCategory(String value) {
    final category = value.trim().toLowerCase();

    const validCategories = {
      'vegetables',
      'fruits',
      'grains',
      'pulses',
      'cotton',
      'sugarcane',
      'other',
    };

    if (validCategories.contains(category)) {
      return category;
    }

    return 'other';
  }

  static String _cleanNumber(String value) {
    final cleaned = value.replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );

    if (cleaned.isEmpty) {
      return '0';
    }

    return cleaned;
  }

  static String _cleanUnit(String value) {
    final unit = value
        .replaceAll(RegExp(r'[^a-zA-Z]'), '')
        .toLowerCase();

    const validUnits = {
      'kg',
      'ton',
      'box',
      'bundle',
      'bag',
    };

    if (validUnits.contains(unit)) {
      return unit;
    }

    return 'kg';
  }

  static String _formatDate(String date) {
    final cleanDate = date.trim();

    if (cleanDate.isEmpty ||
        cleanDate == 'dd/mm/yyyy') {
      return '';
    }

    if (cleanDate.contains('/')) {
      final parts = cleanDate.split('/');

      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        final year = parts[2];

        return '$year-$month-$day';
      }
    }

    return cleanDate;
  }

  static String _cleanStatus(String status) {
    final value = status.trim().toLowerCase();

    if (value == 'sold out' || value == 'sold_out') {
      return 'sold_out';
    }

    if (value == 'draft') {
      return 'draft';
    }

    return 'active';
  }
}