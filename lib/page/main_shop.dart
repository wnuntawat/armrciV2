import 'package:flutter/material.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text('Welcome Shop'),
      ),
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(accountName: null, accountEmail: null),
          menuMyorder(),
          menuMyProduct(),
          menuMyInformation(),
        ],
      ),
    );
  }

  ListTile menuMyorder() => ListTile(
        leading: Icon(Icons.looks_one),
        title: Text('Show My Order'),
        subtitle: Text('ดูรายการสั่งของ'),
        onTap: () {
          Navigator.pop(context);
        },
      );

  ListTile menuMyProduct() => ListTile(
        leading: Icon(Icons.looks_two),
        title: Text('Show My Product'),
        subtitle: Text('ดูรายการสินค้า'),
        onTap: () {
          Navigator.pop(context);
        },
      );

  ListTile menuMyInformation() => ListTile(
        leading: Icon(Icons.looks_3),
        title: Text('Show My Information'),
        subtitle: Text('ดูรายละเอียดร้าน'),
        onTap: () {
          Navigator.pop(context);
        },
      );
}
