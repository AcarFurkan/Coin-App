import 'package:flutter/material.dart';

import '../../../core/extension/context_extension.dart';

Widget buildTextFormFieldWithAnimation(BuildContext context,
    {required bool isSearchOpen,
    required TextEditingController controller,
    required VoidCallback? onChanged,
    required FocusNode focusNode}) {
  return AnimatedSize(
    curve: Curves.decelerate,
    duration: context.normalDuration,
    child: SizedBox(
      height: isSearchOpen ? context.height * 0.07 : 0,
      child: Padding(
        padding: context.paddingLow,
        child: AnimatedOpacity(
          duration: context.lowDuration,
          opacity: isSearchOpen ? 1 : 0,
          child: _buildTextFormField(
              isSearchOpen, context, controller, onChanged, focusNode),
        ),
      ),
    ),
  );
}

TextFormField _buildTextFormField(
    bool isSearchOpen,
    BuildContext context,
    TextEditingController controller,
    VoidCallback? onChanged,
    FocusNode focusNode) {
  return TextFormField(
    cursorHeight: isSearchOpen ? context.height * 0.02 : 0,
    controller: controller,
    cursorColor: Theme.of(context).colorScheme.onBackground,
    onChanged: (a) {
      onChanged;
    },
    focusNode: focusNode,
    autofocus: isSearchOpen ? true : false,
    //  decoration: const InputDecoration(border: OutlineInputBorder()),
  );
}
