import 'dart:convert';
import 'dart:io';

import 'package:coin_with_architecture/core/enums/dotenv_enums.dart';
import 'package:coin_with_architecture/core/enums/http_request_enum.dart';
import 'package:coin_with_architecture/core/init/network/core_dio.dart';
import 'package:coin_with_architecture/core/init/network/network_manager.dart';
import 'package:coin_with_architecture/product/model/gecho/gecho_service_model.dart';
import 'package:coin_with_architecture/product/repository/service/coin_repository.dart';
import 'package:coin_with_architecture/product/widget/component/coin_current_info_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../viewmodel/general/cubit/selected_page_general_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';

import '../../coin_detail_page/view/coin_detail_page.dart';
import '../viewmodel/cubit/coin_cubit.dart';
import 'package:http/http.dart' as http;

part './subView/selected_coin_page_extension.dart';

class SelectedCoinPage extends StatelessWidget {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  List<MyCoin> searchresult = [];

  SelectedCoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<SelectedPageGeneralCubit>().textEditingController =
        _searchTextEditingController;
    return Scaffold(
      appBar: appBar(context),
      body: SizedBox(
        child: _blocConsumer(),
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: LocaleText(text: LocaleKeys.appBarTitle),
      actions: [
        IconButton(
            onPressed: () {
              context.read<CoinCubit>().stopMusic();
            },
            icon: const Icon(Icons.music_off)),
        IconButton(
            onPressed: () {
              context.read<SelectedPageGeneralCubit>().setIsDeletedPageOpen();
              if (context.read<SelectedPageGeneralCubit>().isDeletedPageOpen) {
                context.read<CoinCubit>().updatePage();
              } else {
                context.read<CoinCubit>().startAgain();
              }
            },
            icon: const Icon(Icons.delete)),
        openSearchField(context)
      ],
    );
  }

  IconButton openSearchField(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        //getAllMarketShare();
        /*final response = await NetworkManager.instance.coreDio!.fetchData<
                List<Gecho>, Gecho>(
            "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false",
            types: HttpTypes.GET,
            parseModel: Gecho());*/
        final baseOptions = BaseOptions();
        final response = await CoreDio(baseOptions).fetchData<List<Gecho>,
                Gecho>(
            dotenv.get(DotEnvEnums.BASE_URL_COIN_GECHO.name) +
                "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false",
            types: HttpTypes.GET,
            parseModel: Gecho());
        print(response);

        // context.read<SelectedPageGeneralCubit>().changeIsSearch();

        // if (context.read<SelectedPageGeneralCubit>().isSearhOpen == false) {
        //   _searchTextEditingController.clear();
        // }
      },
    );
  }

  Future<List<MyCoin>> getAllMarketShare() async {
    String baseUrl = dotenv.get(DotEnvEnums.BASE_URL_SHARE_MARKET.name);
    baseUrl = baseUrl + "hisse/list";

    List<MyCoin> _myCoinsList = [];
    Uri baseUri = Uri.parse(baseUrl);
    final response = await http.get(baseUri);
    switch (response.statusCode) {
      case HttpStatus.ok:
        final jsonBody = jsonDecode(response.body);
        print(jsonBody);

        print(jsonBody["data"][0]["id"]);
        for (var i = 0; i < jsonBody["data"].length; i++) {
          print(jsonBody["data"][i]["kod"]);
        }
        /*print(jsonBody.map((e) {
          print(e);
        }));*/
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

  Text buildError(CoinError state) {
    final error = state;
    return Text(error.message);
  }
}
