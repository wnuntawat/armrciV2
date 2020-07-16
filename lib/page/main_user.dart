import 'dart:convert';

import 'package:armrci/models/user_model.dart';
import 'package:armrci/page/show_cart.dart';
import 'package:armrci/page/show_menu_shop.dart';
import 'package:armrci/utility/my_constant.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  List<UserModel> userModels = List();
  List<Widget> widgets = List();
  String nameLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readShop();
    findNameLogin();
  }

  Future<Null> findNameLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    nameLogin = preferences.getString('Name');
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/RCI/getUserWhereType.php?isAdd=true&Type=Shop';

    Response response = await Dio().get(url);
    // print('res = $response');

    var result = json.decode(response.data);
    // print('result = $result');
    int index = 0;
    for (var map in result) {
      UserModel model = UserModel.fromJson(map);
      if (!(model.createDate.isEmpty)) {
        // print('nameShop ==>${model.name}');
        setState(() {
          userModels.add(model);
          widgets.add(createWidget(model.name, index));
        });
        index++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                showHead(),
                buildCart(),
              ],
            ),
            MyStyle().menuSignOut(context),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Welcome User'),
      ),
      body: userModels.length == 0 ? MyStyle().showProgress() : buildShop(),
    );
  }

  ListTile buildCart() => ListTile(
        onTap: () {
          Navigator.pop(context);
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => ShowCart(),
          );
          Navigator.push(context, route);
        },
        leading: Icon(
          Icons.add_shopping_cart,
          size: 36,
          color: Colors.black,
        ),
        title: Text('ตะกร้าของฉัน'),
        subtitle: Text('แสดงสินค้าที่เราจะ Order'),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(nameLogin == null ? 'Name ?' : nameLogin),
      accountEmail: Text('Login'),
    );
  }

  Widget buildShop() => GridView.extent(
        maxCrossAxisExtent: 150,
        children: widgets,
      );

  Widget createWidget(String name, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index ===$index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowMenuShop(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              width: 90,
              height: 90,
              child: Image.asset('images/Shop.png'),
            ),
            Text(name)
          ],
        ),
      ),
    );
  }
}
