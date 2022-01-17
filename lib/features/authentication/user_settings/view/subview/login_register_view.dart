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
                flex: (context.height * .01).toInt(),
                child: Padding(
                    padding: context.paddingNormalHorizontal,
                    child: buildForm(context))),
          ],
        ),
      )),
    );
  }

  Widget buildAnimatedContainer(BuildContext context) {
    return AnimatedContainer(
        duration:
            Duration(milliseconds: context.lowDuration.inMilliseconds ~/ 3),
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
          borderRadius: BorderRadius.vertical(
              bottom: Radius.circular((context.height * .07)))),
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
        unselectedLabelStyle: context.textTheme.bodyText2,
        labelColor: context.colors.onPrimary,
        indicator: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: context.colors.onPrimary,
                    width: (context.width * .01)))),
        onTap: (index) => context.read<UserCubit>().changeIsLoginPage(index),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(text: '   Login   '),
          Tab(text: "   Register   "),
        ]);
  }

  bool loginRegisterControl(BuildContext context) =>
      context.watch<UserCubit>().isLoginPage;

  Widget buildForm(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: context.watch<UserCubit>().formState,
        autovalidateMode: context.watch<UserCubit>().autoValidateMode,
        child: SizedBox(
          height: context.height * 0.5,
          child: Column(
            children: [
              loginRegisterControl(context)
                  ? Spacer(flex: (context.width * .012).toInt())
                  : Spacer(flex: (context.width * .006).toInt()),
              loginRegisterControl(context)
                  ? Expanded(
                      flex: (context.height * .015).toInt(),
                      child: buildLoginFormFields(context))
                  : Expanded(
                      flex: (context.height * .03).toInt(),
                      child: buildRegisterFormFields(context)),
              const Spacer(),
              loginRegisterControl(context) ? buildTextForgot() : Container(),
              Spacer(flex: (context.width * .01).toInt()),
              buildLoginButtons(context),
              Spacer(flex: (context.width * .006).toInt()),
              // buildWrapForgot(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginButtons(BuildContext context) {
    return Row(
      children: [
        Spacer(flex: (context.width * .006).toInt()),
        Expanded(
            flex: (context.width * .05).toInt(),
            child: buildElevatedButtonLogin(context)),
        const Spacer(),
        context.watch<UserCubit>().isLoginPage
            ? InkWell(
                onTap: () async =>
                    await context.read<UserCubit>().signInWithGoogle(),
                child: buildGoogleIcon(context),
              )
            : Container(),
        const Spacer(),
      ],
    );
  }

  Widget buildElevatedButtonLogin(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.onError),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry?>(
              context.paddingLowVertical),
          shape: MaterialStateProperty.all(StadiumBorder())),
      onPressed: () async {
        await context.read<UserCubit>().tappedLoginRegisterButton();
      },
      child: Center(child: buildLoginButtonText(context)),
    );
  }

  Widget buildTextForgot() => Align(
      alignment: Alignment.centerRight,
      child: Text("forgot password", textAlign: TextAlign.end));
  Text buildLoginButtonText(BuildContext context) {
    return Text(context.read<UserCubit>().isLoginPage ? "Login" : "Register",
        style: context.textTheme.headline5!.copyWith(
            color: context.colors.primary, fontWeight: FontWeight.w600));
  }

  ClipRRect buildGoogleIcon(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular((context.width * .06)),
      child: Image.asset(
        "assets/images/google_icon.png",
        width: context.width * 0.10,
      ),
    );
  }
}
