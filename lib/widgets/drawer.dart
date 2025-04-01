import 'package:flutter/material.dart';
import 'package:task/pages/settings.dart';
import 'package:task/widgets/drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: Icon(Icons.task, size: 100)),
          SizedBox(height: 40),
          DrawerTile(
            title: "Task",
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          DrawerTile(
            title: "Settings",
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),
        ],
      ),
    );
  }
}
