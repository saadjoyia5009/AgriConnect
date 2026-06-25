class InquiryModel {
  final String id;
  final String cropName;
  final String cropGrade;
  final String cropImage;
  final String buyerName;
  final String buyerInitials;
  final String requestedQuantity;
  final String proposedPrice;
  final String status;

  InquiryModel({
    required this.id,
    required this.cropName,
    required this.cropGrade,
    required this.cropImage,
    required this.buyerName,
    required this.buyerInitials,
    required this.requestedQuantity,
    required this.proposedPrice,
    required this.status,
  });
}