import 'package:coin_with_architecture/core/extension/context_extension.dart';
import 'package:coin_with_architecture/core/extension/string_extension.dart';
import 'package:coin_with_architecture/product/language/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showBasicAlertDialog(BuildContext context,
    {required String title, required String content}) {
  return (showDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        firstTextButton(context),
        secondTextButton(context),
      ],
    ),
  ));
}

TextButton secondTextButton(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.of(context).pop(true),
    child: Text(LocaleKeys.exitAlertDiolog_yes.locale,
        style: context.textTheme.bodyText1),
  );
}

TextButton firstTextButton(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.of(context).pop(false),
    child: Text(LocaleKeys.exitAlertDiolog_no.locale,
        style: context.textTheme.bodyText1),
  );
}
