import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extension/context_extension.dart';
import '../../../../../core/extension/string_extension.dart';
import '../../../../../product/language/locale_keys.g.dart';
import '../../../../../product/widget/component/language_list_tile.dart';
import '../../../model/language_model.dart';
import '../viewmodel/language_page_viewmodel.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LanguageViewModel(context: context),
      builder: (context, a) {
        context.read<LanguageViewModel>().getCurrentLanguage();
        List<LanguageModel> langList =
            context.read<LanguageViewModel>().langModel;
        return Scaffold(
          appBar: buildAppBar(context),
          body: Padding(
            padding: context.paddingLow,
            child: ListView(
              children: languageWidgetList(langList, context),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(
        LocaleKeys.changeLanguagePage_appBarTitle.locale,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
  }

  List<Widget> languageWidgetList(
      List<LanguageModel> langList, BuildContext context) {
    return langList
        .map(
          (e) => Padding(
            padding: context.paddingLow,
            child: LanguageListTileItem(
              leading: SizedBox(height: context.lowValue * 3, child: e.flag),
              text: e.name,
              countryCode: e.code,
            ),
          ),
        )
        .toList();
  }
}
