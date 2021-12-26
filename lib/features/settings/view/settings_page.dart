import 'package:coin_with_architecture/features/settings/help_page/view/help_page.dart';
import 'package:coin_with_architecture/product/widget/component/settings_page_card_item.dart';

import '../audio_settings/view/audio2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extension/string_extension.dart';
import '../../../product/language/locale_keys.g.dart';
import '../../../product/theme/theme_provider.dart';
import '../language_page/view/language_page.dart';
import '../language_page/viewmodel/language_page_viewmodel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          LocaleKeys.SettingsPage_appBarTitle.locale,
          // style: ThemeData().textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            SettingsCardItem(
              prefix: Icon(
                Icons.language,
                size: MediaQuery.of(context).size.height / 33,
              ),
              text: LocaleKeys.SettingsPage_appTheme.locale,
              suffix: SizedBox(
                height: MediaQuery.of(context).size.height / 30,
                child: CupertinoSwitch(
                    value: context.watch<ThemeProvider>().isdark,
                    activeColor: Colors.red,
                    onChanged: (onChanged) {
                      context.read<ThemeProvider>().changeTheme();
                    }),
              ),
              ontap: () {},
            ),
            SettingsCardItem(
              prefix: Icon(
                Icons.language,
                size: MediaQuery.of(context).size.height / 33,
              ),
              text: "Zil sesi ekle",
              suffix: Icon(
                Icons.arrow_forward_ios,
                size: MediaQuery.of(context).size.height / 40,
              ),
              ontap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AudioPage()));
              },
            ),
            SettingsCardItem(
              prefix: Icon(
                Icons.language,
                size: MediaQuery.of(context).size.height / 33,
              ),
              text: LocaleKeys.SettingsPage_changeLanguage.locale,
              suffix: Icon(
                Icons.arrow_forward_ios,
                size: MediaQuery.of(context).size.height / 40,
              ),
              ontap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                              create: (context) =>
                                  LanguageViewModel(context: context),
                              child: LanguagePage(),
                            ))).whenComplete(() => {setState(() {})});
              },
            ),
            SettingsCardItem(
              prefix: Icon(
                Icons.language,
                size: MediaQuery.of(context).size.height / 33,
              ),
              text: "Yardım",
              suffix: Icon(
                Icons.arrow_forward_ios,
                size: MediaQuery.of(context).size.height / 40,
              ),
              ontap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HelpPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
/*

 InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              splashColor: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
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
                        offset:
                            const Offset(2, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.language,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          LocaleKeys.SettingsPage_appTheme.locale,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 30,
                          child: CupertinoSwitch(
                              value: context.watch<ThemeProvider>().isdark,
                              activeColor: Colors.red,
                              onChanged: (onChanged) {
                                context.read<ThemeProvider>().changeTheme();
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

 */