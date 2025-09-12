class OfferPackageModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final int durationDays;

  const OfferPackageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.durationDays,
  });
}



