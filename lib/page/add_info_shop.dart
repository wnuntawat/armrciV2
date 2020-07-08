import 'package:armrci/utility/my_style.dart';
import 'package:armrci/utility/normal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddInfoShop extends StatefulWidget {
  @override
  _AddInfoShopState createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  String dateTimeString, gender, educateString, address, phone;
  List<String> educates = [
    'ต่ำกว่า ป.6',
    'มัธยมต้น',
    'มัธยมปลาย',
    'ปริญญาตรี',
    'ปริญญาโท',
    'ปริญญาเอก'
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (address == null ||
              address.isEmpty ||
              phone == null ||
              phone.isEmpty) {
            normalDialog(context, 'กรุณากรอกที่อยู่เบอร์โทร');
          } else if (gender == null) {
            normalDialog(context, 'กรุณาเลือกเพศ');
          } else if (educateString == null) {
            normalDialog(context, 'กรุณาเลือกการศึกษา');
          } else {}
        },
        child: Icon(Icons.cloud_upload),
      ),
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลร้านค้า'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            titleDate(),
            showDate(),
            addressForm(),
            phoneForm(),
            genderGroup(),
            educateGroup(),
          ],
        ),
      ),
    );
  }

  Container educateGroup() => Container(
        child: DropdownButton<String>(
          value: educateString,
          items: educates
              .map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ))
              .toList(),
          hint: Text('โปรดเลือกการศึกษา'),
          onChanged: (value) {
            setState(() {
              educateString = value;
            });
          },
        ),
      );

  Container genderGroup() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            maleRadio(),
            femaleRadio(),
          ],
        ),
      );

  Row maleRadio() {
    return Row(
      children: <Widget>[
        Radio(
          value: 'Male',
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
        Text('ชาย')
      ],
    );
  }

  Row femaleRadio() {
    return Row(
      children: <Widget>[
        Radio(
          value: 'Female',
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
        Text('หญิง')
      ],
    );
  }

  Row showDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyStyle().showTextH1(dateTimeString == null ? '' : dateTimeString),
      ],
    );
  }

  Widget titleDate() => MyStyle().showTextH2('วันเวลาที่บันทึก');

  Widget addressForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          onChanged: (value) => address = value.trim(),
          decoration: MyStyle().myInputDecoration('ที่อยู่ :'),
        ),
      );

  Widget phoneForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          onChanged: (value) => phone = value.trim(),
          keyboardType: TextInputType.phone,
          decoration: MyStyle().myInputDecoration('เบอร์โทรศัพท์ :'),
        ),
      );
}
