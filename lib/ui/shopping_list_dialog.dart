import 'package:flutter/material.dart';
import 'package:shopping_cart/utils/db_helper.dart';
import 'package:shopping_cart/models/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DbHelper helper = DbHelper();

    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }

    return AlertDialog(
      title: Text((isNew) ? 'new entry' : 'edit entry'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'product name'),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'product priority (1-3)'),
            ),
            ElevatedButton(
              child: const Text('save'),
              onPressed: () {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                helper.insertList(list);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}