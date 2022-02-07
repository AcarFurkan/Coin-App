import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/model/response_model/IResponse_model.dart';
import '../../../../../locator.dart';
import '../../../../../product/model/coin/my_coin_model.dart';
import '../../../../../product/repository/cache/added_coin_list_externally_cache_manager.dart';
import '../../../../../product/repository/service/market/gecho/gecho_service_controller.dart';

part 'add_coin_state.dart';

class AddCoinCubit extends Cubit<AddCoinState> {
  AddCoinCubit() : super(AddCoinInitial());
  String? idToAdd;
  MainCurrencyModel? fetchedCurrrency;
  final AddedCoinListExternally _listCoinIdCacheManager =
      locator<AddedCoinListExternally>();
  fetchCoin(String id) async {
    emit(AddCoinLoading());
    idToAdd = id;

    IResponseModel<MainCurrencyModel> responseModel =
        await GechoServiceController.instance.fetchDataById(
            id); //ERRRORORRRR MAİNCURRENCY OLARAK  EĞİŞTİR YANİ CONTROLLERDAN ÇEK
    if (responseModel.error != null) {
      emit(AddCoinError());
    } else if (responseModel.data != null) {
      fetchedCurrrency = responseModel.data;
      emit(AddCoinCompleted(currency: responseModel.data!));
    }
  }

  addCoin() async {
    if (idToAdd != null) {
      IResponseModel<List<MainCurrencyModel>> responseModel =
          GechoServiceController.instance.getGechoUsdCoinList;
      if (responseModel.data != null) {
        if (responseModel.data!.contains(fetchedCurrrency)) {
          emit(AddCoinAlreadyExist());
          emit(AddCoinCompleted(currency: fetchedCurrrency!));
          return;
        }
      }

      if (idToAdd != null) {
        var bb = _listCoinIdCacheManager.getAllItems();
        if (bb != null) {
          if (!bb.contains(idToAdd)) {
            emit(AddCoinSuccessfullylAdded());
            emit(AddCoinCompleted(currency: fetchedCurrrency!));
            _listCoinIdCacheManager.addItems([idToAdd!]);
          } else {
            emit(AddCoinAlreadyAdded());
            emit(AddCoinCompleted(currency: fetchedCurrrency!));
          }
        } else {
          emit(AddCoinSuccessfullylAdded());
          emit(AddCoinCompleted(currency: fetchedCurrrency!));

          _listCoinIdCacheManager.addItems([idToAdd!]);
        }
      }
      //
    }
  }

  clearAll() {
    _listCoinIdCacheManager.clearAll();
  }
}
/**
 * [
      "ninja-squad",
      "talecraft",
      "colony",
      "bitcoin",
      "magic",
      "galatasaray-fan-token",
      "dydx",
      "algo",
      "swipe",
      "ftx-token",
      "casper-network",
      "idia",
      "band-protocol",
      "cake",
      "safepal",
      "alien-worlds",
      "centrifuge",
      "rarible",
      "covalent",
      "pangolin",
      "reef-finance",
      "star-atlas",
      "tokocrypto",
      "smooth-love-potion",
      "braintrust"
    ]
 */