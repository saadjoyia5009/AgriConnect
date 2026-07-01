import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/price_prediction_provider.dart';
import '../../models/price_prediction_model.dart';
import '../../providers/language_provider.dart';

class PricePredictionScreen extends StatefulWidget {
  const PricePredictionScreen({super.key});

  @override
  State<PricePredictionScreen> createState() => _PricePredictionScreenState();
}

class _PricePredictionScreenState extends State<PricePredictionScreen> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController marketController = TextEditingController();

  String? selectedCrop;

  final List<String> cropTypes = [
    "Wheat",
    "Rice",
    "Cotton",
    "Sugarcane",
    "Maize",
    "Tomatoes",
    "Potatoes",
  ];

  static const Color darkGreen = Color(0xff075739);
  static const Color lightBg = Color(0xfff9fbfa);
  static const Color darkBg = Color(0xff0B1410);
  static const Color darkCard = Color(0xff15251E);

  @override
  void dispose() {
    quantityController.dispose();
    marketController.dispose();
    super.dispose();
  }

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  void _predictPrice() {
    final lang = context.read<LanguageProvider>();

    if (selectedCrop == null ||
        quantityController.text.trim().isEmpty ||
        marketController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.t("fillPredictionParameters")),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<PricePredictionProvider>().predictPrice(
      cropType: selectedCrop!,
      quantity: quantityController.text.trim(),
      marketLocation: marketController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PricePredictionProvider>();
    final isDark = _isDark(context);
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: isDark ? darkBg : lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              const SizedBox(height: 28),
              Text(
                lang.t("pricePrediction"),
                style: TextStyle(
                  color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang.t("pricePredictionSubtitle"),
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xff202525),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              _parametersCard(provider),
              const SizedBox(height: 22),
              if (provider.isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: CircularProgressIndicator(
                      color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                    ),
                  ),
                )
              else if (provider.errorMessage != null)
                _errorCard(provider.errorMessage!)
              else if (provider.prediction != null) ...[
                _estimatedValueCard(provider.prediction!),
                const SizedBox(height: 22),
                _confidenceCard(provider.prediction!),
                const SizedBox(height: 22),
                _highCard(provider.prediction!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    final isDark = _isDark(context);

    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: isDark ? const Color(0xff9ff2c1) : darkGreen,
            size: 27,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              context.watch<LanguageProvider>().t("appName"),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xff9ff2c1) : darkGreen,
              ),
            ),
          ),
        ),
        const CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=8"),
        ),
      ],
    );
  }

  Widget _parametersCard(PricePredictionProvider provider) {
    final isDark = _isDark(context);
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.t("predictionParameters"),
            style: TextStyle(
              color: isDark ? const Color(0xff9ff2c1) : darkGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          _label(lang.t("cropType")),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedCrop,
            dropdownColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
            iconEnabledColor: isDark ? Colors.white70 : darkGreen,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xff26332e),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            hint: Text(
              lang.t("selectCrop"),
              style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
            ),
            decoration: _inputDecoration(Icons.eco_outlined),
            items: cropTypes.map((crop) {
              return DropdownMenuItem(
                value: crop,
                child: Text(
                  _cropLabel(crop, lang),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xff26332e),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedCrop = value);
            },
          ),
          const SizedBox(height: 18),
          _label(lang.t("quantityTons")),
          const SizedBox(height: 8),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xff26332e),
              fontWeight: FontWeight.w600,
            ),
            cursorColor: isDark ? const Color(0xff9ff2c1) : darkGreen,
            decoration: _inputDecoration(
              Icons.hourglass_empty,
            ).copyWith(hintText: lang.t("quantityHint")),
          ),
          const SizedBox(height: 18),
          _label(lang.t("marketLocation")),
          const SizedBox(height: 8),
          TextField(
            controller: marketController,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xff26332e),
              fontWeight: FontWeight.w600,
            ),
            cursorColor: isDark ? const Color(0xff9ff2c1) : darkGreen,
            decoration: _inputDecoration(
              Icons.location_on_outlined,
            ).copyWith(hintText: lang.t("marketLocationHint")),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: provider.isLoading ? null : _predictPrice,
              icon: const Icon(Icons.insert_chart_outlined, size: 18),
              label: Text(
                lang.t("predictPrice"),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                disabledBackgroundColor: darkGreen.withOpacity(0.55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _cropLabel(String crop, LanguageProvider lang) {
    return lang.tDynamic(crop);
  }

  Widget _label(String text) {
    final isDark = _isDark(context);

    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white70 : const Color(0xff202525),
      ),
    );
  }

  Widget _estimatedValueCard(PricePredictionModel prediction) {
    final isDark = _isDark(context);
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.t("estimatedMarketValue"),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : const Color(0xff4f5b56),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                prediction.estimatedRange,
                style: TextStyle(
                  color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _predictionText(prediction.unit, prediction, lang),
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xff202525),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isDark
                  ? darkGreen.withOpacity(0.25)
                  : const Color(0xffcdeed3),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              _predictionText(prediction.changePercent, prediction, lang),
              style: TextStyle(
                color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff1E1E1E) : const Color(0xfff1f2f1),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                left: BorderSide(
                  color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${lang.t("aiRecommendation")}\n${_predictionText(prediction.recommendation, prediction, lang)}",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : const Color(0xff202525),
                      fontSize: 14,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _confidenceCard(PricePredictionModel prediction) {
    final isDark = _isDark(context);
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.t("predictionConfidence"),
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xff4f5b56),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "${prediction.confidence}%",
                style: TextStyle(
                  color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.settings_outlined,
                color: isDark ? const Color(0xff9ff2c1) : darkGreen,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: prediction.confidence / 100,
            minHeight: 7,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: isDark ? Colors.white12 : const Color(0xffd8dedb),
            color: isDark ? const Color(0xff9ff2c1) : darkGreen,
          ),
        ],
      ),
    );
  }

  Widget _highCard(PricePredictionModel prediction) {
    final isDark = _isDark(context);
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.t("thirtyDayHigh"),
                  style: TextStyle(
                    color: isDark ? Colors.white60 : const Color(0xff6d7471),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  prediction.thirtyDayHigh,
                  style: TextStyle(
                    color: isDark ? const Color(0xff9ff2c1) : darkGreen,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            lang
                .t("recordedDate")
                .replaceAll("{value}", prediction.recordedDate),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: isDark ? Colors.white60 : const Color(0xff6d7471),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(String message) {
    final isDark = _isDark(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.withOpacity(0.18) : const Color(0xffffd8d5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.red.withOpacity(0.35) : Colors.transparent,
        ),
      ),
      child: Text(
        _predictionText(
          message,
          PricePredictionModel(
            cropType: selectedCrop ?? "",
            quantity: "",
            marketLocation: marketController.text.trim(),
            estimatedRange: "",
            unit: "",
            changePercent: "",
            recommendation: "",
            confidence: 0,
            thirtyDayHigh: "",
            recordedDate: "",
          ),
          context.watch<LanguageProvider>(),
        ),
        style: TextStyle(
          color: isDark ? Colors.red.shade200 : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _predictionText(
    String text,
    PricePredictionModel prediction,
    LanguageProvider lang,
  ) {
    switch (text) {
      case "per Ton":
        return lang.t("perTon");
      case "+5.2% vs last month":
        return lang.t("vsLastMonth");
      case "Failed to predict price":
        return lang.t("failedPredictPrice");
      default:
        if (text == prediction.recommendation && text.isNotEmpty) {
          return lang
              .t("priceRecommendationTemplate")
              .replaceAll("{crop}", lang.tDynamic(prediction.cropType))
              .replaceAll("{market}", prediction.marketLocation);
        }
        return lang.tDynamic(text);
    }
  }

  InputDecoration _inputDecoration(IconData icon) {
    final isDark = _isDark(context);

    return InputDecoration(
      prefixIcon: Icon(icon, color: isDark ? Colors.white60 : darkGreen),
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : Colors.grey,
        fontSize: 13,
      ),
      filled: true,
      fillColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(
          color: isDark ? Colors.white24 : const Color(0xffcfd8d3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(
          color: isDark ? const Color(0xff9ff2c1) : darkGreen,
          width: 1.3,
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    final isDark = _isDark(context);

    return BoxDecoration(
      color: isDark ? darkCard : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xffbfe8ce),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.18 : 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
