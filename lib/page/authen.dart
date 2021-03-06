import 'dart:io';

import 'package:armrci/models/user_model.dart';
import 'package:armrci/page/main_shop.dart';
import 'package:armrci/page/main_user.dart';
import 'package:armrci/page/no_internet.dart';
import 'package:armrci/page/register.dart';
import 'package:armrci/utility/my_api.dart';
import 'package:armrci/utility/my_constant.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:armrci/utility/normal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String user, password;
  bool status = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
    findLogin();
  }

  Future<Null> findLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String typeLogin = preferences.getString('Type');
    print('typeLogin ====================== $typeLogin');

    if (typeLogin == null || typeLogin.isEmpty) {
      setState(() {
        status = false;
      });
    } else {
      switch (typeLogin) {
        case 'User':
          print('work');
          routeToService(MainUser());
          break;
        case 'Shop':
          routeToService(MainShop());
          break;
        default:
      }
    }
  }

  void routeToService(Widget widget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: status
          ? MyStyle().showProgress()
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MyStyle().showlogo(),
                    MyStyle().showTextH1('Royal Can'),
                    userForm(),
                    passwordForm(),
                    loginButton(),
                    registerButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Container loginButton() {
    return Container(
      width: 250,
      child: RaisedButton(
        onPressed: () {
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Container registerButton() {
    return Container(
      width: 250,
      child: FlatButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => Register(),
          );
          Navigator.push(context, route);
        },
        child: Text(
          'New Register',
          style: TextStyle(color: Colors.pink),
        ),
      ),
    );
  }

  Widget userForm() => Container(
        margin: EdgeInsets.only(
          top: 16,
        ),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: MyStyle().myInputDecoration('User :'),
        ),
      );

  Widget passwordForm() => Container(
        margin: EdgeInsets.only(
          top: 16,
        ),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          decoration: MyStyle().myInputDecoration('Password :'),
        ),
      );

  Future<Null> checkAuthen() async {
    UserModel model = await MyAPI().getUserWhereUser(user);
    if (model == null) {
      normalDialog(context, 'No user');
    } else {
      if (password == model.password) {
        switch (model.type) {
          case 'User':
            routeTo(MainUser(), model);
            break;
          case 'Shop':
            routeTo(MainShop(), model);
            break;
          default:
        }
      } else {
        normalDialog(context, 'password wrong');
      }
    }
  }

  Future<Null> routeTo(Widget widget, UserModel model) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', model.id);
    preferences.setString('Name', model.name);
    preferences.setString('Type', model.type);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<Null> checkInternet() async {
    try {
      var response = await InternetAddress.lookup('google.com');
      if ((response.isNotEmpty) && (response[0].rawAddress.isNotEmpty)) {
        findLogin();
      }
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NoInternet(),
          ),
          (route) => false);
    }
  }
}
