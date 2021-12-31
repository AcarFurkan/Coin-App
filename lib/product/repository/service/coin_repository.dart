 
 /*
abstract class BaseRepository {
  Future<List<MainCurrencyModel>> getAllCoinsBitexen();
  Future<MainCurrencyModel> getCoinByNameFromGecho(String name);
  Future<List<MainCurrencyModel>> getCoinAllCoinListFromCoinGecko();
}

class CoinListRepository implements BaseRepository {
  @override
  Future<List<MainCurrencyModel>> getAllCoinsBitexen() async {
    String baseUrl = dotenv.get(DotEnvEnums.BASE_URL_BITEXEN.name);

    List<MainCurrencyModel> _myCoinsList = [];
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
            _myCoinsList.add(MainCurrencyModel(
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
  Future<List<MainCurrencyModel>> getCoinAllCoinListFromCoinGecko() async {
    String baseUrl = dotenv.get(DotEnvEnums.BASE_URL_COIN_GECHO.name);
    baseUrl = baseUrl +
        "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false";

    List<MainCurrencyModel> _myCoinsList = [];
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
  Future<List<MainCurrencyModel>> getAllMarketShare() async {
    String baseUrl = dotenv.get(DotEnvEnums.BASE_URL_SHARE_MARKET.name);
    baseUrl = baseUrl + "hisse/list";

    List<MainCurrencyModel> _myCoinsList = [];
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

  MainCurrencyModel coinGenerator(Gecho coin) {
    String changeOf24Hour =
        percentageCotnrol((coin.priceChangePercentage24H ?? 0).toString());
    return MainCurrencyModel(
        counterCurrencyCode: "USD",
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
  Future<MainCurrencyModel> getCoinByNameFromGecho(String name) async {
    MainCurrencyModel _myCoin =
        MainCurrencyModel(name: "name", lastPrice: "0", id: "id");
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

          _myCoin = MainCurrencyModel(
              counterCurrencyCode: "USD",
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
*/