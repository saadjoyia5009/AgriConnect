import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/disease_detection_provider.dart';
import '../../models/disease_detection_model.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      context.read<DiseaseDetectionProvider>().setImage(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiseaseDetectionProvider>();

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              const SizedBox(height: 22),

              const Text(
                "Disease Detection",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff075739),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Upload or take a clear photo of an affected plant leaf for instant AI analysis.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Color(0xff3e4542),
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: () => _pickImage(context),
                child: _imagePreview(provider.selectedImage),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: provider.isLoading
                      ? null
                      : () {
                    if (provider.selectedImage == null) {
                      _pickImage(context);
                    } else {
                      provider.analyzeImage();
                    }
                  },
                  icon: const Icon(Icons.document_scanner_outlined),
                  label: Text(
                    provider.selectedImage == null
                        ? "Upload Image"
                        : "Analyze Image",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff075739),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (provider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(
                      color: Color(0xff075739),
                    ),
                  ),
                ),

              if (provider.errorMessage != null)
                _errorCard(provider.errorMessage!),

              if (provider.result != null)
                _resultCard(provider.result!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xff075739),
            size: 27,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "AgriConnect",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff075739),
              ),
            ),
          ),
        ),
        const CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=11"),
        ),
      ],
    );
  }

  Widget _imagePreview(File? image) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffe9efec),
        borderRadius: BorderRadius.circular(14),
        image: image != null
            ? DecorationImage(
          image: FileImage(image),
          fit: BoxFit.cover,
        )
            : const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1515150144380-bca9f1650ed9?w=900",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _resultCard(DiseaseDetectionModel result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffbfe8ce)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusAndConfidence(result),
          const SizedBox(height: 14),

          Text(
            result.diseaseName,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff202525),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            result.scientificName,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff6d7471),
            ),
          ),

          const SizedBox(height: 22),
          const Divider(),

          const Row(
            children: [
              Icon(
                Icons.medical_services_outlined,
                color: Color(0xff075739),
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                "Recommended Treatment Plan",
                style: TextStyle(
                  color: Color(0xff075739),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...result.treatmentPlan.map(
                (step) => _treatmentTile(step),
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save_outlined),
                  label: const Text("Save Report"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xff075739),
                    side: const BorderSide(color: Color(0xff075739)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xffe5e8e6),
                    foregroundColor: const Color(0xff202525),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusAndConfidence(DiseaseDetectionModel result) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xffffd8d5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            result.status,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        Container(
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff075739),
              width: 4,
            ),
          ),
          child: Center(
            child: Text(
              "${result.confidence}%",
              style: const TextStyle(
                color: Color(0xff075739),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _treatmentTile(TreatmentStepModel step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfff1f2f1),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xff5d846b),
            child: Icon(
              Icons.local_hospital_outlined,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202525),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  step.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Color(0xff3e4542),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffffd8d5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}