import 'package:coin_with_architecture/product/widget/component/removable_card_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/text/locale_text.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../../../product/model/my_coin_model.dart';
import '../../../../product/widget/component/coin_current_info_card.dart';
import '../viewmodel/cubit/coin_cubit.dart';
import '../viewmodel/general/cubit/selected_page_general_cubit.dart';

part './subView/selected_coin_page_extension.dart';
part './subView/coin_completed_state_extension.dart';
part './subView/update_coin_selected_page_state_extension.dart';

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
      leading: buildSettingsIcon(context),
      title: const LocaleText(text: LocaleKeys.appBarTitle),
      titleSpacing: 0,
      actions: [
        buildStopMusicIcon(context),
        buildDeleteIcon(context),
        buildOpenSearchFieldIcon(context)
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
        onPressed: () => context.read<CoinCubit>().stopMusic(),
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
