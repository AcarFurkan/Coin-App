import 'package:coin_with_architecture/core/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extension/string_extension.dart';
import '../../../../../product/language/locale_keys.g.dart';
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
            child: ListTileItem(
              leading: SizedBox(height: context.lowValue * 3, child: e.flag),
              text: e.name,
              countryCode: e.code,
            ),
          ),
        )
        .toList();
  }
}

class ListTileItem extends StatelessWidget {
  const ListTileItem(
      {Key? key,
      required this.leading,
      required this.text,
      required this.countryCode})
      : super(key: key);
  final Widget leading;
  final String text;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<LanguageViewModel>().setLanguage(countryCode),
      child: Container(
        height: context.lowValue * 7,
        decoration: BoxDecoration(
          color: context.theme.appBarTheme.backgroundColor,
          borderRadius:
              BorderRadius.all(Radius.circular(context.lowValue * 1.5)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(5, 10), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(context.lowValue * 2),
        child: buildCardContent(context),
      ),
    );
  }

  Row buildCardContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: leading,
        ),
        const Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 6,
          child: Text(text, style: context.theme.textTheme.bodyText1),
        ),
        const Spacer(
          flex: 3,
        ),
      ],
    );
  }
}
