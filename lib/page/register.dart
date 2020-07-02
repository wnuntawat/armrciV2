import 'package:armrci/utility/my_constant.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:armrci/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<String> types = ['User', 'Shop'];
  String type, name, user, password;

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

  Widget nameForm() => Container(
        margin: EdgeInsets.only(
          top: 16,
        ),
        width: 250,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: MyStyle().myInputDecoration('Name :'),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (name == null ||
              name.isEmpty ||
              user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Please Fill Every Blank');
          } else if (type == null) {
            normalDialog(context, 'โปรดเลือกชนิดของ สมาชิก');
          } else {
            checkUserThread();
            // registerThread();
          }
        },
        child: Icon(Icons.cloud_upload),
      ),
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyStyle().showlogo(),
              nameForm(),
              dropdownType(),
              userForm(),
              passwordForm(),
            ],
          ),
        ),
      ),
    );
  }

  Container dropdownType() => Container(
        child: DropdownButton(
          items: types
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          hint: Text('Choose Type'),
          value: type,
          onChanged: (value) {
            setState(() {
              type = value;
            });
          },
        ),
      );

  Future<Null> registerThread() async {
    DateTime dateTime = DateTime.now();
    String dateString = dateTime.toString();
    print('dateString =$dateString ');
    String urlAPI =
        '${MyConstant().domain}/RCI/addUserarm.php?isAdd=true&Name=$name&User=$user&Password=$password&CreateDate=$dateString&Type=$type';
    Response response = await Dio().get(urlAPI);

    if (response.toString() == 'true') {
      Navigator.pop(context);
    } else {
      normalDialog(context, 'ลองใหม่');
    }
  }

  Future<Null> checkUserThread() async {
    String url =
        '${MyConstant().domain}/RCI/getUserWhereUserUng.php?isAdd=true&User=$user';
    Response response = await Dio().get(url);
    if (response.toString() == 'null') {
      registerThread();
    } else {
      normalDialog(context, '$user user ซ้ำ');
    }
  }
}
