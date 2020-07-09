import 'dart:io';

import 'package:armrci/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductShop extends StatefulWidget {
  @override
  _AddProductShopState createState() => _AddProductShopState();
}

class _AddProductShopState extends State<AddProductShop> {
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddProduct'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            imageGroup(),
            nameForm(),
            priceForm(),
            detailForm()
          ],
        ),
      ),
    );
  }

  Widget nameForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          decoration: MyStyle().myInputDecoration('Name Product'),
        ),
      );

  Widget priceForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          decoration: MyStyle().myInputDecoration('Price Product'),
        ),
      );

  Widget detailForm() => Container(
        width: 250,
        margin: EdgeInsets.only(top: 16),
        child: TextField(
          decoration: MyStyle().myInputDecoration('Detail Product'),
        ),
      );

  Future<Null> chooseSource(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget imageGroup() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseSource(ImageSource.camera),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: 200,
            height: 200,
            child:
                file == null ? Image.asset('images/pic.png') : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseSource(ImageSource.gallery),
          ),
        ],
      );
}
