import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../core/enums/dotenv_enums.dart';
import '../../../../../core/init/network/core_dio.dart';
import '../../../../../core/model/error_model/base_error_model.dart';
import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../core/model/response_model/response_model.dart';
import '../../../../response_models/hurriyet/hurriyet_response_model.dart';

class HurriyetService {
  static HurriyetService? _instance;
  static HurriyetService get instance {
    _instance ??= HurriyetService._init();
    return _instance!;
  }

  CoreDio? coreDioForName;
  CoreDio? coreDioForList;

  HurriyetService._init() {
    coreDioForName = CoreDio(BaseOptions(
        baseUrl: dotenv.get(DotEnvEnums.BASE_URL_SHARE_MARKET.name)));

    coreDioForName?.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        List<String> kods = [];
        if (response.data is Map) {
          List list = response.data["data"];
          for (var i = 0; i < list.length; i++) {
            kods.add(list[i]["kod"]);
          }
        }
        response.data = kods;
        return handler.next(response);
      },
    ));
    coreDioForList = CoreDio(BaseOptions(
        baseUrl: dotenv.get(DotEnvEnums.BASE_URL_SHARE_MARKET.name)));
    coreDioForList?.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        if (response.data is Map) {
          //2021-12-30T18:08:41+03:00
          response.data =
              Hurriyet.fromJson(response.data["data"]["hisseYuzeysel"]);
          (response.data as Hurriyet).tarih =
              (response.data as Hurriyet).tarih?.toLocal();
        }
        return handler.next(response);
      },
    ));
  }

  @override
  Future<IResponseModel<List<String>>> getAllHurriyetStockName() async {
    var response = await coreDioForName!.get<List<String>>("hisse/list");
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.accepted:
        return ResponseModel<List<String>>(data: response.data);

      default:
        return ResponseModel<List<String>>(error: BaseError('message'));
    }
  }

  @override
  Future<IResponseModel<Hurriyet>> getHurriyetStockByName(
      String stockName) async {
    var response =
        await coreDioForList!.get<Hurriyet>("/borsa/hisseyuzeysel/$stockName");
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.accepted:
        return ResponseModel<Hurriyet>(data: response.data);

      default:
        return ResponseModel<Hurriyet>(error: BaseError('message'));
    }
  }

  @override
  Future<IResponseModel<List<Hurriyet>>> getAllHurriyetStocks() async {
    IResponseModel<List<String>> responseList = await getAllHurriyetStockName();
    List<Hurriyet> stockList = [];
    if (responseList.data != null) {
      for (var i = 0; i < responseList.data!.length; i++) {
        await Future.delayed(Duration(milliseconds: 50));
        try {
          final response2 = await getHurriyetStockByName(responseList.data![i]);
          if (response2.data != null) {
            stockList.add(response2.data!);
          } else {}
        } catch (e) {}
      }
      print(stockList.length);

      return ResponseModel<List<Hurriyet>>(
          data: stockList, error: responseList.error);
    }
    return ResponseModel<List<Hurriyet>>(error: responseList.error);
  }
}
