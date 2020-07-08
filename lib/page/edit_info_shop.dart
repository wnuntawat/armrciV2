import 'package:armrci/models/user_model.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditInfoShop extends StatefulWidget {
  final UserModel userModel;
  EditInfoShop({Key key, this.userModel}) : super(key: key);

  @override
  _EditInfoShopState createState() => _EditInfoShopState();
}

class _EditInfoShopState extends State<EditInfoShop> {
  UserModel userModel;
  String dateTimeString, gender, educateString, address, phone, id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    gender = userModel.gendel;
    educateString = userModel.education;
    address = userModel.address;
    phone = userModel.phone;
    id = userModel.id;
    findCurrentTime();
  }

  Future<Null> findCurrentTime() async {
    DateTime dateTime = DateTime.now();
    setState(() {
      dateTimeString = DateFormat('dd-MM-yyyy').format(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit info'),
      ),
      body: Column(
        children: <Widget>[MyStyle().showTextH2('DateTime = $dateTimeString')],
      ),
    );
  }
}
