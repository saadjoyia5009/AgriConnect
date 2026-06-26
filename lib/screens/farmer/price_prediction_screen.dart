import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/price_prediction_provider.dart';
import '../../models/price_prediction_model.dart';

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

  @override
  void dispose() {
    quantityController.dispose();
    marketController.dispose();
    super.dispose();
  }

  void _predictPrice() {
    if (selectedCrop == null ||
        quantityController.text.trim().isEmpty ||
        marketController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all prediction parameters"),
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

    return Scaffold(
      backgroundColor: const Color(0xfff9fbfa),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              const SizedBox(height: 28),

              const Text(
                "Price Prediction",
                style: TextStyle(
                  color: Color(0xff075739),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Forecast market prices to optimize your selling strategy.",
                style: TextStyle(
                  color: Color(0xff202525),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 28),

              _parametersCard(provider),

              const SizedBox(height: 22),

              if (provider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(
                      color: Color(0xff075739),
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
          backgroundImage: NetworkImage("https://i.pravatar.cc/100?img=8"),
        ),
      ],
    );
  }

  Widget _parametersCard(PricePredictionProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Prediction Parameters",
            style: TextStyle(
              color: Color(0xff075739),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),

          const Text(
            "Crop Type",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xff202525),
            ),
          ),
          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: selectedCrop,
            hint: const Text("Select a crop"),
            items: cropTypes.map((crop) {
              return DropdownMenuItem(
                value: crop,
                child: Text(crop),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedCrop = value);
            },
            decoration: _inputDecoration(Icons.eco_outlined),
          ),

          const SizedBox(height: 18),

          const Text(
            "Quantity (Tons)",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xff202525),
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(Icons.hourglass_empty).copyWith(
              hintText: "e.g., 50",
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Market Location",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xff202525),
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: marketController,
            decoration: _inputDecoration(Icons.location_on_outlined).copyWith(
              hintText: "e.g., Sahiwal Market",
            ),
          ),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: provider.isLoading ? null : _predictPrice,
              icon: const Icon(Icons.insert_chart_outlined, size: 18),
              label: const Text(
                "Predict Price",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff075739),
                foregroundColor: Colors.white,
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

  Widget _estimatedValueCard(PricePredictionModel prediction) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Estimated Market Value",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff4f5b56),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Text(
                prediction.estimatedRange,
                style: const TextStyle(
                  color: Color(0xff075739),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                prediction.unit,
                style: const TextStyle(
                  color: Color(0xff202525),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xffcdeed3),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              prediction.changePercent,
              style: const TextStyle(
                color: Color(0xff075739),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xfff1f2f1),
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                left: BorderSide(
                  color: Color(0xff075739),
                  width: 4,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xff075739),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "AI Recommendation\n${prediction.recommendation}",
                    style: const TextStyle(
                      color: Color(0xff202525),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Prediction Confidence",
            style: TextStyle(
              color: Color(0xff4f5b56),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "${prediction.confidence}%",
                style: const TextStyle(
                  color: Color(0xff075739),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.settings_outlined,
                color: Color(0xff075739),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: prediction.confidence / 100,
            minHeight: 7,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: const Color(0xffd8dedb),
            color: const Color(0xff075739),
          ),
        ],
      ),
    );
  }

  Widget _highCard(PricePredictionModel prediction) {
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
                const Text(
                  "30-Day High",
                  style: TextStyle(
                    color: Color(0xff6d7471),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  prediction.thirtyDayHigh,
                  style: const TextStyle(
                    color: Color(0xff075739),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Recorded\n${prediction.recordedDate}",
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xff6d7471),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xff075739)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xffcfd8d3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xff075739)),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xffbfe8ce)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}