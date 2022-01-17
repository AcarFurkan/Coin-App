import '../../../../core/extension/context_extension.dart';
import '../../../../core/extension/string_extension.dart';

import '../../../../core/enums/back_up_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../product/model/user/my_user_model.dart';
import '../../viewmodel/cubit/user_cubit.dart';
part './subview/login_register_view.dart';
part './subview/form_fields_for_register.dart';
part './subview/form_fields_for_login.dart';
part './subview/user_profile_settings_view.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key? key}) : super(key: key);
  MyUser? userInformationForUpdate;
  /*
  * 
  TODO: THİNK İT */

  late BuildContext _buildContextForViewInset;
  @override
  Widget build(BuildContext context) {
    _buildContextForViewInset = context;
    return Scaffold(
        //  appBar: AppBar(),
        // floatingActionButton: buildFloatingActionButton(context),
        body: buildBlocConsumer);
  }

  BlocConsumer<UserCubit, UserState> get buildBlocConsumer =>
      BlocConsumer<UserCubit, UserState>(
        listener: (context, state) async {
          if (state is UserUpdate) {
            foundBackUpAlertDialog(context);
          } else if (state is UserError) {
            showScaffoldMessage(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is UserFull) {
            return buildUserProfileView(state.user, context);
          } else if (state is UserNull) {
            return loginRegisterView(context);
          } else if (state is UserLoading) {
            return buildCircularProgressIndicator;
          } else {
            // HANDLE ERROR STATES
            return Center(child: Text(state.toString()));
          }
        },
      );

  Center get buildCircularProgressIndicator =>
      const Center(child: CircularProgressIndicator.adaptive());

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => await context.read<UserCubit>().getCurrentUser(),
      child: const Icon(Icons.add),
    );
  }

  foundBackUpAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('😎 OMG 😎'),
        content: const Text(
            "Kayıtlı veriler bulundu bunları telefonuna yüklemek istermisin ?"),
        actions: buildFoundDialogActionButtons(context),
      ),
    );
  }

  showScaffoldMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<Widget> buildFoundDialogActionButtons(BuildContext context) {
    return <Widget>[
      buildNoButton(context),
      buildYesButton(context),
    ];
  }

  TextButton buildYesButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<UserCubit>().overwriteDataToDb();
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (ModalRoute.withName("/home")));
      },
      child: Text('Yes', style: Theme.of(context).textTheme.bodyText1),
    );
  }

  TextButton buildNoButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: Text('No', style: Theme.of(context).textTheme.bodyText1),
    );
  }
}
