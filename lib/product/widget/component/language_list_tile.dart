import 'package:coin_with_architecture/core/extension/context_extension.dart';
import 'package:coin_with_architecture/features/settings/subpage/language_page/viewmodel/language_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class LanguageListTileItem extends StatelessWidget {
  const LanguageListTileItem(
      {Key? key,
      required this.leading,
      required this.text,
      required this.countryCode})
      : super(key: key);
  final Widget leading;
  final String text;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<LanguageViewModel>().setLanguage(countryCode),
      child: Container(
        height: context.lowValue * 7,
        decoration: BoxDecoration(
          color: context.theme.appBarTheme.backgroundColor,
          borderRadius:
              BorderRadius.all(Radius.circular(context.lowValue * 1.5)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(5, 10), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(context.lowValue * 2),
        child: buildCardContent(context),
      ),
    );
  }

  Row buildCardContent(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: leading,
        ),
        const Spacer(
          flex: 1,
        ),
        Expanded(
          flex: 6,
          child: Text(text, style: context.theme.textTheme.bodyText1),
        ),
        const Spacer(
          flex: 3,
        ),
      ],
    );
  }
}
