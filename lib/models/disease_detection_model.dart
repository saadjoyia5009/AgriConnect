class TreatmentStepModel {
  final String title;
  final String description;

  TreatmentStepModel({required this.title, required this.description});
}

class DiseaseDetectionModel {
  final String diseaseName;
  final String scientificName;
  final int confidence;
  final String status;
  final List<TreatmentStepModel> treatmentPlan;

  DiseaseDetectionModel({
    required this.diseaseName,
    required this.scientificName,
    required this.confidence,
    required this.status,
    required this.treatmentPlan,
  });
}
