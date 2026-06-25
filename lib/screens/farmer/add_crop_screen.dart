import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/crop_provider.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  static const Color darkGreen = Color(0xff075739);

  final TextEditingController cropNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedCategory = "Select a category...";
  String selectedUnit = "kg";
  String harvestDate = "dd/mm/yyyy";

  bool isOrganic = false;
  bool isDeliveryAvailable = false;
  bool isPremiumGrade = false;

  @override
  void dispose() {
    cropNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _pickHarvestDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        harvestDate =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void _submitCrop() {
    if (cropNameController.text.trim().isEmpty ||
        quantityController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        selectedCategory == "Select a category...") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill required fields"),
        ),
      );
      return;
    }

    final newCrop = CropModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: cropNameController.text.trim(),
      imageUrl:
      "https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800",
      quantity: "${quantityController.text.trim()} $selectedUnit left",
      price: "\$${priceController.text.trim()}",
      unit: "/$selectedUnit",
      category: selectedCategory,
      status: "Active",
      isOrganic: isOrganic,
      isReadyToShip: isDeliveryAvailable,
      location: locationController.text.trim(),
      description: descriptionController.text.trim(),
      harvestDate: harvestDate,
    );

    Provider.of<CropProvider>(context, listen: false).addCrop(newCrop);

    Navigator.pushReplacementNamed(context, '/myCrops');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                child: Column(
                  children: [
                    _uploadImageBox(),
                    const SizedBox(height: 22),
                    _cropDetailsCard(),
                    const SizedBox(height: 25),
                    _submitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _topBar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffe4eee8)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/myCrops');
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xff4f5955),
              size: 22,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "List New Crop",
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 22),
        ],
      ),
    );
  }

  Widget _uploadImageBox() {
    return Container(
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xffcfd8d3),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade200,
            child: const Icon(
              Icons.camera_alt,
              color: darkGreen,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "Upload Crop Image",
            style: TextStyle(
              color: darkGreen,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "High-quality, well-lit photos attract more\nbuyers. Tap or drag to upload.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff4f5955),
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "JPEG, PNG up to 5MB",
            style: TextStyle(
              color: Color(0xff4f5955),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cropDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffd8e6de)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Crop Details",
            style: TextStyle(
              color: darkGreen,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Divider(height: 28),

          _label("Crop Name"),
          _inputField(
            controller: cropNameController,
            hint: "e.g., Organic Honeycrisp Apples",
            icon: Icons.grass_outlined,
          ),

          const SizedBox(height: 18),
          _label("Category"),
          _categoryDropdown(),

          const SizedBox(height: 18),
          _label("Est. Harvest Date"),
          GestureDetector(
            onTap: _pickHarvestDate,
            child: AbsorbPointer(
              child: TextField(
                decoration: _inputDecoration(
                  hint: harvestDate,
                  icon: Icons.calendar_today_outlined,
                  suffixIcon: Icons.calendar_month,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),
          _label("Available Quantity"),
          Row(
            children: [
              Expanded(
                child: _inputField(
                  controller: quantityController,
                  hint: "0.00",
                  icon: Icons.scale_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 95,
                child: DropdownButtonFormField<String>(
                  value: selectedUnit,
                  decoration: _inputDecoration(hint: ""),
                  items: const [
                    DropdownMenuItem(value: "kg", child: Text("kg")),
                    DropdownMenuItem(value: "ton", child: Text("ton")),
                    DropdownMenuItem(value: "box", child: Text("box")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value!;
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          _label("Price (per unit)"),
          _inputField(
            controller: priceController,
            hint: "0.00",
            icon: Icons.attach_money,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 18),
          Row(
            children: [
              _label("Farm Location"),
              const Spacer(),
              const Icon(Icons.my_location, size: 14, color: darkGreen),
              const SizedBox(width: 4),
              const Text(
                "Use Current Location",
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _inputField(
            controller: locationController,
            hint: "Search address or drop a pin...",
            icon: Icons.location_on_outlined,
          ),

          const SizedBox(height: 10),
          Container(
            height: 95,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffe7e7f3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 36,
              ),
            ),
          ),

          const SizedBox(height: 18),
          _label("Description"),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            decoration: _inputDecoration(
              hint:
              "Describe the quality, farming methods, and any other relevant details...",
              icon: Icons.description_outlined,
            ),
          ),

          const SizedBox(height: 18),
          _label("Quick Attributes"),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _attributeChip(
                title: "Organic",
                selected: isOrganic,
                onTap: () {
                  setState(() {
                    isOrganic = !isOrganic;
                  });
                },
              ),
              _attributeChip(
                title: "Delivery Available",
                selected: isDeliveryAvailable,
                onTap: () {
                  setState(() {
                    isDeliveryAvailable = !isDeliveryAvailable;
                  });
                },
              ),
              _attributeChip(
                title: "Premium Grade",
                selected: isPremiumGrade,
                onTap: () {
                  setState(() {
                    isPremiumGrade = !isPremiumGrade;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xff333333),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(
        hint: hint,
        icon: icon,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    IconData? icon,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xff777777)),
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        size: 18,
        color: const Color(0xff777777),
      ),
      suffixIcon: suffixIcon == null
          ? null
          : Icon(
        suffixIcon,
        size: 18,
        color: const Color(0xff777777),
      ),
      filled: true,
      fillColor: const Color(0xfffbfcfb),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xffd8e6de)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: darkGreen),
      ),
    );
  }

  Widget _categoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: _inputDecoration(
        hint: "Select a category...",
        icon: Icons.category_outlined,
      ),
      items: const [
        DropdownMenuItem(
          value: "Select a category...",
          child: Text("Select a category..."),
        ),
        DropdownMenuItem(value: "Wheat", child: Text("Wheat")),
        DropdownMenuItem(value: "Rice", child: Text("Rice")),
        DropdownMenuItem(value: "Vegetables", child: Text("Vegetables")),
        DropdownMenuItem(value: "Fruits", child: Text("Fruits")),
        DropdownMenuItem(value: "Organic", child: Text("Organic")),
      ],
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
      },
    );
  }

  Widget _attributeChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(title),
        avatar: Icon(
          selected ? Icons.check_circle : Icons.add_circle_outline,
          size: 16,
          color: selected ? darkGreen : Colors.grey,
        ),
        backgroundColor: selected ? const Color(0xffe2f4ea) : Colors.white,
        side: BorderSide(
          color: selected ? darkGreen : const Color(0xffd8e6de),
        ),
        labelStyle: TextStyle(
          color: selected ? darkGreen : const Color(0xff4f5955),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _submitCrop,
        icon: const Icon(Icons.add_circle_outline, size: 18),
        label: const Text(
          "List Crop to Marketplace",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
      ),
    );
  }
}