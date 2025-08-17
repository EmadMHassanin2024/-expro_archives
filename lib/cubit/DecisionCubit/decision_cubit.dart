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
  List<DecisionModel> allDecisions = [];

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
      emit(DecisionCubitLoading());

      final decisionId = const Uuid().v4();

      final currentDecision = DecisionModel(
        id: decisionId,
        title: title,
        description: description,
        decisionNumber: decisionNumber,
        decisionDate: decisionDate,
        ownerName: ownerName,
        area: area,
        region: region,
        createdAt: createdAt,
        draftUrl: draftPdfPath,
        attachments: attachments,
        workflowSteps: workflowSteps,
        searchKeywords: [],
      );

      await FirebaseFirestore.instance
          .collection('decisions')
          .doc(decisionId)
          .set(currentDecision.toJson());

      _currentDecision = currentDecision;

      emit(DecisionCubitSuccess(currentDecision));
      return decisionId;
    } catch (e) {
      emit(DecisionCubitError("حدث خطأ أثناء إضافة القرار: $e"));
      rethrow;
    }
  }

  void updateField({required DecisionModel updated}) {
    _currentDecision = updated;
    emit(DecisionCubitUpdated(updated));
  }

  void loadDecisions(List<DecisionModel> decisions) {
    allDecisions = decisions;
    emit(DecisionLoaded(decisions));
  }

  void filterDecisions(String query) {
    emit(DecisionLoaded(allDecisions));

    final filtered = allDecisions.where((decision) {
      final ownerLower = decision.ownerName.toLowerCase();
      final regionLower = decision.region.toLowerCase();
      final searchLower = query.toLowerCase();
      return ownerLower.contains(searchLower) ||
          regionLower.contains(searchLower);
    }).toList();

    emit(DecisionLoaded(filtered)); // عرض البيانات بعد البحث
  }
}
