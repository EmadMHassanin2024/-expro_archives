import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expro_archives/models/workflow_step.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:expro_archives/models/decision_model.dart';

part 'decision_cubit_state.dart';

class DecisionCubit extends Cubit<DecisionCubitState> {
  DecisionCubit() : super(DecisionCubitInitial());

  DecisionModel? _currentDecision;

  DecisionModel get currentDecision => _currentDecision!;
  Future<String> addDecision({
    required String title,
    required String description,
    required String decisionNumber,
    required DateTime decisionDate,
    required String ownerName,
    required String area,
    required String region,
    required DateTime createdAt,
    required String draftPdfPath,
    required List<String> attachments,
    required List<WorkflowStep> workflowSteps,
    String? draftCeoLetterPath,
    String? draftMinisterialPath,
  }) async {
    try {
      // إنشاء معرف القرار
      final decisionId = const Uuid().v4();

      final newDecision = DecisionModel(
        id: decisionId,
        title: title,
        description: description,
        decisionNumber: decisionNumber,
        decisionDate: decisionDate,
        ownerName: ownerName,
        area: area,
        region: region,
        createdAt: createdAt,
        draftPdfPath: draftPdfPath,
        attachments: attachments,
        workflowSteps: workflowSteps,
      );

      // في المستقبل ممكن تحفظه في Firebase
      await FirebaseFirestore.instance
          .collection('decisions')
          .doc(decisionId)
          .set(newDecision.toJson());

      _currentDecision = newDecision;
      emit(DecisionCubitSuccess(newDecision));

      // إرجاع معرف القرار
      return decisionId;
    } catch (e) {
      emit(DecisionCubitError("حدث خطأ أثناء إضافة القرار: $e"));
      rethrow; // عشان لو حابب تتعامل مع الخطأ فوق
    }
  }

  void updateField({required DecisionModel updated}) {
    _currentDecision = updated;
    emit(DecisionCubitUpdated(updated));
  }
}
