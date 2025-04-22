import 'package:flutter/material.dart';

class ItemModal extends StatelessWidget {
  final String? showModal;
  final VoidCallback onSubmit;
  final VoidCallback onDelete;

  const ItemModal({
    required this.showModal,
    required this.onSubmit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(showModal == 'add' ? 'Add Item' : 'Edit Item'),
      content: Form(
        child: Column(
          children: [
            // Form fields go here
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: onSubmit, child: Text('Submit')),
        if (showModal == 'delete') TextButton(onPressed: onDelete, child: Text('Delete')),
      ],
    );
  }
}