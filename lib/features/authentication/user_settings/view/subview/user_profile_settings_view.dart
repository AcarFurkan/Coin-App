part of '../user_settings_page.dart';

//SettingsView
extension UserProfileSettingsViewExtension on UserSettings {
  Widget buildUserProfileView(MyUser user, BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildScaffoldBody(user, context),
    );
  }

  Column buildScaffoldBody(MyUser user, BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(flex: (context.height * .018).toInt(), child: buildProfileImage),
      const Spacer(),
      Expanded(flex: (context.height * .005).toInt(), child: buildName(user)),
      Expanded(flex: (context.height * .005).toInt(), child: buildEmail(user)),
      const Divider(),
      Expanded(flex: 2, child: buildBackUpMaterialCard(user, context)),
      const Divider(),
      const Spacer(),
      Expanded(
          flex: (context.height * .005).toInt(), child: buildButtons(context)),
      Spacer(flex: (context.height * .01).toInt())
    ]);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp)),
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
    );
  }

  Text buildEmail(MyUser user) => Text(
      (LocaleKeys.userSettings_registeredMail.locale + ": " + user.email!));

  Text buildName(MyUser user) =>
      Text(LocaleKeys.userSettings_hey.locale + (user.name ?? "") + "  😍");

  Widget get buildProfileImage =>
      Image.asset(AppConstant.instance.PROFILE_IMAGE_PATH);

  InkWell buildBackUpMaterialCard(MyUser user, BuildContext context) {
    return InkWell(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: context.paddingMediumHorizontal,
          child: Row(
            children: [
              const Spacer(flex: 2),
              const Expanded(flex: 1, child: const Icon(Icons.backup_outlined)),
              const Spacer(),
              Expanded(
                  flex: 7,
                  child: Text(LocaleKeys.userSettings_backUpButton.locale +
                      ": " +
                      (buildBackUpTypeText(user.backUpType ?? "")) +
                      "  😍")),
              const Spacer()
            ],
          ),
        ),
      ),
      onTap: () {
        showBackUpTypeAlertDialog(context);
      },
    );
  }

  String buildBackUpTypeText(String type) {
    if (type == "monthly") {
      return LocaleKeys.userSettings_backUpType_monthly.locale;
    } else if (type == "tapped") {
      return LocaleKeys.userSettings_backUpType_tapped.locale;
    } else if (type == "daily") {
      return LocaleKeys.userSettings_backUpType_daily.locale;
    } else if (type == "weekly") {
      return LocaleKeys.userSettings_backUpType_weekly.locale;
    } else {
      return LocaleKeys.userSettings_backUpType_never.locale;
    }
  }

  Row buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment:
          context.watch<UserCubit>().user?.backUpType == BackUpTypes.tapped.name
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
      children: [
        buildSignOutButton(context),
        context.watch<UserCubit>().user?.backUpType == BackUpTypes.tapped.name
            ? buildBackUpButton(context)
            : Container(),
      ],
    );
  }

  OutlinedButton buildSignOutButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          context.read<UserCubit>().signOut();
        },
        child: Text(LocaleKeys.userSettings_signOutButton.locale));
  }

  Widget buildBackUpButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          await context.read<UserCubit>().backUpWhenTapped();
          showScaffoldMessage(context);
        },
        child: Text(LocaleKeys.userSettings_backUpButton.locale));
  }

  showBackUpTypeAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title:
            Text('${LocaleKeys.userSettings_backUpAlertDialog.locale}'), //🗃️
        content: buildShowDialogContent(context),
      ),
    );
  }

  Container buildShowDialogContent(BuildContext context) {
    return Container(
      height: context.height * 0.35,
      width: context.width * 0.35,
      color: Colors.transparent,
      child: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return buildShowAlertDialogMaterialCard();
        },
      ),
    );
  }

  Material buildShowAlertDialogMaterialCard() {
    return Material(
      //BUNU CARD YAPIP TRANSPARENT YAPINCA FARKLI BİR RENK ALIYOR NEDEN BİR ARAŞTIR
      color: Colors.transparent,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: BackUpTypes.values.length,
        itemBuilder: (BuildContext context, int index) {
          return buildRadioListTile(index, context);
        },
      ),
    );
  }

  void showScaffoldMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(LocaleKeys.CoinDetailPage_backUpSuccess.locale),
      duration: context.midDuration,
    ));
  }

  RadioListTile<String> buildRadioListTile(int index, BuildContext context) {
    return RadioListTile<String>(
      title: Text(buildBackUpTypeText(BackUpTypes.values.toList()[index].name)),
      value: BackUpTypes.values.toList()[index].name,
      groupValue: context.watch<UserCubit>().groupValue,
      onChanged: (onChanged) async {
        context.read<UserCubit>().changeGroupValue(onChanged!);
        context.read<UserCubit>().updateUser();
        Navigator.of(context).pop();
      },
    );
  }
}
