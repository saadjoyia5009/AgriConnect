class PricePredictionModel {
  final String cropType;
  final String quantity;
  final String marketLocation;
  final String estimatedRange;
  final String unit;
  final String changePercent;
  final String recommendation;
  final int confidence;
  final String thirtyDayHigh;
  final String recordedDate;

  PricePredictionModel({
    required this.cropType,
    required this.quantity,
    required this.marketLocation,
    required this.estimatedRange,
    required this.unit,
    required this.changePercent,
    required this.recommendation,
    required this.confidence,
    required this.thirtyDayHigh,
    required this.recordedDate,
  });
}