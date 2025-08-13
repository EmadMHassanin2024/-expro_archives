part of 'decision_cubit.dart';

@immutable
abstract class DecisionCubitState {}

/// الحالة الابتدائية
class DecisionCubitInitial extends DecisionCubitState {}

/// الحالة أثناء التحميل أو الانتظار
class DecisionCubitLoading extends DecisionCubitState {}

/// عند نجاح تحميل أو حفظ القرار
class DecisionCubitSuccess extends DecisionCubitState {
  final DecisionModel decision;

  DecisionCubitSuccess(this.decision);
}

/// عند حدوث خطأ
class DecisionCubitError extends DecisionCubitState {
  final String message;

  DecisionCubitError(this.message);
}

/// عند تحديث حقل واحد في النموذج
class DecisionCubitUpdated extends DecisionCubitState {
  final DecisionModel updatedDecision;

  DecisionCubitUpdated(this.updatedDecision);
}
