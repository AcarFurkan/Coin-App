import 'package:auto_size_text/auto_size_text.dart';
import 'package:coin_with_architecture/product/repository/service/market/opensea/opensea_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constant/app/app_constant.dart';
import '../../../../core/enums/show_type_enums_for_percentage.dart';
import '../../../../core/enums/show_type_enums_for_price.dart';
import '../../../../core/extension/context_extension.dart';
import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/alarm_manager/alarm_manager.dart';
import '../../../../product/connectivity_manager/connectivity_notifer.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/coin/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../../../../product/widget/component/removable_card_item.dart';
import '../../../../product/widget/component/text_form_field_with_animation.dart';
import '../../../home/viewmodel/home_viewmodel.dart';
import '../viewmodel/cubit/coin_cubit.dart';
import '../viewmodel/general/cubit/selected_page_general_cubit.dart';

part './subView/coin_completed_state_extension.dart';
part './subView/selected_coin_page_extension.dart';
part './subView/sort_popup_extension.dart';
part './subView/update_coin_selected_page_state_extension.dart';

class SelectedCoinPage extends StatelessWidget {
  final TextEditingController _searchTextEditingController =
      TextEditingController();
  final List<MainCurrencyModel> searchresult = [];

  SelectedCoinPage({Key? key}) : super(key: key);
  final GlobalKey _menuKey2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    context.read<SelectedPageGeneralCubit>().textEditingController =
        _searchTextEditingController;
    return Scaffold(
      appBar: appBar(context),
      body: _blocConsumer(),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      // leading: buildSettingsIcon(context),
      title: const LocaleText(text: LocaleKeys.selectedPage_appBarTitle),
      titleSpacing: 0,
      centerTitle: true,
      actions: [
        AudioManager.instance.isPlaying == true
            ? buildStopMusicIcon(context)
            : Container(),
        buildDeleteIcon(context),
        buildOpenSearchFieldIcon(context),
      ],
    );
  }

  IconButton buildDeleteIcon(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.read<SelectedPageGeneralCubit>().setIsDeletedPageOpen();
          if (context.read<SelectedPageGeneralCubit>().isDeletedPageOpen) {
            context.read<CoinCubit>().updatePage();
          } else {
            context.read<CoinCubit>().startAgain();
          }
        },
        icon: const Icon(Icons.delete));
  }

  IconButton buildStopMusicIcon(BuildContext context) {
    return IconButton(
        onPressed: () => context.read<CoinCubit>().stopAudio(),
        icon: const Icon(Icons.music_off));
  }

  IconButton buildSettingsIcon(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pushNamed(context, "/settingsGeneral"),
        icon: const Icon(Icons.settings));
  }

  IconButton buildOpenSearchFieldIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        context.read<SelectedPageGeneralCubit>().changeIsSearch();

        if (context.read<SelectedPageGeneralCubit>().isSearhOpen == false) {
          _searchTextEditingController.clear();
        }
      },
    );
  }

  Text buildError(CoinError state) {
    final error = state;
    return Text(error.message);
  }
}
