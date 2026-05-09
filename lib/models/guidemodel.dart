class GuideModel {
  final String idFE;
  final String title;
  final String definition;
  final String symtomz;
  final String measurement;
  final String cause;
  final String speadrisk;
  final String humidity;
  final String severity;

  GuideModel({
    required this.idFE,
    required this.title,
    required this.definition,
    required this.symtomz,
    required this.measurement,
    required this.cause,
    required this.speadrisk,
    required this.humidity,
    required this.severity,
  });

  factory GuideModel.fromJson(Map<String, dynamic> json) {
    return GuideModel(
      idFE: json['idFE'] ?? '',
      title: json['title'] ?? '',
      definition: json['definition'] ?? '',
      symtomz: json['symtomz'] ?? '',
      measurement: json['measurement'] ?? '',
      cause: json['cause'] ?? '',
      speadrisk: json['speadrisk'] ?? '',
      humidity: json['humidity'] ?? '',
      severity: json['severity'] ?? '',
    );
  }
}
