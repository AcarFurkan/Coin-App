part of '../truncgil_page.dart';

extension SortPopupExtension on TruncgilPage {
  PopupMenuButton<SortTypes> buildOrderByPopupMenu(BuildContext context) {
    return PopupMenuButton<SortTypes>(
      key: _menuKey,
      child: buildSortCurrentWidget(context),
      onSelected: (value) {
        context.read<TruncgilPageGeneralCubit>().setorderByDropDownValue(value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SortTypes>>[
        const PopupMenuItem<SortTypes>(
          value: SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE,
          child: Text('High to Low For Last Price'),
        ),
        const PopupMenuItem<SortTypes>(
          value: SortTypes.LOW_TO_HIGH_FOR_LAST_PRICE,
          child: Text('Low to High For Last Price'),
        ),
        const PopupMenuItem<SortTypes>(
          value: SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE,
          child: Text('High to Low For Percentage'),
        ),
        const PopupMenuItem<SortTypes>(
          value: SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE,
          child: Text('Low to High For Percentage'),
        ),
      ],
    );
  }

  Row buildSortCurrentWidget(BuildContext context) {
    SortTypes value =
        context.watch<TruncgilPageGeneralCubit>().getorderByDropDownValue;
    switch (value) {
      case SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE:
        return buildSortByRow(
            context, "Sort by Last Price", Icons.arrow_downward_rounded);
      case SortTypes.LOW_TO_HIGH_FOR_LAST_PRICE:
        return buildSortByRow(
            context, "Sort by Last Price", Icons.arrow_upward_rounded);
      case SortTypes.HIGH_TO_LOW_FOR_PERCENTAGE:
        return buildSortByRow(
            context, "Sort by Percentage", Icons.arrow_downward_rounded);
      case SortTypes.LOW_TO_HIGH_FOR_PERCENTAGE:
        return buildSortByRow(
            context, "Sort by Percentage", Icons.arrow_upward_rounded);

      default:
        return buildSortByRow(
            context, "Sort by Last Price", Icons.arrow_downward_rounded);
    }
  }

  Row buildSortByRow(BuildContext context, String text, IconData iconData) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: AutoSizeText(
            text,
            minFontSize: 6,
            maxLines: 1,
          ),
        ),
        Expanded(
          flex: 2,
          child: Icon(
            iconData,
            size: context.normalValue,
          ),
        )
      ],
    );
  }
}
