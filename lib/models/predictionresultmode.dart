class PredictionResult {
  final bool success;
  final String? reason;
  final String? classEn;
  final String? classVi;
  final double? confidence;
  final String? originalImage;

  PredictionResult({
    required this.success,
    this.reason,
    this.classEn,
    this.classVi,
    this.confidence,
    this.originalImage,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      success: json['success'] ?? false,
      reason: json['reason'],
      classEn: json['class_en'],
      classVi: json['class_vi'],
      confidence: json['confidence']?.toDouble(),
      originalImage: json['original_image'],
    );
  }
}
