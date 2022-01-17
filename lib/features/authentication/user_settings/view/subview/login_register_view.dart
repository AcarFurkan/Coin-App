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
                    padding: context.horizontalPaddingNormal,
                    child: buildForm(context))),
          ],
        ),
      )),
    );
  }

  Widget buildAnimatedContainer(BuildContext context) {
    return AnimatedContainer(
        duration:
            Duration(milliseconds: context.durationLow.inMilliseconds ~/ 3),
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
                    color: Theme.of(context).colorScheme.onPrimary, width: 3))),
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
          height: MediaQuery.of(_buildContextForViewInset).size.height * 0.5,
          child: Column(
            children: [
              loginRegisterControl(context)
                  ? const Spacer(flex: 4)
                  : const Spacer(flex: 2),
              loginRegisterControl(context)
                  ? Expanded(flex: 10, child: buildLoginFormFields(context))
                  : Expanded(flex: 30, child: buildRegisterFormFields(context)),
              const Spacer(),
              loginRegisterControl(context) ? buildTextForgot() : Container(),
              const Spacer(flex: 3),
              buildLoginButtons(context),
              const Spacer(flex: 2),
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
        Spacer(
          flex: 2,
        ),
        Expanded(flex: 20, child: buildElevatedButtonLogin(context)),
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
              EdgeInsets.symmetric(vertical: 5)),
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
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600));
  }

  ClipRRect buildGoogleIcon(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Image.asset(
        "assets/images/google_icon.png",
        width: context.width * 0.10,
      ),
    );
  }
}
