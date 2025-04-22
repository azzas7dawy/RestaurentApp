import 'package:flutter/material.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/utils/colors_utility.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final Color cancelColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText = 'Cancel',
    this.confirmColor = ColorsUtility.errorSnackbarColor,
    this.cancelColor = ColorsUtility.progressIndictorColor,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsUtility.elevatedBtnColor,
      title: Text(
        title,
        style: const TextStyle(
          color: ColorsUtility.takeAwayColor,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              message,
              style: const TextStyle(
                color: ColorsUtility.progressIndictorColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            cancelText,
            style: TextStyle(
              color: cancelColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
        ),
        TextButton(
          child: Text(
            confirmText,
            style: TextStyle(
              color: confirmColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    String? cancelText,
    Color? confirmColor,
    Color? cancelColor,
    VoidCallback? onCancel,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AppConfirmationDialog(
          title: title,
          message: message,
          confirmText: confirmText,
          cancelText: cancelText ?? S.of(context).cancel,
          confirmColor: confirmColor ?? ColorsUtility.errorSnackbarColor,
          cancelColor: cancelColor ?? ColorsUtility.progressIndictorColor,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    );
  }
}
