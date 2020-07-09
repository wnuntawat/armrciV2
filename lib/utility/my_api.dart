import 'dart:convert';

import 'package:armrci/models/user_model.dart';
import 'package:armrci/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'normal_dialog.dart';

class MyAPI {
  Future<Null> editValueOnMySQL(
      BuildContext context,
      String id,
      String dateTimeString,
      String address,
      String phone,
      String gender,
      String educateString) async {
    String url =
        '${MyConstant().domain}/RCI/editUserWhereIdArm.php?id=$id&isAdd=true&CreateDate=$dateTimeString&Address=$address&Phone=$phone&Gendel=$gender&Education=$educateString';
    await Dio().get(url).then((value) {
      print('id= $id  value=${value.toString()}');
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'Please Try again');
      }
    });
  }

  Future<UserModel> getUserWhereUser(String user) async {
    String url =
        '${MyConstant().domain}/RCI/getUserWhereUserUng.php?isAdd=true&User=$user';
    Response response = await Dio().get(url);
    print('res =$response');
    if (response.toString() == 'null') {
      return null;
    } else {
      var result = json.decode(response.data);
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        return model;
      }
    }
  }

  MyAPI();
}
