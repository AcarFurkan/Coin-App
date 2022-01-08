part of '../user_settings_page.dart';

extension FormFieldsForLoginExtension on UserSettings {
  Widget buildLoginFormFields(BuildContext context) {
    return Column(
      children: [
        _buildTextFormFieldEmail(context),
        const Spacer(flex: 1),
        _buildTextFormFieldPassword(context)
      ],
    );
  }

  Widget _buildTextFormFieldPassword(BuildContext context) {
    return TextFormField(
      controller: context.read<UserCubit>().passwordControllerForLogin,
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

  TextFormField _buildTextFormFieldEmail(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: context.read<UserCubit>().emailControllerForLogin,
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
}
