import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../selected_coin/viewmodel/cubit/coin_cubit.dart';

part 'bitexen_page_general_state.dart';

class BitexenPageGeneralCubit extends Cubit<BitexenPageGeneralState> {
  BitexenPageGeneralCubit({required this.context})
      : super(BitexenPageGeneralInitial()) {
    myFocusNode = FocusNode();
    searchTextEditingController = TextEditingController();
  }

  bool isSearhOpen = false;
  late FocusNode myFocusNode;
  BuildContext context;

  TextEditingController? searchTextEditingController;
  SortTypes _orderByDropdownValue = SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE;

  setorderByDropDownValue(SortTypes type) {
    _orderByDropdownValue = type;
    emit(BitexenPageGeneralInitial());
  }

  SortTypes get getorderByDropDownValue => _orderByDropdownValue;

  void closeKeyBoardAndUnFocus() {
    if (isSearhOpen) {
      isSearhOpen = !isSearhOpen;
      if (searchTextEditingController != null) {
        searchTextEditingController!.clear();
      }
      myFocusNode.unfocus();
    }
  }

  void changeIsSearch() {
    isSearhOpen = !isSearhOpen;
    if (isSearhOpen) {
      FocusScope.of(context).requestFocus(myFocusNode);
    }
    if (!isSearhOpen) {
      myFocusNode.unfocus();
    }

    emit(BitexenPageGeneralInitial());
  }

  textFormFieldChanged() {
    emit(BitexenPageGeneralInitial());
  }
}
