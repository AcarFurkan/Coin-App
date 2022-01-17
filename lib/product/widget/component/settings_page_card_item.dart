import 'package:flutter/material.dart';

class SettingsCardItem extends StatelessWidget {
  const SettingsCardItem({
    Key? key,
    required this.prefix,
    required this.text,
    this.suffix,
    required this.ontap,
  }) : super(key: key);
  final Widget prefix;
  final String text;
  final Widget? suffix;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
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
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(2, 3), // changes position of shadow
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
                flex: 3,
              ),
              Expanded(
                flex: 25,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              suffix != null
                  ? Expanded(
                      flex: 2,
                      child: suffix!,
                    )
                  : Container(),
              suffix != null
                  ? Spacer(
                      flex: 2,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
