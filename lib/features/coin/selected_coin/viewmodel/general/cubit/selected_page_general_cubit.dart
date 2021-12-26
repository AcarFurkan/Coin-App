import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

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
