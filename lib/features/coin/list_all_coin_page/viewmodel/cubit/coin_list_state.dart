part of 'coin_list_cubit.dart';

@immutable
abstract class CoinListState {}

class CoinListInitial extends CoinListState {}

class CoinListLoading extends CoinListState {}

class CoinListCompleted extends CoinListState {
  final List<MyCoin> tryCoinsList;
  final List<MyCoin> usdtCoinsList;
  final List<MyCoin> btcCoinsList;
  final List<MyCoin> ethCoinsList;
  final List<MyCoin> gechoCoinsList;
  CoinListCompleted({
    required this.usdtCoinsList,
    required this.btcCoinsList,
    required this.ethCoinsList,
    required this.tryCoinsList,
    required this.gechoCoinsList,
  });
}

class CoinListError extends CoinListState {
  final String message;
  CoinListError(this.message);
}
