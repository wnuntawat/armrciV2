import 'package:armrci/page/add_product_shop.dart';
import 'package:armrci/utility/my_constant.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMyProduct extends StatefulWidget {
  @override
  _ShowMyProductState createState() => _ShowMyProductState();
}

class _ShowMyProductState extends State<ShowMyProduct> {
  String idShop;
  bool waitStatus = true; // true==> Load data
  bool dataStatus = true; //true ==> No menu



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findShopAndMenu();
  }


  Future<Null> findShopAndMenu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString('id');
    
    String url =
        '${MyConstant().domain}/RCI/getProductWhereIdshopUng.php?isAdd=true&IdShop=$idShop';
    await Dio().get(url).then((value) {
      print('value =$value');
      setState(() {
        waitStatus = false;
      });

      if (value.toString() != 'null') {
        setState(() {
          dataStatus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => AddProductShop(),
          );
          Navigator.push(context, route).then((value) => null);
        },
        child: Icon(Icons.restaurant_menu),
      ),
      body: waitStatus
          ? MyStyle().showProgress()
          : dataStatus
              ? Center(child: MyStyle().showTextH1('No product'))
              : Text('Have Data'),
    );
  }
}
