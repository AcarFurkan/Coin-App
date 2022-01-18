import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/extension/context_extension.dart';

import '../../../core/extension/string_extension.dart';
import '../../../product/language/locale_keys.g.dart';
import '../../../product/theme/theme_provider.dart';
import '../../../product/widget/component/settings_page_card_item.dart';
import '../../authentication/viewmodel/cubit/user_cubit.dart';
import '../subpage/help_page/view/help_page.dart';
import '../subpage/language_page/view/language_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: context.paddingLowHorizontal * 3,
        child: buildListView(context),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text(
        LocaleKeys.SettingsPage_appBarTitle.locale,
      ),
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      children: [
        buildUserSettingsCard(context),
        buildDarkModeCard(context),
        buildChangeLanguageCard(context),
        buildHelpPageCard(context),
      ],
    );
  }

  SettingsCardItem buildUserSettingsCard(BuildContext context) {
    return SettingsCardItem(
      prefix: Icon(
        Icons.person,
        size: context.lowValue * 3,
      ),
      text: context.watch<UserCubit>().user == null
          ? "User Settings"
          : context.read<UserCubit>().user?.email ?? "",
      suffix: Icon(
        Icons.arrow_forward_ios,
        size: context.lowValue * 3,
      ),
      ontap: () => Navigator.pushNamed(context, "/userSettings"),
    );
  }

  SettingsCardItem buildDarkModeCard(BuildContext context) {
    return SettingsCardItem(
      prefix: Icon(
        Icons.language,
        size: context.lowValue * 3,
      ),
      text: LocaleKeys.SettingsPage_appTheme.locale,
      suffix: SizedBox(
        height: context.lowValue * 3,
        child: CupertinoSwitch(
            value: context.watch<ThemeProvider>().isdark,
            activeColor: Colors.red,
            onChanged: (onChanged) =>
                context.read<ThemeProvider>().changeTheme()),
      ),
      ontap: () => context.read<ThemeProvider>().changeTheme(),
    );
  }

  SettingsCardItem buildChangeLanguageCard(BuildContext context) {
    return SettingsCardItem(
      prefix: Icon(
        Icons.language,
        size: context.lowValue * 3,
      ),
      text: LocaleKeys.SettingsPage_changeLanguage.locale,
      suffix: Icon(
        Icons.arrow_forward_ios,
        size: context.lowValue * 3,
      ),
      ontap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LanguagePage()))
            .whenComplete(() => {setState(() {})});
      },
    );
  }

  SettingsCardItem buildHelpPageCard(BuildContext context) {
    return SettingsCardItem(
      prefix: Icon(
        Icons.language,
        size: context.lowValue * 3,
      ),
      text: "Yardım",
      suffix: Icon(
        Icons.arrow_forward_ios,
        size: context.lowValue * 3,
      ),
      ontap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HelpPage())),
    );
  }
}
