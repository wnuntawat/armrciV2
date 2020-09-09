import 'dart:convert';

import 'package:armrci/models/order_model.dart';
import 'package:armrci/utility/my_constant.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowMyOrderShop extends StatefulWidget {
  @override
  _ShowMyOrderShopState createState() => _ShowMyOrderShopState();
}

class _ShowMyOrderShopState extends State<ShowMyOrderShop> {
  String idshop;
  List<OrderModel> orderModels = List();
  bool status = true; // true no order
  List<List<String>> listProducts = List();
  List<List<String>> listPrices = List();
  List<List<String>> listamounts = List();
  List<List<String>> listsums = List();
  List<int> totals = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: status
          ? orderModels.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildListView()
          : Center(
              child: Text('No Order'),
            ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orderModels.length,
      itemBuilder: (context, index) => Column(
        children: [
          buildNameUser(index),
          buildDateTime(index),
          buildHead(),
          buildListViewSmall(index),
          Divider(
            thickness: 1,
            color: Colors.brown.shade500,
          ),
          buildTotal(index)
        ],
      ),
    );
  }

  Row buildTotal(int index) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyStyle().showTextH3Red('Total : '),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: MyStyle().showTextH3('${totals[index]}'),
        )
      ],
    );
  }

  ListView buildListViewSmall(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listProducts[index].length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(listProducts[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Text(listPrices[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Text(listamounts[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Text(listsums[index][index2]),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.black12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text('Product'),
            ),
            Expanded(
              flex: 1,
              child: Text('Price'),
            ),
            Expanded(
              flex: 1,
              child: Text('Amount'),
            ),
            Expanded(
              flex: 1,
              child: Text('Sum'),
            ),
          ],
        ),
      ),
    );
  }

  Row buildDateTime(int index) {
    return Row(
      children: [
        MyStyle().showTextH3(orderModels[index].dateTimeOrder),
      ],
    );
  }

  Row buildNameUser(int index) {
    return Row(
      children: [
        MyStyle().showTextH2(orderModels[index].nameUser),
      ],
    );
  }

  Future<Null> readData() async {
    String urlAPI = '${MyConstant().domain}/RCI/readOrderUng.php';
    await Dio().get(urlAPI).then((value) async {
      print('value====>$value');

      if (value != null) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        idshop = preferences.getString('id');
        print('idshop===>$idshop');

        int i = 0;
        List<dynamic> result = json.decode(value.data);

        for (var json in json.decode(value.data)) {
          OrderModel model = OrderModel.fromJson(json);
          print('nameshop===${model.nameProduct}');
          if (idshop == model.idShop.trim()) {
            List<String> products = changeToArray(model.nameProduct);
            List<String> prices = changeToArray(model.price);
            List<String> amounts = changeToArray(model.amount);
            List<String> sums = changeToArray(model.sum);
            int total = 0;
            for (var sumString in sums) {
              total = total + int.parse(sumString);
            }

            setState(() {
              orderModels.add(model);
              listProducts.add(products);
              listPrices.add(prices);
              listamounts.add(amounts);
              listsums.add(sums);
              totals.add(total);
            });
          }
          i++;
          print('i==>$i');
          if (i >= result.length - 1) {
            if (orderModels.length == 0) {
              setState(() {
                status = false;
              });
            }
          }
        }
      }
    });
  }

  List<String> changeToArray(String string) {
    String result = string.substring(1, string.length - 1);
    print('result ==> $string');
    print('result ==> $result');
    List<String> results = result.split(',');
    int index = 0;
    for (var member in results) {
      results[index] = member.trim();

      index++;
    }
    return results;
  }
}
