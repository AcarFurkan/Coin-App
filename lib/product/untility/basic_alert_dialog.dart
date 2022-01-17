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
    child: Text('Yes', style: Theme.of(context).textTheme.bodyText1),
  );
}

TextButton firstTextButton(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.of(context).pop(false),
    child: Text('No', style: Theme.of(context).textTheme.bodyText1),
  );
}
