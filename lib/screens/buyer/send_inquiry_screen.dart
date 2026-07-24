import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/crop_model.dart';
import '../../providers/buyer_inquiry_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/buyer/buyer_app_bar.dart';

class SendInquiryScreen extends StatefulWidget {
  final CropModel crop;

  const SendInquiryScreen({super.key, required this.crop});

  @override
  State<SendInquiryScreen> createState() => _SendInquiryScreenState();
}

class _SendInquiryScreenState extends State<SendInquiryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  static const Color darkGreen = Color(0xff0F5C3A);
  static const Color lightBackground = Color(0xffF8FAF7);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);
  static const Color lightGreen = Color(0xff9ff2c1);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get accentColor => isDark ? lightGreen : darkGreen;

  Color get primaryText {
    return isDark ? Colors.white : const Color(0xff10291D);
  }

  Color get secondaryText {
    return isDark ? Colors.white70 : const Color(0xff5F675F);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _offerPriceController.dispose();
    _deliveryDateController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDeliveryDate() async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final initialDate = now.add(const Duration(days: 1));

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: context.read<LanguageProvider>().t(
        "selectExpectedDeliveryDate",
      ),
    );

    if (selectedDate == null || !mounted) return;

    _deliveryDateController.text = _formatApiDate(selectedDate);
  }

  String _formatApiDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return "$year-$month-$day";
  }

  String? _validateQuantity(String? value) {
    final text = value?.trim() ?? "";

    if (text.isEmpty) {
      return context.read<LanguageProvider>().t("requiredQuantityRequired");
    }

    final quantity = double.tryParse(text);

    if (quantity == null) {
      return context.read<LanguageProvider>().t("validQuantityRequired");
    }

    if (quantity <= 0) {
      return context.read<LanguageProvider>().t("quantityGreaterZero");
    }

    final availableQuantity = double.tryParse(widget.crop.quantity.toString());

    if (availableQuantity != null && quantity > availableQuantity) {
      return context
          .read<LanguageProvider>()
          .t("onlyQuantityAvailable")
          .replaceAll('{quantity}', widget.crop.quantity.toString())
          .replaceAll(
            '{unit}',
            context.read<LanguageProvider>().tDynamic(widget.crop.unit),
          );
    }

    return null;
  }

  String? _validateOfferPrice(String? value) {
    final text = value?.trim() ?? "";

    if (text.isEmpty) {
      return context.read<LanguageProvider>().t("offeredPriceRequired");
    }

    final price = double.tryParse(text);

    if (price == null) {
      return context.read<LanguageProvider>().t("validOfferedPriceRequired");
    }

    if (price <= 0) {
      return context.read<LanguageProvider>().t("offeredPriceGreaterZero");
    }

    return null;
  }

  String? _validateDeliveryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.read<LanguageProvider>().t("deliveryDateRequired");
    }

    final selectedDate = DateTime.tryParse(value.trim());

    if (selectedDate == null) {
      return context.read<LanguageProvider>().t("validDeliveryDateRequired");
    }

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    if (selectedDate.isBefore(todayOnly)) {
      return context.read<LanguageProvider>().t("deliveryDatePast");
    }

    return null;
  }

  String? _validateMessage(String? value) {
    final message = value?.trim() ?? "";

    if (message.isEmpty) {
      return context.read<LanguageProvider>().t("messageRequired");
    }

    if (message.length < 5) {
      return context.read<LanguageProvider>().t("messageMinLength");
    }

    if (message.length > 2000) {
      return context.read<LanguageProvider>().t("messageMaxLength");
    }

    return null;
  }

  Future<void> _submitInquiry() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final provider = context.read<BuyerInquiryProvider>();

    final success = await provider.sendInquiry(
      crop: widget.crop,
      quantity: _quantityController.text.trim(),
      offerPrice: _offerPriceController.text.trim(),
      deliveryDate: _deliveryDateController.text.trim(),
      message: _messageController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LanguageProvider>().t("inquirySentSuccessfully"),
          ),
          backgroundColor: darkGreen,
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/buyer-inquiries',
        (route) => route.isFirst,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                context.read<LanguageProvider>().t("failedSendInquiry"),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final crop = widget.crop;
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDark ? darkBackground : lightBackground,
      appBar: BuyerAppBar(title: lang.t("sendInquiry"), showBackButton: true),
      body: SafeArea(
        child: Consumer<BuyerInquiryProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                18,
                18,
                18,
                18 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _cropSummaryCard(crop),
                    const SizedBox(height: 20),
                    _inputField(
                      controller: _quantityController,
                      label: lang.t("requiredQuantity"),
                      hint: lang.t("requiredQuantityHint"),
                      icon: Icons.inventory_2_outlined,
                      validator: _validateQuantity,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      suffixText: crop.unit,
                    ),
                    const SizedBox(height: 14),
                    _inputField(
                      controller: _offerPriceController,
                      label: lang.t("offeredPrice"),
                      hint: lang.t("offeredPriceHint"),
                      icon: Icons.sell_outlined,
                      validator: _validateOfferPrice,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      prefixText: "Rs. ",
                      suffixText: "/ ${crop.unit}",
                    ),
                    const SizedBox(height: 14),
                    _inputField(
                      controller: _deliveryDateController,
                      label: lang.t("expectedDeliveryDate"),
                      hint: lang.t("dateFormatHint"),
                      icon: Icons.calendar_month_outlined,
                      validator: _validateDeliveryDate,
                      readOnly: true,
                      onTap: _selectDeliveryDate,
                    ),
                    const SizedBox(height: 14),
                    _messageField(),
                    const SizedBox(height: 26),
                    SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isSubmitting
                            ? null
                            : _submitInquiry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreen,
                          disabledBackgroundColor: isDark
                              ? darkGreen.withOpacity(0.45)
                              : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: provider.isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                lang.t("submitInquiry"),
                                style: const TextStyle(
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
      ),
    );
  }

  Widget _cropSummaryCard(CropModel crop) {
    final lang = context.watch<LanguageProvider>();
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
                  color: isDark
                      ? const Color(0xff1E1E1E)
                      : const Color(0xffEAF7EF),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: isDark ? Colors.white60 : darkGreen,
                  ),
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
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  crop.farmerName.trim().isNotEmpty
                      ? crop.farmerName
                      : context.watch<LanguageProvider>().t("unknownFarmer"),
                  style: TextStyle(
                    fontSize: 13,
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rs. ${crop.price} / ${lang.tDynamic(crop.unit)}",
                  style: TextStyle(
                    fontSize: 15,
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lang
                      .t("availableValue")
                      .replaceAll('{quantity}', crop.quantity.toString())
                      .replaceAll('{unit}', lang.tDynamic(crop.unit)),
                  style: TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                    fontWeight: FontWeight.w600,
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
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
    String? prefixText,
    String? suffixText,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
      cursorColor: accentColor,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
        prefixText: prefixText,
        suffixText: suffixText,
      ),
    );
  }

  Widget _messageField() {
    return TextFormField(
      controller: _messageController,
      minLines: 4,
      maxLines: 6,
      maxLength: 2000,
      validator: _validateMessage,
      style: TextStyle(color: primaryText, fontWeight: FontWeight.w600),
      cursorColor: accentColor,
      decoration: _inputDecoration(
        label: context.read<LanguageProvider>().t("message"),
        hint: context.read<LanguageProvider>().t("messageFarmerHint"),
        icon: Icons.message_outlined,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    String? prefixText,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: accentColor),
      prefixText: prefixText,
      suffixText: suffixText,
      labelStyle: TextStyle(
        color: isDark ? Colors.white60 : const Color(0xff5F675F),
      ),
      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
      prefixStyle: TextStyle(color: primaryText, fontWeight: FontWeight.w700),
      suffixStyle: TextStyle(color: secondaryText, fontWeight: FontWeight.w700),
      errorStyle: TextStyle(
        color: isDark ? Colors.red.shade200 : Colors.red,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: isDark ? darkCard : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(color: accentColor, width: 1.4),
      errorBorder: _inputBorder(
        color: isDark ? Colors.red.shade200 : Colors.red,
      ),
      focusedErrorBorder: _inputBorder(
        color: isDark ? Colors.red.shade200 : Colors.red,
        width: 1.4,
      ),
    );
  }

  OutlineInputBorder _inputBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: color ?? (isDark ? Colors.white12 : const Color(0xffDCE7DD)),
        width: width,
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: isDark ? darkCard : Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xffDCE7DD),
      ),
    );
  }
}
