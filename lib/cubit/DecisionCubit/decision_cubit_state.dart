part of 'decision_cubit.dart';

@immutable
abstract class DecisionCubitState {}

class DecisionCubitInitial extends DecisionCubitState {}

class DecisionCubitLoading extends DecisionCubitState {}

class DecisionCubitSuccess extends DecisionCubitState {
  final DecisionModel decision;
  DecisionCubitSuccess(this.decision);
}

class DecisionCubitError extends DecisionCubitState {
  final String message;
  DecisionCubitError(this.message);
}

class DecisionCubitUpdated extends DecisionCubitState {
  final DecisionModel updatedDecision;
  DecisionCubitUpdated(this.updatedDecision);
}

class DecisionLoaded extends DecisionCubitState {
  final List<DecisionModel> decisions;
  DecisionLoaded(this.decisions);
}
