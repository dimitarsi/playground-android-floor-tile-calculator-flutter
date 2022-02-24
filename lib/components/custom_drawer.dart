import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  String currentPage;

  CustomDrawer({key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: Key("$key"),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text("Hello World"),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
          ),
          Text("${key.hashCode}"),
          Text("$currentPage"),
          TextButton(
            child: Text("Calculator"),
            onPressed: goToPage(context, "/"),
          ),
          TextButton(
            child: Text("Projects"),
            onPressed: goToPage(context, "/projects"),
          ),
        ],
      ),
    );
  }

  goToPage(BuildContext context, String routeName) => () {
        if (currentPage != routeName) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      };
}
