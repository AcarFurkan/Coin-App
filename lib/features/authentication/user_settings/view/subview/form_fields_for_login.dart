part of '../user_settings_page.dart';

extension FormFieldsForLoginExtension on UserSettings {
  Widget buildLoginFormFields(BuildContext context) {
    return Column(
      children: [
        _buildTextFormFieldEmail(context),
        Spacer(flex: (context.height * .002).toInt()),
        _buildTextFormFieldPassword(context)
      ],
    );
  }

  Widget _buildTextFormFieldPassword(BuildContext context) {
    return TextFormField(
      controller: context.read<UserCubit>().passwordControllerForLogin,
      validator: (value) {
        if (value!.length > 3) {
          return null;
        } else {
          return LocaleKeys.loginRegisterPage_passwordError.locale;
        }
      },
      obscureText: context.watch<UserCubit>().isLockOpen,
      cursorColor: context.colors.onBackground,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: context.lowValue * 2),
        labelText: LocaleKeys.loginRegisterPage_password.locale,
        icon: buildContainerIconField(context, Icons.vpn_key),
        suffixIcon: IconButton(
            onPressed: () => context.read<UserCubit>().changeIsLockOpen(),
            icon: Icon(context.watch<UserCubit>().isLockOpen
                ? Icons.visibility_off_outlined
                : Icons.visibility)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          //   borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  TextFormField _buildTextFormFieldEmail(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: context.read<UserCubit>().emailControllerForLogin,
      cursorColor: context.colors.onBackground,
      validator: (value) => value!.isValidEmail
          ? null
          : LocaleKeys.loginRegisterPage_emailError.locale,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: context.lowValue * 2),
        errorStyle: TextStyle(color: context.colors.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelText: LocaleKeys.loginRegisterPage_email.locale,
        icon: buildContainerIconField(context, Icons.email),
      ),
    );
  }

  Container buildContainerIconField(BuildContext context, IconData icon) {
    return Container(
      color: context.theme.canvasColor,
      padding: context.paddingLow,
      child: Icon(icon, color: context.colors.primaryVariant),
    );
  }
}
