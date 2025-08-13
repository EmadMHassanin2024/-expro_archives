class WorkflowStep {
  final int order;
  final String title;
  final bool isCompleted;
  final DateTime? completedAt;
  final String stepName;

  WorkflowStep({
    required this.order,
    required this.title,
    this.isCompleted = false,
    this.completedAt,
    required this.stepName,
  });

  factory WorkflowStep.fromJson(Map<String, dynamic> json) {
    return WorkflowStep(
      order: json['order'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      stepName: json['stepName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'title': title,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'stepName': stepName,
    };
  }

  WorkflowStep copyWith({
    int? order,
    String? title,
    bool? isCompleted,
    DateTime? completedAt,
    String? stepName,
    bool? completed,
  }) {
    return WorkflowStep(
      order: order ?? this.order,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      stepName: stepName ?? this.stepName,
    );
  }
}
