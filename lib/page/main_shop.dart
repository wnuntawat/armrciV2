import 'package:armrci/widget/show_info_shop.dart';
import 'package:armrci/widget/show_my_order_shop.dart';
import 'package:armrci/widget/show_my_product.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShop extends StatefulWidget {
  @override
  _MainShopState createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  Widget currentwidget = ShowMyOrderShop();
  String idShop,nameShop;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findShop();
  }

Future<Null> findShop() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    idShop = preferences.getString('id');
    nameShop = preferences.getString('Name');
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text(nameShop == null ? 'Welcome Shop' : 'ร้าน $nameShop'),
      ),
      body: currentwidget,
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
          setState(() {
            currentwidget = ShowMyOrderShop();
          });
        },
      );

  ListTile menuMyProduct() => ListTile(
        leading: Icon(Icons.looks_two),
        title: Text('Show My Product'),
        subtitle: Text('ดูรายการสินค้า'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentwidget = ShowMyProduct();
          });
        },
      );

  ListTile menuMyInformation() => ListTile(
        leading: Icon(Icons.looks_3),
        title: Text('Show My Information'),
        subtitle: Text('ดูรายละเอียดร้าน'),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentwidget = ShowInfoShop(idShop:idShop,);
          });
        },
      );
}
