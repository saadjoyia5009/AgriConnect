import 'package:flutter/material.dart';

class EditCropScreen extends StatefulWidget {
  const EditCropScreen({super.key});

  @override
  State<EditCropScreen> createState() => _EditCropScreenState();
}

class _EditCropScreenState extends State<EditCropScreen> {
  static const Color darkGreen = Color(0xff075739);

  final TextEditingController cropNameController =
  TextEditingController(text: "Fresh Red Tomatoes");
  final TextEditingController quantityController =
  TextEditingController(text: "500 kg");
  final TextEditingController priceController =
  TextEditingController(text: "\$1.50 /kg");
  final TextEditingController locationController =
  TextEditingController(text: "Faisalabad, Punjab");
  final TextEditingController descriptionController = TextEditingController(
    text:
    "Organic, pesticide-free tomatoes harvested directly from our family farm. Sweet and juicy.",
  );

  String selectedCategory = "Vegetables";

  @override
  void dispose() {
    cropNameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Crop listing updated successfully")),
    );

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
                child: Column(
                  children: [
                    _imageHeader(),
                    Transform.translate(
                      offset: const Offset(0, -18),
                      child: _formCard(),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ),
            _bottomSaveSection(),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: darkGreen),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Edit Crop Listing",
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const Icon(Icons.delete_outline, color: Colors.red),
        ],
      ),
    );
  }

  Widget _imageHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.network(
          "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=900",
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 250,
          color: Colors.black.withOpacity(0.15),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt, size: 18),
          label: const Text("Change Photo"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: darkGreen,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(14),
          bottom: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label(Icons.local_florist_outlined, "Crop Name"),
          _inputField(cropNameController),

          const SizedBox(height: 22),
          _label(Icons.category_outlined, "Category"),
          _categoryDropdown(),

          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(Icons.inventory_2_outlined, "Quantity"),
                    _inputField(quantityController),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(Icons.payments_outlined, "Price"),
                    _inputField(priceController),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),
          _label(Icons.location_on_outlined, "Location"),
          Row(
            children: [
              Expanded(child: _inputField(locationController)),
              const SizedBox(width: 10),
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: const Color(0xffa7f2c8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.my_location, color: darkGreen),
              ),
            ],
          ),

          const SizedBox(height: 22),
          _label(Icons.description_outlined, "Description"),
          TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: _decoration(),
          ),

          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xffeef2ef)),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  "Visibility Settings",
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.chevron_right, color: darkGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xff3c4a43)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff2c3531),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: _decoration(),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xfffbfcfb),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xffcfd8d3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: darkGreen),
      ),
    );
  }

  Widget _categoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: _decoration(),
      items: const [
        DropdownMenuItem(value: "Vegetables", child: Text("Vegetables")),
        DropdownMenuItem(value: "Fruits", child: Text("Fruits")),
        DropdownMenuItem(value: "Wheat", child: Text("Wheat")),
        DropdownMenuItem(value: "Rice", child: Text("Rice")),
      ],
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
      },
    );
  }

  Widget _bottomSaveSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      color: const Color(0xfff9fbfa),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text(
                "Save Changes",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                elevation: 6,
                shadowColor: darkGreen.withOpacity(0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "By saving, you agree to update your listing\nterms in the marketplace.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xff333333)),
          ),
        ],
      ),
    );
  }
}