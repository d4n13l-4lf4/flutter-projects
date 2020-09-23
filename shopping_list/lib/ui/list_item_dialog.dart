
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/models/list_item.dart';
import 'package:shopping_list/util/dbhelper.dart';

class ListItemDialog {

  final txtName = TextEditingController();
  final txtNote = TextEditingController();
  final txtQuantity = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();

    txtName.text = item.name;
    txtNote.text = item.note;
    txtQuantity.text = item.quantity;

    return AlertDialog(
      title: Text(isNew ? 'New list item' : 'Editing list item'),
      content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: txtName,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Apple'
                ),
              ),
              TextField(
                  controller: txtQuantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: '1'
                  )
              ),
              TextField(
                controller: txtNote,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'An apple'
                ),
              ),
              RaisedButton(
                child: Text('Save list item'),
                onPressed: () {
                  item.name = txtName.text;
                  item.note = txtNote.text;
                  item.quantity = txtQuantity.text;
                  if (isNew) {
                    helper.insertItem(item);
                  } else {
                    helper.updateItem(item);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          )
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
