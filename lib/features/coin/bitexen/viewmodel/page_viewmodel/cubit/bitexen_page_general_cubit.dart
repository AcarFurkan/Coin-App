import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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
