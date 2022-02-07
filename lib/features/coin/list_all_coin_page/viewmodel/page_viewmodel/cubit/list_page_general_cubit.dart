import 'package:bloc/bloc.dart';
import '../../../../selected_coin/viewmodel/cubit/coin_cubit.dart';
import 'package:flutter/material.dart';

part 'list_page_general_state.dart';

class ListPageGeneralCubit extends Cubit<ListPageGeneralState> {
  ListPageGeneralCubit({required this.context})
      : super(ListPageGeneralInitial()) {
    myFocusNode = FocusNode();
    textEditingController = TextEditingController();
  }

  bool isSearhOpen = false;
  late FocusNode myFocusNode;
  BuildContext context;
  SortTypes _orderByDropdownValue = SortTypes.HIGH_TO_LOW_FOR_LAST_PRICE;
  final GlobalKey menuKeyUSD = GlobalKey();
  final GlobalKey menuKeyTRY = GlobalKey();
  final GlobalKey menuKeyETH = GlobalKey();
  final GlobalKey menuKeyBTC = GlobalKey();
  final GlobalKey menuKeyNEW = GlobalKey();

  setorderByDropDownValue(SortTypes type) {
    _orderByDropdownValue = type;
    emit(ListPageGeneralInitial());
  }

  SortTypes get getorderByDropDownValue => _orderByDropdownValue;

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

  textFormFieldChanged() {
    emit(ListPageGeneralInitial());
  }
}
