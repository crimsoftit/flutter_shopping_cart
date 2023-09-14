import 'package:flutter/material.dart';
import 'package:shopping_cart/models/list_items.dart';
import 'package:shopping_cart/models/shopping_list.dart';
import 'package:shopping_cart/utils/db_helper.dart';


class ItemsScreen extends StatefulWidget {

  final ShoppingList shoppingList;

  const ItemsScreen(this.shoppingList, {super.key});

  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {

  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);

  DbHelper helper = DbHelper();

  late List<ListItem> items;

  @override
  Widget build(BuildContext context) {
    helper = DbHelper();
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
        itemCount: (items != null) ? items.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(items[index].name),
            subtitle: Text(
              'quantity: ${items[index].quantity} - Note: ${items[index].note}'
            ),
            onTap: () {
              
            },
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                
              },
            ),
          );
        }
      ),
    );
  }

  Future showData (int idList) async {
    await helper.openDb();
    items = await helper.getItems(idList);
    setState(() {
      items = items;
    });
  }
}
