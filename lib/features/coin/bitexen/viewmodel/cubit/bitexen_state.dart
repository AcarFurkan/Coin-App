part of 'bitexen_cubit.dart';

@immutable
abstract class BitexenState {}

class BitexenInitial extends BitexenState {}

class BitexenLoading extends BitexenState {}

class BitexenCompleted extends BitexenState {
  final List<MainCurrencyModel> bitexenCoinsList;

  BitexenCompleted({
    required this.bitexenCoinsList,
  });
}

class BitexenError extends BitexenState {
  final String message;
  BitexenError(this.message);
}
