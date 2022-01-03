import '../../../core/extension/string_extension.dart';
import '../../language/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsCardItem extends StatelessWidget {
  const SettingsCardItem({
    Key? key,
    required this.prefix,
    required this.text,
    required this.suffix,
    required this.ontap,
  }) : super(key: key);
  final Widget prefix;
  final String text;
  final Widget suffix;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      splashColor: Colors.grey[200],
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 25,
                offset: Offset(2, 8), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 17, horizontal: 12),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: prefix,
              ),
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 15,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Spacer(
                flex: 3,
              ),
              Expanded(
                flex: 2,
                child: suffix,
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
