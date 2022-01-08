import 'package:coin_with_architecture/core/enums/back_up_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kartal/kartal.dart';

import '../../../../product/model/user/my_user_model.dart';
import '../../viewmodel/cubit/user_cubit.dart';
part './subview/login_register_view.dart';
part './subview/form_fields_for_register.dart';
part './subview/form_fields_for_login.dart';

class UserSettings extends StatelessWidget {
  UserSettings({Key? key}) : super(key: key);
  MyUser? userInformationForUpdate;

  late BuildContext _buildContextForViewInset;
  @override
  Widget build(BuildContext context) {
    _buildContextForViewInset = context;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await context.read<UserCubit>().getCurrentUser();
          },
          child: Icon(Icons.add),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) async {
            if (state is UserUpdate) {
              //ScaffoldMessenger.of(context)
              //    .showSnackBar(SnackBar(content: Text("data")));
              foundBackUpAlertDialog(context);
            }
            //if (state is UserNull) {
            //  Navigator.pushNamed(context, "/login");
            //}
          },
          builder: (context, state) {
            if (state is UserFull) {
              MyUser user = state.user;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                    Text(user.name ?? ""),
                    ListTile(
                      title: Text("Hey" + (user.name ?? "") + "😍"),
                    ),
                    InkWell(
                      child: ListTile(
                        title:
                            Text("Back Up " + (user.backUpType ?? "") + "😍"),
                      ),
                      onTap: () {
                        selectedBackUpTypeAlertDialog(context);
                      },
                    ),
                    Text((user.email ?? "")),
                    Text((user.isBackUpActive.toString())),
                    Text((user.backUpType ?? "")),
                    Text((user.isBackUpActive.toString())),
                    OutlinedButton(
                        onPressed: () {
                          context.read<UserCubit>().updateUser();
                        },
                        child: Text("Save changes")),
                    OutlinedButton(
                        onPressed: () {
                          context.read<UserCubit>().signOut();
                        },
                        child: Text("Sign Out")),
                    context.watch<UserCubit>().user?.backUpType ==
                            BackUpTypes.tapped.name
                        ? OutlinedButton(
                            onPressed: () async {
                              await context
                                  .read<UserCubit>()
                                  .backUpWhenTapped();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(" back up successful"),
                                duration: Duration(milliseconds: 600),
                              ));
                            },
                            child: Text("back up"))
                        : Container(),
                  ]);
            } else if (state is UserNull) {
              print(
                  "NULLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
              return loginRegisterView(context);
            } else if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else {
              print(state.toString());

              return Center(child: Text(state.toString()));
            }
          },
        ));
  }

  selectedBackUpTypeAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('🗂️  Back Up To Cloud  🗂️'), //🗃️
        content: Container(
          height: 300,
          width: 300,
          color: Colors.transparent,
          child: BlocConsumer<UserCubit, UserState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Material(
                //BUNU CARD YAPIP TRANSPARENT YAPINCA FARKLI BİR RENK ALIYOR NEDEN BİR ARAŞTIR
                color: Colors.transparent,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: BackUpTypes.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    return RadioListTile<String>(
                      title: Text(BackUpTypes.values.toList()[index].name),
                      value: BackUpTypes.values.toList()[index].name,
                      groupValue: context.watch<UserCubit>().groupValue,
                      onChanged: (onChanged) async {
                        context.read<UserCubit>().changeGroupValue(onChanged!);
                        context.read<UserCubit>().updateUser();

                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  foundBackUpAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('😎 OMG 😎'),
        content: const Text(
            "Lan lan cloud da sende olandan farklı veriler geldi bunları verilerinini üstüne yazmak istermisin yavrummm lüüllüüülüüü"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop(true);
              context.read<UserCubit>().overwriteDataToDb();

              //  Navigator.popUntil(context, (ModalRoute.withName("/home")));
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (ModalRoute.withName("/home")));
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
