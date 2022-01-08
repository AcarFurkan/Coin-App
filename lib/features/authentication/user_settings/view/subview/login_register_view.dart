part of '../user_settings_page.dart';

extension LoginRegisterViewExtension on UserSettings {
  Widget loginRegisterView(BuildContext context) {
    return DefaultTabController(
      length: 2,
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

  Form buildForm(BuildContext context) {
    return Form(
      key: _formState,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          context.watch<UserCubit>().isLoginPage
              ? const Spacer(flex: 6)
              : const Spacer(flex: 3),
          context.watch<UserCubit>().isLoginPage
              ? Container()
              : buildTextFormFieldName(context),
          const Spacer(flex: 3),
          buildTextFormFieldEmail(context),
          const Spacer(flex: 3),
          buildTextFormFieldPassword(context),
          const Spacer(),
          buildTextForgot(),
          context.watch<UserCubit>().isLoginPage
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

  Widget buildTextFormFieldPassword(
    BuildContext context,
  ) {
    return TextFormField(
      controller: context.read<UserCubit>().passwordController,
      onTap: () {
        print("tapped password");
        //   context.read<LoginRegisterCubit>().emitLogin();
      },
      validator: (value) => value!.isNotEmpty ? null : 'This field required',
      obscureText: context.watch<UserCubit>().isLockOpen,
      decoration: InputDecoration(
          labelStyle: context.textTheme.subtitle1,
          labelText: "password",
          icon: buildContainerIconField(context, Icons.vpn_key),
          suffixIcon: FlatButton(
              onPressed: () {
                //viewModel.isLockStateChange();
                context.read<UserCubit>().changeIsLockOpen();
              },
              padding: EdgeInsets.zero,
              child: //viewModel.isLockOpen
                  Icon(context.watch<UserCubit>().isLockOpen
                      ? Icons.visibility_off_outlined
                      : Icons.visibility))),
    );
  }

  TextFormField buildTextFormFieldName(BuildContext context) {
    return TextFormField(
      controller: context.read<UserCubit>().nameController,
      onTap: () {
        print("tapped name");
        // context.read<LoginRegisterCubit>().emitLogin();
      },
      // validator: (value) => value!.isValidEmails ? 'asdasd' : null,
      decoration: InputDecoration(
        labelText: "name",
        labelStyle: context.textTheme.subtitle1,
        icon: buildContainerIconField(context, Icons.email),
      ),
    );
  }

  TextFormField buildTextFormFieldEmail(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: context.read<UserCubit>().emailController,
      onTap: () {
        print("tapped email");
        // context.read<LoginRegisterCubit>().emitLogin();
      },
      // validator: (value) => value!.isValidEmails ? 'asdasd' : null,
      decoration: InputDecoration(
        labelText: "email",
        labelStyle: context.textTheme.subtitle1,
        icon: buildContainerIconField(context, Icons.email),
      ),
    );
  }

  Container buildContainerIconField(BuildContext context, IconData icon) {
    return Container(
      color: Theme.of(context).colorScheme.onBackground,
      padding: context.paddingLow,
      child: Icon(icon, color: Theme.of(context).colorScheme.primaryVariant),
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
