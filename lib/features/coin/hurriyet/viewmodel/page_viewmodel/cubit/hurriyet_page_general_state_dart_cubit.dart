import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'hurriyet_page_general_state_dart_state.dart';

class HurriyetPageGeneralStateDartCubit
    extends Cubit<HurriyetPageGeneralStateDartState> {
  HurriyetPageGeneralStateDartCubit({required this.context})
      : super(HurriyetPageGeneralStateDartInitial()) {
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

    emit(HurriyetPageGeneralStateDartInitial());
  }

  textFormFieldChanged() {
    emit(HurriyetPageGeneralStateDartInitial());
  }
}
