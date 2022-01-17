import 'package:flutter/material.dart';

Widget buildRoundedTextFormField(String hint, {bool autoFocus = false}) {
  return TextFormField(
    cursorHeight: 18,
    onChanged: (a) {
      //  context.read<ListPageGeneralCubit>().textFormFieldChanged();
    },
    autofocus: autoFocus,
    //   cursorColor: Theme.of(context).co,
    decoration: InputDecoration(
      label: Text(hint),
    ),
  );
}
