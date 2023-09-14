import 'package:flutter/material.dart';
import 'package:shopping_cart/ui/items_screen.dart';
import 'package:shopping_cart/ui/shopping_list_dialog.dart';
import 'package:shopping_cart/utils/db_helper.dart';
import 'package:shopping_cart/models/shopping_list.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  ShoppingListDialog dialog = ShoppingListDialog();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({super.key});

  @override
  State<ShList> createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  late List<ShoppingList> shoppingList;
  DbHelper helper = DbHelper();
  late ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: (shoppingList != null) ? shoppingList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(shoppingList[index].name),
            onDismissed: (direction) {
              String strName = shoppingList[index].name;
              helper.deleteList(shoppingList[index]);
              setState(() {
                shoppingList.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar (
                SnackBar(content: Text("$strName deleted"))
              );
            },
            child: ListTile (
              title: Text(shoppingList[index].name),
              leading: CircleAvatar (
                child: Text(shoppingList[index].priority.toString()),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemsScreen(shoppingList[index]),
                  ),
                );
              },
              trailing: IconButton (
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => dialog.buildDialog(
                      context,
                      shoppingList[index],
                      false
                    )
                  );
                },
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton (
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
              dialog.buildDialog(
                context, 
                ShoppingList(0, '', 0),
                true
              ),            
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }


  Future showData () async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }
}