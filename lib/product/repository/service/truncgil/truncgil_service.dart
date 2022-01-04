import 'dart:io';
import '../../../../core/enums/dotenv_enums.dart';
import '../../../../core/init/network/core_dio.dart';
import '../../../../core/model/error_model/base_error_model.dart';
import '../../../../core/model/response_model/IResponse_model.dart';
import '../../../../core/model/response_model/response_model.dart';
import '../../../response_models/truncgil/truncgil_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TruncgilService {
  static TruncgilService? _instance;
  static TruncgilService get instance {
    _instance ??= TruncgilService._init();
    return _instance!;
  }

  CoreDio? coreDio;
  TruncgilService._init() {
    final baseOptions = BaseOptions();
    coreDio = CoreDio(baseOptions);

    coreDio?.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        List<Truncgil> truncgilList = [];

        if (response.data is Map) {
          var keys = (response.data as Map).keys.toList();
          var values = (response.data as Map).values.toList();
          // I MADE IT BECAUSE API IS AWESOMEEEEEE!!!!!!!!!!!
          for (var i = 1; i < keys.length; i++) {
            var truncgil = Truncgil.fromJson(values[i]);
            if (truncgil.buy!.contains("\$")) {
              truncgil.buy = truncgil.buy!.substring(1);
              truncgil.sell = truncgil.sell!.substring(
                  1); // amaa bu altının onsunu tl olarlak göstericek bu yüzdeen bunu listeden silebilirsin veya direk modele currency ekle
            }
            String? lastUpdate;
            if (response.data["Update_Date"] != null) {
              lastUpdate = response.data["Update_Date"].split(" ")[1];
            }
            truncgil.updateDate = lastUpdate ?? "";
            truncgil.name = keys[i];
            truncgil.change = truncgil.change?.substring(1);
            truncgil.change = truncgil.change?.replaceAll(",", ".");
            truncgil.buy = truncgil.buy?.replaceAll(".", "");
            truncgil.buy = truncgil.buy?.replaceAll(",", ".");
            truncgil.sell = truncgil.sell?.replaceAll(".", "");
            truncgil.sell = truncgil.sell?.replaceAll(",", ".");

            truncgil.id = keys[i] + "truncgil";
            truncgilList.add(truncgil);
          }
        }
        response.data = truncgilList;
        return handler.next(response);
      },
    ));
  }

  @override
  Future<IResponseModel<List<Truncgil>>> getAllTruncgil() async {
    var response = await coreDio!
        .get<List<Truncgil>>(dotenv.get(DotEnvEnums.BASE_URL_TRUNCGIL.name));
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.accepted:
        return ResponseModel<List<Truncgil>>(data: response.data);

      default:
        print("status code ${response.statusCode}   ${response.statusMessage}");
        return ResponseModel<List<Truncgil>>(error: BaseError('message'));
    }
  }
}
