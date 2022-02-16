import 'package:bloc/bloc.dart';
import '../../../../../core/enums/locale_keys_enum.dart';
import '../../../../../product/repository/cache/app_cache_manager.dart';
import '../../../../../product/repository/cache/coin_id_list_cache_manager.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service.dart';
import 'package:flutter/material.dart';
import '../../../../../product/response_models/gecho/gecho_id_list_model.dart';

import '../../../../../locator.dart';

part 'search_page_state.dart';

class SearchPageCubit extends Cubit<SearchPageState> {
  SearchPageCubit() : super(SearchPageInitial());
  final CoinIdListCacheManager _coinIdListCacheManager =
      locator<CoinIdListCacheManager>();
  final AppCacheManager _appCacheManager = locator<AppCacheManager>();
  List<GechoAllIdList> listCoin = [];
  final TextEditingController controller = TextEditingController();
  int? listItemCount;
  Map? mapForSearch;

  Future<void> fillMap() async {
    Map? mapFromDb = _coinIdListCacheManager.getAllItems();
    if (mapFromDb != null) {
    } else {
      Map mapFromService = await GechoService.instance.getAllCoinsIdList();
      mapFromDb = mapFromService;

      _coinIdListCacheManager.addItems(mapFromService);
      _appCacheManager.putItem(
          PreferencesKeys.ID_LIST_LAST_UPDATE.name, DateTime.now().toString());
    }
    mapForSearch = mapFromDb;
  }

  Future<void> searchCoin() async {
    if (mapForSearch == null) {
      await fillMap();
    }
    if (mapForSearch != null) {
      listItemCount = mapForSearch!.length;

      listCoin.clear();
      if (controller.text.trim() != "") {
        for (String item in mapForSearch!.keys) {
          if (item.contains(controller.text.toLowerCase().trim())) {
            listCoin
                .add(GechoAllIdList.fromJson(Map.from(mapForSearch![item])));
          }
        }

        if (listCoin.isEmpty) {
          print("aaaaaaaa");
          for (Map itemMap in mapForSearch!.values) {
            if (itemMap["symbol"]
                .contains(controller.text.toLowerCase().trim())) {
              listCoin.add(GechoAllIdList.fromJson(
                  Map.from(mapForSearch![itemMap["id"]])));
              break;
            }
          }
        }
      }
      if (listCoin.isNotEmpty) {
        emit(SearchPageCompleted(foundIdList: listCoin));
      } else {
        emit(SearchPageItemNotFound());
      }
    }
  }
}
