import '../../../models/workflow_step.dart';

class WorkflowState {
  final List<WorkflowStep> steps;

  WorkflowState({required this.steps});

  WorkflowState copyWith({List<WorkflowStep>? steps}) {
    return WorkflowState(steps: steps ?? this.steps);
  }

  factory WorkflowState.fromJson(Map<String, dynamic> json) {
    return WorkflowState(
      steps: (json['steps'] as List<dynamic>)
          .map((e) => WorkflowStep.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'steps': steps.map((e) => e.toJson()).toList()};
  }
}
