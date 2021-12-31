part of 'truncgil_cubit.dart';

@immutable
abstract class TruncgilState {}

class TruncgilInitial extends TruncgilState {}

class TruncgilLoading extends TruncgilState {}

class TruncgilCompleted extends TruncgilState {
  final List<MainCurrencyModel> truncgilCoinsList;

  TruncgilCompleted({
    required this.truncgilCoinsList,
  });
}

class TruncgilError extends TruncgilState {
  final String message;
  TruncgilError(this.message);
}
