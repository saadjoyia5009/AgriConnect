import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/buyer_inquiry_provider.dart';

class SendInquiryScreen extends StatefulWidget {
  final CropModel crop;

  const SendInquiryScreen({
    super.key,
    required this.crop,
  });

  @override
  State<SendInquiryScreen> createState() => _SendInquiryScreenState();
}

class _SendInquiryScreenState extends State<SendInquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _offerPriceController.dispose();
    _deliveryDateController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BuyerInquiryProvider>();

    final success = await provider.sendInquiry(
      crop: widget.crop,
      buyerId: "buyer_1",
      quantity: _quantityController.text.trim(),
      offerPrice: _offerPriceController.text.trim(),
      deliveryDate: _deliveryDateController.text.trim(),
      message: _messageController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inquiry sent successfully")),
      );

      Navigator.pushReplacementNamed(context, '/buyer-inquiries');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Failed to send inquiry")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final crop = widget.crop;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8FAF7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Send Inquiry",
          style: TextStyle(
            color: Color(0xff0F5C3A),
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff0F5C3A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<BuyerInquiryProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _cropSummaryCard(crop),
                  const SizedBox(height: 20),
                  _inputField(
                    controller: _quantityController,
                    label: "Required Quantity",
                    hint: "Example: 20 Boxes",
                    icon: Icons.inventory_2_outlined,
                  ),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _offerPriceController,
                    label: "Offered Price",
                    hint: "Example: PKR 4500 / box",
                    icon: Icons.sell_outlined,
                  ),
                  const SizedBox(height: 14),
                  _inputField(
                    controller: _deliveryDateController,
                    label: "Expected Delivery Date",
                    hint: "Example: 28/06/2026",
                    icon: Icons.calendar_month_outlined,
                  ),
                  const SizedBox(height: 14),
                  _messageField(),
                  const SizedBox(height: 26),
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isSubmitting ? null : _submitInquiry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0F5C3A),
                        disabledBackgroundColor: Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: provider.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Submit Inquiry",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _cropSummaryCard(CropModel crop) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              crop.imageUrl,
              height: 78,
              width: 78,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 78,
                  width: 78,
                  color: const Color(0xffEAF7EF),
                  child: const Icon(Icons.image_not_supported_outlined),
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff10291D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  crop.farmerName.isNotEmpty ? crop.farmerName : "Unknown Farmer",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff5F675F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${crop.price}${crop.unit}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xff0F5C3A),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
      ),
    );
  }

  Widget _messageField() {
    return TextFormField(
      controller: _messageController,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Message is required";
        }
        return null;
      },
      decoration: _inputDecoration(
        label: "Message",
        hint: "Write your message for farmer...",
        icon: Icons.message_outlined,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xff0F5C3A)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xffDCE7DD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xffDCE7DD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xff0F5C3A), width: 1.4),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xffDCE7DD)),
    );
  }
}