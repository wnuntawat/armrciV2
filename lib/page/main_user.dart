import 'dart:convert';

import 'package:armrci/models/user_model.dart';
import 'package:armrci/page/show_cart.dart';
import 'package:armrci/page/show_menu_shop.dart';
import 'package:armrci/utility/my_constant.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:armrci/widget/dowmload_file.dart';
import 'package:armrci/widget/generate_qrcode.dart';
import 'package:armrci/widget/read_barcode.dart';
import 'package:armrci/widget/show_chart.dart';
import 'package:armrci/widget/show_location.dart';
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
  Widget currentWidget = ShowChart();

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
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                showHead(),
                buildShowChart(),
                buildShowLocation(),
                buildShowDownloadFile(),
                buildShowGenQrcode(),
                buildCart(),
                buildReadBarcode(),
              ],
            ),
            MyStyle().menuSignOut(context),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[MyStyle().showChart(context)],
        title: Text('Welcome User'),
      ),
       body:  currentWidget
      // body: userModels.length == 0 ? MyStyle().showProgress() : buildShop(),
    );
  }

  ListTile buildShowChart() => ListTile(onTap: () {
    setState(() {
      Navigator.pop(context);
      currentWidget= ShowChart();
    });
  },
        leading: Icon(
          Icons.graphic_eq,
          size: 36,
          color: Colors.cyan,
        ),title: Text('แสดงกราฟ'),subtitle: Text('Demo Show Chart'),
      );


      ListTile buildShowLocation() => ListTile(onTap: () {
    setState(() {
       Navigator.pop(context);
       currentWidget= ShowLocation();
    });
  },
        leading: Icon(
          Icons.map,
          size: 36,
          color: Colors.brown,
        ),title: Text('แสดงพิกัด'),subtitle: Text(' Show ALL User Location '),
      );

 ListTile buildShowDownloadFile() => ListTile(onTap: () {
    setState(() {
       Navigator.pop(context);
       currentWidget= DownloadFile();
    });
  },
        leading: Icon(
          Icons.cloud_download,
          size: 36,
          color: Colors.pink,
        ),title: Text('Download File'),subtitle: Text(' Show File Download '),
      );

ListTile buildShowGenQrcode() => ListTile(onTap: () {
    setState(() {
       Navigator.pop(context);
       currentWidget= GenerateQrcode();
    });
  },
        leading: Icon(
          Icons.crop_landscape,
          size: 36,
          color: Colors.orange,
        ),title: Text('Generate QRcode'),subtitle: Text(' สร้าง QRcode '),
      );




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

  ListTile buildReadBarcode() => ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadBarcode(),
            ),
          );
        },
        leading: Icon(
          Icons.android,
          size: 36,
          color: Colors.green,
        ),
        title: Text('Read Barcode'),
        subtitle: Text('อ่านบาร์โค้ด'),
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
