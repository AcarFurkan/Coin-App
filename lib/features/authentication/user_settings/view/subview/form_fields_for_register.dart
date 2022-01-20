part of '../user_settings_page.dart';

extension FormFieldsForRegisterExtension on UserSettings {
  Widget buildRegisterFormFields(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: (context.height * .004).toInt()),
        _buildTextFormFieldEmail(context),
        Spacer(flex: (context.height * .004).toInt()),
        _buildTextFormFieldPassword(context),
        Spacer(flex: (context.height * .004).toInt()),
        _buildTextFormFieldName(context),
      ],
    );
  }

  Widget _buildTextFormFieldPassword(BuildContext context) {
    return TextFormField(
      controller: context.read<UserCubit>().passwordControllerForRegister,
      validator: (value) {
        if (value!.length > 3) {
          return null;
        } else {
          return LocaleKeys.loginRegisterPage_passwordError.locale;
        }
      },
      obscureText: context.watch<UserCubit>().isLockOpen,
      decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: context.lowValue * 2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          labelText: LocaleKeys.loginRegisterPage_password.locale,
          icon: buildContainerIconField(context, Icons.vpn_key),
          suffixIcon: IconButton(
              onPressed: () => context.read<UserCubit>().changeIsLockOpen(),
              icon: Icon(context.watch<UserCubit>().isLockOpen
                  ? Icons.visibility_off_outlined
                  : Icons.visibility))),
    );
  }

  TextFormField _buildTextFormFieldEmail(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: context.read<UserCubit>().emailControllerForRegister,
      validator: (value) => value!.isValidEmail
          ? null
          : LocaleKeys.loginRegisterPage_emailError.locale,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: context.lowValue * 2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelText: LocaleKeys.loginRegisterPage_email.locale,
        icon: buildContainerIconField(context, Icons.email),
      ),
    );
  }

  TextFormField _buildTextFormFieldName(BuildContext context) {
    return TextFormField(
      controller: context.read<UserCubit>().nameController,
      validator: (value) {
        if (value!.length > 3) {
          return null;
        } else {
          return LocaleKeys.loginRegisterPage_nameError.locale;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: context.lowValue * 2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        labelText: LocaleKeys.loginRegisterPage_name.locale,
        labelStyle: context.textTheme.subtitle1,
        icon: buildContainerIconField(context, Icons.person),
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
