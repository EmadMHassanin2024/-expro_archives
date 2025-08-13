import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/workflow_step.dart';
import 'workflow_state.dart';

class WorkflowCubit extends Cubit<WorkflowState> {
  WorkflowCubit() : super(WorkflowState(steps: _generateInitialSteps()));

  static List<WorkflowStep> _generateInitialSteps() {
    return [
      WorkflowStep(
        order: 1,
        title: "رفع مسودة قرار النزع + المرفقات",
        stepName: "رفع مسودة قرار النزع + المرفقات",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 2,
        title: "رفع قرار النزع المعتمد",
        stepName: "رفع قرار النزع المعتمد",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 3,
        title: "توليد 8 خطابات",
        stepName: "توليد 8 خطابات",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 4,
        title: "اعتماد الخطابات وإرسالها بالبريد والواتس",
        stepName: "اعتماد الخطابات وإرسالها بالبريد والواتس",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 5,
        title: "توليد مسودة محضر التقدير ومحضر الحصر",
        stepName: "توليد مسودة محضر التقدير ومحضر الحصر",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 6,
        title: "رفع الردود على الخطابات",
        stepName: "رفع الردود على الخطابات",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 7,
        title: "إرسال إشعار باكتمال الردود",
        stepName: "إرسال إشعار باكتمال الردود",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 8,
        title: "رفع محضر لجنة التقدير ومحضر لجنة الحصر المعتمدين",
        stepName: "رفع محضر لجنة التقدير ومحضر لجنة الحصر المعتمدين",
        isCompleted: false,
      ),
      WorkflowStep(
        order: 9,
        title: "تجميع كافة المرفقات وإرسالها",
        stepName: "تجميع كافة المرفقات وإرسالها",
        isCompleted: false,
      ),
    ];
  }

  void completeStep(int index) {
    final updatedSteps = List<WorkflowStep>.from(state.steps);
    updatedSteps[index] = updatedSteps[index].copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
    emit(state.copyWith(steps: updatedSteps));
  }

  void toggleStepCompletion(int index) {
    final updatedSteps = List<WorkflowStep>.from(state.steps);
    final current = updatedSteps[index];
    updatedSteps[index] = current.copyWith(
      isCompleted: !current.isCompleted,
      completedAt: current.isCompleted ? null : DateTime.now(),
    );
    emit(state.copyWith(steps: updatedSteps));
  }

  void resetAll() {
    emit(WorkflowState(steps: _generateInitialSteps()));
  }
}
