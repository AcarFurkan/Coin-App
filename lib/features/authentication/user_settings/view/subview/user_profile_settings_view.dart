part of '../user_settings_page.dart';

//SettingsView
extension UserProfileSettingsViewExtension on UserSettings {
  Widget buildUserProfileView(MyUser user, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(flex: 12, child: buildProfileImage),
        const Spacer(),
        Expanded(flex: 2, child: buildName(user)),
        Expanded(flex: 2, child: buildEmail(user)),
        const Divider(),
        Expanded(child: buildBackUpMaterialCard(user, context)),
        const Divider(),
        const Spacer(),
        Expanded(flex: 2, child: buildButtons(context)),
        const Spacer(flex: 6)
      ]),
    );
  }

  Text buildEmail(MyUser user) => Text((" Registered Email: " + user.email!));

  Text buildName(MyUser user) => Text("Hey   " + (user.name ?? "") + "  😍");

  SvgPicture get buildProfileImage =>
      SvgPicture.asset("assets/svg/bighead.svg");

  InkWell buildBackUpMaterialCard(MyUser user, BuildContext context) {
    return InkWell(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Spacer(),
              const Expanded(flex: 1, child: Icon(Icons.backup_outlined)),
              const Spacer(),
              Expanded(
                  flex: 6,
                  child: Text("Back Up " + (user.backUpType ?? "") + "  😍")),
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
        child: Text("Sign Out"));
  }

  Widget buildBackUpButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () async {
          await context.read<UserCubit>().backUpWhenTapped();
          showScaffoldMessage(context);
        },
        child: Text("Back Up"));
  }

  showBackUpTypeAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🗂️  Back Up To Cloud  🗂️'), //🗃️
        content: buildShowDialogContent(context),
      ),
    );
  }
}

Container buildShowDialogContent(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.35,
    width: MediaQuery.of(context).size.width * 0.35,
    color: Colors.transparent,
    child: BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Material(
          //BUNU CARD YAPIP TRANSPARENT YAPINCA FARKLI BİR RENK ALIYOR NEDEN BİR ARAŞTIR
          color: Colors.transparent,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: BackUpTypes.values.length,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile<String>(
                title: Text(BackUpTypes.values.toList()[index].name),
                value: BackUpTypes.values.toList()[index].name,
                groupValue: context.watch<UserCubit>().groupValue,
                onChanged: (onChanged) async {
                  context.read<UserCubit>().changeGroupValue(onChanged!);
                  context.read<UserCubit>().updateUser();

                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    ),
  );
}

void showScaffoldMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text(" Back Up Successful"),
    duration: Duration(milliseconds: 600),
  ));
}
