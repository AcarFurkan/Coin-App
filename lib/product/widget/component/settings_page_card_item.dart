import 'package:coin_with_architecture/core/extension/context_extension.dart';
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
      borderRadius: BorderRadius.all(Radius.circular(context.lowValue * 1.5)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: ontap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.lowValue * 2, horizontal: context.lowValue * 0.3),
        child: Container(
          decoration: buildBoxDecoration(context),
          padding: EdgeInsets.symmetric(
              vertical: context.lowValue * 2.5,
              horizontal: context.lowValue * 2),
          child: buildCardContent(context),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.colors.background,
      borderRadius: BorderRadius.all(
        Radius.circular(context.lowValue * 1.5),
      ),
      boxShadow: buildBoxShadow(context),
    );
  }

  List<BoxShadow> buildBoxShadow(BuildContext context) {
    return [
      BoxShadow(
        color: context.colors.onPrimary.withOpacity(0.4),
        spreadRadius: 1,
        blurRadius: 1,
        offset: const Offset(2, 3), // changes position of shadow
      ),
    ];
  }

  Row buildCardContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: prefix,
        ),
        const Spacer(
          flex: 3,
        ),
        Expanded(
          flex: 25,
          child: Text(
            text,
            style: context.textTheme.bodyText1,
          ),
        ),
        suffix != null
            ? Expanded(
                flex: 2,
                child: suffix!,
              )
            : Container(),
        suffix != null
            ? const Spacer(
                flex: 2,
              )
            : Container()
      ],
    );
  }
}
