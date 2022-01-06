import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kartal/kartal.dart';

class LoginPageTwo extends StatelessWidget {
  LoginPageTwo({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: SafeArea(
        child: Column(children: [
          buildAnimatedContainer(context),
          buildContainerTabBar(context),
          Expanded(
              flex: 6,
              child: Padding(
                  padding: context.paddingNormal, child: buildForm(context))),
        ]),
      )),
    );
  }

  AnimatedContainer buildAnimatedContainer(BuildContext context) {
    return AnimatedContainer(
        duration: context.durationLow,
        height:
            context.mediaQuery.viewInsets.bottom > 0 ? 0 : context.height * 0.3,
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
        labelStyle: context.textTheme.headline5,
        unselectedLabelStyle: context.textTheme.headline5,
        labelColor: Colors.black,
        indicatorColor: Colors.yellow,
        indicatorWeight: 5,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(text: ' Login   '),
          Tab(text: " Register  "),
        ]);
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formState,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          Spacer(flex: 6),
          buildTextFormFieldEmail(context),
          buildTextFormFieldPassword(context),
          Spacer(),
          buildTextForgot(),
          Spacer(flex: 6),
          buildRaisedButtonLogin(context),
          buildWrapForgot(),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildTextFormFieldPassword(
    BuildContext context,
  ) {
    return TextFormField(
      controller: passwordController,
      validator: (value) => value!.isNotEmpty ? null : 'This field required',
      obscureText: false, // viewModel.isLockOpen,
      decoration: InputDecoration(
          labelStyle: context.textTheme.subtitle1,
          labelText: "LocaleKeys.login_password.tr()",
          icon: buildContainerIconField(context, Icons.vpn_key),
          suffixIcon: FlatButton(
              onPressed: () {
                //viewModel.isLockStateChange();
              },
              padding: EdgeInsets.zero,
              child: //viewModel.isLockOpen
                  Icon(false ? Icons.lock : Icons.lock_open))),
    );
  }

  TextFormField buildTextFormFieldEmail(BuildContext context) {
    return TextFormField(
      controller: emailController,
      //  validator: (value) => value!.isValidEmails ? 'asdasd' : null,
      decoration: InputDecoration(
        labelText: "LocaleKeys.login_email.tr()",
        labelStyle: context.textTheme.subtitle1,
        icon: buildContainerIconField(context, Icons.email),
      ),
    );
  }

  Container buildContainerIconField(BuildContext context, IconData icon) {
    return Container(
      color: Theme.of(context).colorScheme.error,
      padding: context.paddingLow,
      child: Icon(icon, color: Theme.of(context).colorScheme.primaryVariant),
    );
  }

  Widget buildTextForgot() => Align(
      alignment: Alignment.centerRight,
      child: Text("LocaleKeys.login_forgotText", textAlign: TextAlign.end));

  Widget buildRaisedButtonLogin(BuildContext context) {
    return RaisedButton(
      padding: context.paddingNormal,
      onPressed:
          () {}, // viewModel.isLoading? null: () {viewModel.fetchLoginSevice();},
      shape: StadiumBorder(),
      child: Center(
          child: Text("LocaleKeys.login_login.tr()",
              style: context.textTheme.headline5)),
      color: Theme.of(context).colorScheme.onError,
    );
  }

  Wrap buildWrapForgot() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("LocaleKeys.login_dontAccount.tr()"),
        FlatButton(onPressed: () {}, child: Text("LocaleKeys.login_tab2.tr()"))
      ],
    );
  }
}
