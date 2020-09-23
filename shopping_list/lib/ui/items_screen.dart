
import 'package:flutter/material.dart';
import 'package:shopping_list/models/list_item.dart';
import 'package:shopping_list/models/shopping_list.dart';
import 'package:shopping_list/ui/list_item_dialog.dart';
import 'package:shopping_list/util/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  ItemsScreen(this.shoppingList);

  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  DbHelper helper;
  List<ListItem> items;
  ListItemDialog itemDialog;

  _ItemsScreenState(this.shoppingList);

  @override
  void initState() {
    itemDialog = new ListItemDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    showData(this.shoppingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(items[index].id.toString()),
              onDismissed: (direction) {
                String itemName = items[index].name;
                helper.deleteListItem(items[index].id);
                setState(() {
                  items.removeAt(index);
                });
                Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text("$itemName deleted!"),));
              },
              child: ListTile(
                title: Text(items[index].name),
                subtitle: Text(
                    'Quantity: ${items[index].quantity} - Note: ${items[index].note}'
                ),
                onTap: () {},
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => itemDialog.buildDialog(context, items[index], false),
                    );
                  },
                ),
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => itemDialog.buildDialog(context, ListItem(0, shoppingList.id, '', '', ''), true),
          );
        },
        backgroundColor: Colors.cyan,
      ),
    );
  }

  Future showData(int listId) async {
    await helper.openDb();
    items = await helper.getItems(listId);
    setState(() {
      items = items;
    });
  }
}
