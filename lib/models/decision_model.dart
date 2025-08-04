class DecisionModel {
  final String? id;
  final String title;
  final String description;
  final String decisionNumber;
  final DateTime decisionDate;
  //مسار ملف المسودة (PDF)
  final String draftPdfPath;
  final List<String> attachments;
  final DateTime? createdAt;

  DecisionModel({
    this.id,
    required this.title,
    required this.description,
    required this.decisionNumber,
    required this.decisionDate,
    required this.draftPdfPath,
    required this.attachments,
    this.createdAt,
  });

  factory DecisionModel.fromJson(Map<String, dynamic> json) {
    return DecisionModel(
      id: json['id'],
      title: json['title'],
      description: json[' description'],
      decisionNumber: json['decisionNumber'],
      decisionDate: DateTime.parse(json['decisionDate']),
      draftPdfPath: json['draftPdfPath'],
      attachments: List<String>.from(json['attachments']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'decisionNumber': decisionNumber,
      'decisionDate': decisionDate.toIso8601String(),
      'draftPdfPath': draftPdfPath,
      'attachments': attachments,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
