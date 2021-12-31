import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'list_page_general_state.dart';

class ListPageGeneralCubit extends Cubit<ListPageGeneralState> {
  ListPageGeneralCubit({required this.context})
      : super(ListPageGeneralInitial()) {
    myFocusNode = FocusNode();
  }

  bool isSearhOpen = false;
  late FocusNode myFocusNode;
  BuildContext context;

  TextEditingController? _textEditingController;

  TextEditingController? get textEditingController {
    return _textEditingController;
  }

  set textEditingController(TextEditingController? controller) {
    _textEditingController = controller;
  }

  void closeKeyBoardAndUnFocus() {
    if (isSearhOpen) {
      isSearhOpen = !isSearhOpen;
      if (_textEditingController != null) {
        _textEditingController!.clear();
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

    emit(ListPageGeneralInitial());
  }

  void textFormFieldChanged() {
    emit(ListPageGeneralInitial());
  }
}
