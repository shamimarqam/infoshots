import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(20),

            child: Row(
              children: [
                Icon(Icons.bolt, size: 32),
                SizedBox(width: 16),
                Text("Infoshots"),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, size: 26),
            title: Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.favorite, size: 26),
            title: Text('Favourites'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
