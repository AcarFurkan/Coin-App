part of '../user_settings_page.dart';

extension FormFieldsForRegisterExtension on UserSettings {
  Widget buildRegisterFormFields(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 3),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: _buildTextFormFieldEmail(context)),
        const Spacer(flex: 3),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: _buildTextFormFieldPassword(context)),
        const Spacer(flex: 3),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: _buildTextFormFieldName(context)),
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
          return "Must be longer than 3 characters";
        }
      },
      obscureText: context.watch<UserCubit>().isLockOpen,
      decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 10),
          labelText: "password",
          icon: buildContainerIconField(context, Icons.vpn_key),
          suffixIcon: IconButton(
              onPressed: () {
                context.read<UserCubit>().changeIsLockOpen();
              },
              icon: Icon(context.watch<UserCubit>().isLockOpen
                  ? Icons.visibility_off_outlined
                  : Icons.visibility))),
    );
  }

  TextFormField _buildTextFormFieldEmail(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: context.read<UserCubit>().emailControllerForRegister,
      validator: (value) => value.isValidEmail ? null : "invalid email",
      decoration: InputDecoration(
        labelText: "email",
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
          return "Must be longer than 3 characters";
        }
      },
      decoration: InputDecoration(
        labelText: "name",
        labelStyle: context.textTheme.subtitle1,
        icon: buildContainerIconField(context, Icons.person),
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
