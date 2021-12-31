import 'dart:convert';
import 'dart:io';

import 'package:coin_with_architecture/core/enums/dotenv_enums.dart';
import 'package:coin_with_architecture/core/init/network/core_dio.dart';
import 'package:coin_with_architecture/features/settings/view/settings_page.dart';
import 'package:coin_with_architecture/product/response_models/genelpara/genelpara_service_model.dart';

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
  List<MainCurrencyModel> searchresult = [];

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
      leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage()));
          },
          icon: const Icon(Icons.settings)),
      title: LocaleText(text: LocaleKeys.appBarTitle),
      titleSpacing: 0,
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
        await getAllMarketSharedio2();
        // GechoServiceController controller = GechoServiceController.instance;
        // await controller.fetchCoinListEveryTwoSecond();
        // //  await Future.delayed(Duration(milliseconds: 2000));
//
        // print(controller.getGechoUsdCoinList[0].id + "1");
//
        // print(controller.getGechoEthCoinList[0].id + "2");
//
        // print(controller.getGechoTryCoinList[0].id + "3");
//
        // print(controller.getGechoBtcCoinList[0].id + "4");
        // print(controller.getGechoUsdCoinList[0].counterCurrencyCode! + "1");
//
        // print(controller.getGechoEthCoinList[0].percentageControl! +
        //     controller.getGechoEthCoinList[0].changeOf24H!);
        // print(controller.getGechoEthCoinList[1].percentageControl! +
        //     controller.getGechoEthCoinList[1].changeOf24H!);
        // print(controller.getGechoEthCoinList[2].percentageControl! +
        //     controller.getGechoEthCoinList[2].changeOf24H!);
        // print(controller.getGechoEthCoinList[3].percentageControl! +
        //     controller.getGechoEthCoinList[3].changeOf24H!);
        // print(controller.getGechoEthCoinList[3].priceControl!);
//
        // print(controller.getGechoTryCoinList[0].counterCurrencyCode! + "3");
//
        // print(controller.getGechoBtcCoinList[0].counterCurrencyCode! + "4");
      },
    );
  }

  Future<List<MainCurrencyModel>> getAllMarketSharedio2() async {
    List<MainCurrencyModel> _myCoinsList = [];
    CoreDio coreDio = CoreDio(BaseOptions());

    final response =
        await coreDio.get("https://api.genelpara.com/embed/borsa.json");
    print(response.statusCode);
    switch (response.statusCode) {
      case HttpStatus.ok:
        response.data = jsonDecode(response.data);
        List keys = [];
        List<GenelPara> genelParaList = [];
        if (response.data is Map) {
          keys = (response.data as Map).keys.toList();
          genelParaList = (response.data as Map)
              .values
              .map((e) => GenelPara.fromJson(e))
              .toList();
        }
        keys.forEach((element) {
          print(element);
        });
        genelParaList.forEach((e) {
          print(e.alis);
          print(e.satis);
          print(e.degisim);
        });

        print(keys.length);

        return _myCoinsList;
      default:
        throw "NetworkError(response.statusCode.toString(), response.body)";
    }
  }

  Text buildError(CoinError state) {
    final error = state;
    return Text(error.message);
  }
}
