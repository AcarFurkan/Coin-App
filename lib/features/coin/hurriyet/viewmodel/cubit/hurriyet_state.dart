part of 'hurriyet_cubit.dart';

@immutable
abstract class HurriyetState {}

class HurriyetInitial extends HurriyetState {}

class HurriyetLoading extends HurriyetState {}

class HurriyetCompleted extends HurriyetState {
  final List<MainCurrencyModel> hurriyetCoinsList;

  HurriyetCompleted({
    required this.hurriyetCoinsList,
  });
}

class HurriyetError extends HurriyetState {
  final String message;
  HurriyetError(this.message);
}
