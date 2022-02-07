import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../core/enums/show_type_enums_for_percentage.dart';
import '../../../../../../core/enums/show_type_enums_for_price.dart';
import '../../cubit/coin_cubit.dart';

part 'selected_page_general_state.dart';

class SelectedPageGeneralCubit extends Cubit<SelectedPageGeneralState> {
  SelectedPageGeneralCubit({required this.context})
      : super(SelectedPageGeneralInitial()) {
    myFocusNode = FocusNode();
  }

  bool isSelectedAll = false;
  bool isSearhOpen = false;
  bool isDeletedPageOpen = false;
  late FocusNode myFocusNode;
  BuildContext context;
  TextEditingController? _textEditingController;
  ShowTypeEnumForPercentage _percentageDropdownValue =
      ShowTypeEnumForPercentage.CHANGE_OF_PERCENTAGE_24_HOUR;
  ShowTypesForPrice _priceDropdownValue = ShowTypesForPrice.LAST_PRICE;
  SortTypes _orderByDropdownValue = SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE;

  setorderByDropDownValue(SortTypes type) {
    print(type);

    _orderByDropdownValue = type;
    emit(SelectedPageGeneralInitial());
  }

  SortTypes get getorderByDropDownValue => _orderByDropdownValue;

  setPercentageDropDownValue(ShowTypeEnumForPercentage value) {
    print(value);
    _percentageDropdownValue = value;
    emit(SelectedPageGeneralInitial());
  }

  ShowTypeEnumForPercentage get getPercentageDropDownValue =>
      _percentageDropdownValue;

  setPriceDropDownValue(ShowTypesForPrice value) {
    print(value);
    _priceDropdownValue = value;
    emit(SelectedPageGeneralInitial());
  }

  ShowTypesForPrice get getPriceDropDownValue => _priceDropdownValue;

  TextEditingController? get textEditingController {
    return _textEditingController;
  }

  set textEditingController(TextEditingController? controller) {
    _textEditingController = controller;
  }

  changeValue() {
    isSelectedAll = !isSelectedAll;
    emit(SelectedPageGeneralInitial());
  }

  setIsDeletedPageOpen() {
    emit(SelectedPageGeneralInitial());
    isDeletedPageOpen = !isDeletedPageOpen;
  }

  closeKeyBoardAndUnFocus() {
    if (isSearhOpen) {
      isSearhOpen = !isSearhOpen;
      if (_textEditingController != null) {
        _textEditingController!.clear();
      }
      myFocusNode.unfocus();
    }
  }

  changeIsSearch() {
    isSearhOpen = !isSearhOpen;
    if (isSearhOpen) {
      FocusScope.of(context).requestFocus(myFocusNode);
    }
    if (!isSearhOpen) {
      myFocusNode.unfocus();
    }
    emit(SelectedPageGeneralInitial());
  }

  textFormFieldChanged() {
    emit(SelectedPageGeneralInitial());
  }
}
