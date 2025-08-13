import 'package:expro_archives/models/workflow_step.dart';

class DecisionModel {
  final String? id;

  final String title;
  final String description;
  final String decisionNumber;
  final DateTime decisionDate;
  final String ownerName;
  final String area;
  final String region;
  final String? draftDecisionPath;
  final String? draftCeoLetterPath;
  final String? draftMinisterialPath;

  final String? draftPdfPath;

  final List<String> attachments;

  final DateTime? createdAt;

  final List<WorkflowStep> workflowSteps;

  DecisionModel({
    this.id,
    required this.title,
    required this.description,
    required this.decisionNumber,
    required this.decisionDate,
    required this.ownerName,
    required this.area,
    required this.region,
    required this.draftPdfPath,
    this.draftDecisionPath,
    this.draftCeoLetterPath,
    this.draftMinisterialPath,
    required this.attachments,
    this.createdAt,
    required this.workflowSteps,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'decisionNumber': decisionNumber,
      'decisionDate': decisionDate.toIso8601String(),
      'ownerName': ownerName,
      'area': area,
      'region': region,
      'draftPdfPath': draftPdfPath,
      'attachments': attachments,
      'createdAt': createdAt?.toIso8601String(),
      'workflowSteps': workflowSteps.map((step) => step.toJson()).toList(),
    };
  }

  DecisionModel copyWith({
    String? id,
    String? title,
    String? description,
    String? decisionNumber,
    DateTime? decisionDate,
    String? ownerName,
    String? area,
    String? region,
    String? draftPdfPath,
    List<String>? attachments,
    DateTime? createdAt,
    List<WorkflowStep>? workflowSteps,
  }) {
    return DecisionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      decisionNumber: decisionNumber ?? this.decisionNumber,
      decisionDate: decisionDate ?? this.decisionDate,
      ownerName: ownerName ?? this.ownerName,
      area: area ?? this.area,
      region: region ?? this.region,
      draftPdfPath: draftPdfPath ?? this.draftPdfPath,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      workflowSteps: workflowSteps ?? this.workflowSteps,
    );
  }
}
