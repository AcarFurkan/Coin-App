import 'dart:convert';
import 'dart:io';

import '../../../core/enums/dotenv_enums.dart';
import '../../../core/enums/price_control.dart';
import '../../model/gecho/gecho_service_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../product/model/my_coin_model.dart';
import '../../../features/coin/list_all_coin_page/model/coin_list_model.dart';

abstract class BaseRepository {
  Future<List<MyCoin>> getAllCoins();
  Future<MyCoin> getCoinByNameFromGecho(String name);
  Future<List<MyCoin>> getCoinAllCoinListFromCoinGecko();
}

class CoinListRepository implements BaseRepository {
  @override
  Future<List<MyCoin>> getAllCoins() async {
    String baseUrl = dotenv.get(DotEnvEnums.BASE_URL_BITEXEN.name);

    List<MyCoin> _myCoinsList = [];
    Uri baseUri = Uri.parse(baseUrl);
    final response = await http.get(baseUri);
    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonBody = jsonDecode(response.body);

        var dataa = CoinList.fromJson(jsonBody);

        var ticker = Data.fromJson(dataa.data!.toJson());

        var keys = ticker.ticker!.keys.toList();
        var values = ticker.ticker!.values.toList();

        if (_myCoinsList.isEmpty) {
          for (var i = 0; i < keys.length; i++) {
            _myCoinsList.add(MyCoin(
                counterCurrencyCode: values[i].market!.counterCurrencyCode!,
                name: values[i].market!.baseCurrencyCode!,
                lastPrice: values[i].lastPrice!,
                id: values[i].market!.marketCode ?? "",
                changeOf24H: values[i].change24H,
                lowOf24h: values[i].low24H,
                highOf24h: values[i].high24H));
          }
        } else {
          for (var i = 0; i < keys.length; i++) {
            _myCoinsList[i].lastPrice = values[i].lastPrice!;
            _myCoinsList[i].changeOf24H = values[i].change24H!;
            _myCoinsList[i].lowOf24h = values[i].low24H!;
            _myCoinsList[i].highOf24h = values[i].high24H!;
          }
        }

        return _myCoinsList;
      default:
        throw NetworkError(response.statusCode.toString(), response.body);
    }
  }

  @override
  Future<List<MyCoin>> getCoinAllCoinListFromCoinGecko() async {
    String baseUrl = dotenv.get(DotEnvEnums.BASE_URL_COIN_GECHO.name);
    baseUrl = baseUrl +
        "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false";

    List<MyCoin> _myCoinsList = [];
    Uri baseUri = Uri.parse(baseUrl);
    final response = await http.get(baseUri);
    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonBody = jsonDecode(response.body);
        if (_myCoinsList.isEmpty) {
          _myCoinsList.clear();
          for (var i = 0; i < jsonBody.length; i++) {
            var incomingCoin = Gecho.fromJson(jsonBody[i]);
            String changeOf24Hour = percentageCotnrol(
                (incomingCoin.priceChangePercentage24H ?? 0).toString());
            _myCoinsList.add(
              coinGenerator(incomingCoin),
            );
          }
        } else {
          _myCoinsList.clear();
          for (var i = 0; i < jsonBody.length; i++) {
            var incomingCoin = Gecho.fromJson(jsonBody[i]);
            String changeOf24Hour = percentageCotnrol(
                (incomingCoin.priceChangePercentage24H ?? 0).toString());
            _myCoinsList.add(
              coinGenerator(incomingCoin),
            );
          }
        }
        return _myCoinsList;
      default:
        throw NetworkError(response.statusCode.toString(), response.body);
    }
  }

  @override
  Future<List<MyCoin>> getAllMarketShare() async {
    String baseUrl = dotenv.get(DotEnvEnums.BASE_URL_SHARE_MARKET.name);
    baseUrl = baseUrl + "hisse/list";

    List<MyCoin> _myCoinsList = [];
    Uri baseUri = Uri.parse(baseUrl);
    final response = await http.get(baseUri);
    switch (response.statusCode) {
      case HttpStatus.ok:
        print(response.body);
        /* final jsonBody = jsonDecode(response.body);
        if (_myCoinsList.isEmpty) {
          _myCoinsList.clear();
          for (var i = 0; i < jsonBody.length; i++) {
            var incomingCoin = Gecho.fromJson(jsonBody[i]);
            String changeOf24Hour = percentageCotnrol(
                (incomingCoin.priceChangePercentage24H ?? 0).toString());
            _myCoinsList.add(
              coinGenerator(incomingCoin),
            );
          }
        } else {
          _myCoinsList.clear();
          for (var i = 0; i < jsonBody.length; i++) {
            var incomingCoin = Gecho.fromJson(jsonBody[i]);
            String changeOf24Hour = percentageCotnrol(
                (incomingCoin.priceChangePercentage24H ?? 0).toString());
            _myCoinsList.add(
              coinGenerator(incomingCoin),
            );
          }
        }*/
        return _myCoinsList;
      default:
        throw NetworkError(response.statusCode.toString(), response.body);
    }
  }

  MyCoin coinGenerator(Gecho coin) {
    String changeOf24Hour =
        percentageCotnrol((coin.priceChangePercentage24H ?? 0).toString());
    return MyCoin(
        counterCurrencyCode: "USDT",
        name: coin.symbol ?? "",
        lastPrice: (coin.currentPrice ?? 0).toString(),
        id: (coin.id != null ? coin.id! + "USDT" : ""),
        changeOf24H: (coin.priceChangePercentage24H ?? 0).toString(),
        lowOf24h: (coin.low24H ?? 0).toString(),
        highOf24h: (coin.high24H ?? 0).toString(),
        percentageControl: changeOf24Hour);
  }

  String percentageCotnrol(String percentage) {
    if (percentage[0] == "-") {
      return PriceLevelControl.DESCREASING.name;
    } else if (double.parse(percentage) > 0) {
      //  L AM NOT SURE FOR THIS TRY IT
      return PriceLevelControl.INCREASING.name;
    } else {
      return PriceLevelControl.CONSTANT.name;
    }

    // return compareList;
  }

  @override
  Future<MyCoin> getCoinByNameFromGecho(String name) async {
    MyCoin _myCoin = MyCoin(name: "name", lastPrice: "0", id: "id");
    // var baseUrl ="https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$number&page=$page&sparkline=false";
    var baseUrl =
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$name&order=market_cap_desc&per_page=100&page=1&sparkline=false";
    try {
      Uri baseUri = Uri.parse(baseUrl);
      final response = await http.get(baseUri);
      switch (response.statusCode) {
        case HttpStatus.ok:
          final jsonBody = jsonDecode(response.body);

          Gecho _gechoCoinModel = Gecho.fromJson(jsonBody[0]);

          _myCoin = MyCoin(
              counterCurrencyCode: "USDT",
              name: _gechoCoinModel.id ?? name,
              lastPrice: (_gechoCoinModel.currentPrice ?? 0).toString(),
              id: _gechoCoinModel.id ?? "" "USDT",
              changeOf24H:
                  (_gechoCoinModel.priceChangePercentage24H ?? 0).toString(),
              lowOf24h: (_gechoCoinModel.low24H ?? 0).toString(),
              highOf24h: (_gechoCoinModel.high24H ?? 0).toString());

          return _myCoin;
        default:
          throw NetworkError(response.statusCode.toString(), response.body);
      }
    } catch (e) {
      print(e);
      return _myCoin;
    }
  }
}

class NetworkError implements Exception {
  final String statusCode;
  final String message;

  NetworkError(this.statusCode, this.message);
}
