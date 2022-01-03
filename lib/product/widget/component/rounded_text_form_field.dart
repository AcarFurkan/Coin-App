import 'package:flutter/material.dart';

Widget buildTextFormField(String hint, {bool autoFocus = false}) {
  return TextFormField(
    cursorHeight: 18,
    onChanged: (a) {
      //  context.read<ListPageGeneralCubit>().textFormFieldChanged();
    },
    autofocus: autoFocus,
    decoration: InputDecoration(
      label: Text(hint),
    ),
  );
}
