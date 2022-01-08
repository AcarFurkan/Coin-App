part of '../user_settings_page.dart';

extension LoginRegisterViewExtension on UserSettings {
  Widget loginRegisterView(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: context.watch<UserCubit>().tabbarIndex,
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            buildAnimatedContainer(_buildContextForViewInset),
            buildContainerTabBar(context),
            Expanded(
                flex: 6,
                child: Padding(
                    padding: context.paddingNormal, child: buildForm(context))),
          ],
        ),
      )),
    );
  }

  Widget buildAnimatedContainer(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: context.mediaQuery.viewInsets.bottom > 0
            ? context.height * 0
            : context.height * 0.3,
        color: Colors.white,
        child: Center(child: SvgPicture.asset("assets/svg/login2.svg")));
  }

  Container buildContainerTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
      child: Padding(
        padding: EdgeInsets.only(
            left: context.width * 0.1,
            right: context.width * 0.1,
            bottom: context.width * 0.01),
        child: buildTabBar(context),
      ),
    );
  }

  TabBar buildTabBar(BuildContext context) {
    return TabBar(
        //labelStyle: context.textTheme.headline5,
        //unselectedLabelStyle: context.textTheme.headline5,

        indicatorWeight: 0,
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        indicator: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 3))),
        onTap: (index) {
          context.read<UserCubit>().changeIsLoginPage(index);
        },
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(text: '   Login   '),
          Tab(text: "   Register   "),
        ]);
  }

  bool loginRegisterControl(BuildContext context) {
    return context.watch<UserCubit>().isLoginPage;
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: context.read<UserCubit>().formState,
      autovalidateMode: context.watch<UserCubit>().autoValidateMode,
      child: Column(
        children: [
          loginRegisterControl(context)
              ? const Spacer(flex: 4)
              : const Spacer(flex: 2),
          loginRegisterControl(context)
              ? Expanded(flex: 15, child: buildLoginFormFields(context))
              : Expanded(flex: 30, child: buildRegisterFormFields(context)),
          const Spacer(),
          buildTextForgot(),
          loginRegisterControl(context)
              ? const Spacer(flex: 6)
              : const Spacer(flex: 3),
          buildGoogleSignIn(context),
          buildWrapForgot(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildGoogleSignIn(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 20, child: buildRaisedButtonLogin(context)),
        const Spacer(),
        context.watch<UserCubit>().isLoginPage
            ? InkWell(
                onTap: () async {
                  await context.read<UserCubit>().signInWithGoogle();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    "assets/images/google_icon.png",
                    width: context.width * 0.13,
                  ),
                ),
              )
            : Container(),
        const Spacer(),
      ],
    );
  }

  Widget buildTextForgot() => Align(
      alignment: Alignment.centerRight,
      child: Text("forgot password", textAlign: TextAlign.end));

  Widget buildRaisedButtonLogin(BuildContext context) {
    return RaisedButton(
      padding: context.paddingNormal,
      onPressed: () async {
        await context.read<UserCubit>().tappedLoginRegisterButton();
      }, // viewModel.isLoading? null: () {viewModel.fetchLoginSevice();},
      shape: StadiumBorder(),
      child: Center(
          child: Text(
              context.read<UserCubit>().isLoginPage ? "login" : "Register",
              style: context.textTheme.headline5)),
      color: Theme.of(context).colorScheme.onError,
    );
  }

  Wrap buildWrapForgot() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("dont have a acount"),
        FlatButton(onPressed: () {}, child: Text("sign up"))
      ],
    );
  }
}
