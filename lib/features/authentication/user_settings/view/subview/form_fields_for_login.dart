part of '../user_settings_page.dart';

extension FormFieldsForLoginExtension on UserSettings {
  Widget buildLoginFormFields(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: _buildTextFormFieldEmail(context)),
        const Spacer(flex: 1),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
            child: _buildTextFormFieldPassword(context))
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
          return "Must be longer than 3 characters";
        }
      },
      obscureText: context.watch<UserCubit>().isLockOpen,
      cursorColor: Theme.of(context).colorScheme.onBackground,
      decoration: InputDecoration(
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
      controller: context.read<UserCubit>().emailControllerForLogin,
      onTap: () {
        print("tapped email");
      },
      cursorColor: Theme.of(context).colorScheme.onBackground,
      validator: (value) => value!.isValidEmail ? null : "invalid email",
      decoration: InputDecoration(
        labelText: "email",
        icon: buildContainerIconField(context, Icons.email),
      ),
    );
  }

  Container buildContainerIconField(BuildContext context, IconData icon) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: context.paddingLow,
      child: Icon(icon, color: Theme.of(context).colorScheme.primaryVariant),
    );
  }
}
