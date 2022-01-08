part of '../user_settings_page.dart';

extension FormFieldsForRegisterExtension on UserSettings {
  Widget buildRegisterFormFields(BuildContext context) {
    return Column(
      children: [
        _buildTextFormFieldName(context),
        const Spacer(flex: 3),
        _buildTextFormFieldEmail(context),
        const Spacer(flex: 3),
        _buildTextFormFieldPassword(context)
      ],
    );
  }

  Widget _buildTextFormFieldPassword(BuildContext context) {
    return TextFormField(
      controller: context.read<UserCubit>().passwordControllerForRegister,
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
      controller: context.read<UserCubit>().emailControllerForRegister,
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

  TextFormField _buildTextFormFieldName(BuildContext context) {
    return TextFormField(
      controller: context.read<UserCubit>().nameController,
      onTap: () {
        print("tapped name");
        // context.read<LoginRegisterCubit>().emitLogin();
      },
      // validator: (value) => value!.isValidEmails ? 'asdasd' : null,
      validator: (value) {
        if (value!.length > 3) {
          return null;
        } else {
          print(" ");

          return "Must be longer than 3 characters";
        }
      },
      decoration: InputDecoration(
        labelText: "name",
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
