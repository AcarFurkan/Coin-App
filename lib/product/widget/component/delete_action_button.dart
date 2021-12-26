import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteActionButton extends StatelessWidget {
  final VoidCallback function;
  const DeleteActionButton({Key? key, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("bütün coinleri sileceksin emin misin ??????"),
                actions: [
                  CupertinoDialogAction(
                    // isDefaultAction: true,
                    child: const Text("Yes"),
                    onPressed: function,
                  ),
                  CupertinoDialogAction(
                    child: const Text("No"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      },
    );
  }
}
