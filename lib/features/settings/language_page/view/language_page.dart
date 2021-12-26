import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extension/string_extension.dart';
import '../../../../product/language/locale_keys.g.dart';
import '../../model/language_model.dart';
import '../viewmodel/language_page_viewmodel.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({Key? key}) : super(key: key);

  List<Widget> languageWidgetList(List<LanguageModel> langList) {
    return langList
        .map(
          (e) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTileItem(
              leading: SizedBox(height: 20, child: e.flag),
              text: e.name,
              countryCode: e.code,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    context.read<LanguageViewModel>().getCurrentLanguage();
    List<LanguageModel> langList = context.read<LanguageViewModel>().langModel;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          LocaleKeys.changeLanguagePage_appBarTitle.locale,
          style: TextStyle(color: Colors.grey[800]),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: languageWidgetList(langList),
        ),
      ),
    );
  }
}

class ListTileItem extends StatelessWidget {
  ListTileItem(
      {Key? key,
      required this.leading,
      required this.text,
      this.trailing,
      required this.countryCode})
      : super(key: key);
  final Widget leading;
  final String text;
  Widget? trailing;
  String countryCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<LanguageViewModel>().setLanguage(countryCode);
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 14,
        decoration: BoxDecoration(
          color: ThemeData().colorScheme.onSecondary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 25,
              offset: Offset(2, 8), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: leading,
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 6,
              child: Text(text),
            ),
            Spacer(
              flex: 3,
            ),
            Expanded(
                flex: 2,
                child: trailing ??
                    Visibility(
                      child: Icon(Icons.ac_unit),
                      visible: false,
                    ))
          ],
        ),
      ),
    );
  }
}
/*
ListTileItem(
              leading: SizedBox(
                height: 20,
                child: Flag.fromCode(
                  FlagsCode.US,
                ),
              ),
              text: "English US",
              trailing: Icon(Icons.check),
            ),
            SizedBox(
              height: 10,
            ),
            ListTileItem(
              leading: SizedBox(
                height: 20,
                child: Flag.fromCode(
                  FlagsCode.GB,
                ),
              ),
              text: "English UK",
            ),
            SizedBox(
              height: 10,
            ),
            ListTileItem(
              leading: SizedBox(
                height: 20,
                child: Flag.fromCode(
                  FlagsCode.TR,
                ),
              ),
              text: "Turkish",
            ),
            SizedBox(
              height: 10,
            ),
            ListTileItem(
              leading: SizedBox(
                height: 20,
                child: Flag.fromCode(
                  FlagsCode.KR,
                ),
              ),
              text: "Korean",
            ),
 */