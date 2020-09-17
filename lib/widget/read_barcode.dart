import 'package:armrci/utility/my_style.dart';
import 'package:armrci/utility/normal_dialog.dart';
import 'package:armrci/widget/detail_barcode.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReadBarcode extends StatefulWidget {
  @override
  _ReadBarcodeState createState() => _ReadBarcodeState();
}

class _ReadBarcodeState extends State<ReadBarcode> {
  String barcodeString, itemCode, weightCode, priceCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Barcode'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildBarcodeButton(),
          itemCode == null ? SizedBox() : buildTextResult(),
        ],
      ),
    );
  }

  Widget buildTextResult() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              child: ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBarcode(
                      barcodeString: itemCode,
                    ),
                  ),
                ),
                title: MyStyle().showTextH2('ItemCode = $itemCode'),
                trailing: Icon(
                  Icons.forward,
                  size: 36,
                  color: Colors.indigo,
                ),
              ),
            ),
          ),
          MyStyle().showTextH2('WeightCode===>$weightCode'),
          MyStyle().showTextH2('PriceCode===>$priceCode'),
          Text(itemCode),
        ],
      );

  Row buildBarcodeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            print('You Click');
            barCodeReader();
          },
          child: Card(
            child: Container(
              width: 150,
              child: Image.asset('images/barcode.png'),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> barCodeReader() async {
    try {
      var result = await BarcodeScanner.scan();
      barcodeString = result.rawContent;
      print('barcode===>$barcodeString');

      if (barcodeString.length == 20) {
        decodeBarCode();
      } else if (barcodeString.length == 22) {
      } else {
        normalDialog(context, 'Barcode ไม่มีฐานข้อมูล');
      }
    } catch (e) {}
  }

  void decodeBarCode() {
    setState(() {
      itemCode = barcodeString.substring(0, 8);
      // print('itemcode====>$itemCode');

      weightCode = barcodeString.substring(8, 14);
      weightCode =
          '${weightCode.substring(0, 3)}.${weightCode.substring(3, 6)}';

      double weightDouble = double.parse(weightCode);
      var myFormat = NumberFormat('##0.000', 'en_US');
      weightCode = myFormat.format(weightDouble);
      // print('weightCode====>$weightCode');
      // print('weightDouble====>$weightDouble');

      priceCode = barcodeString.substring(14, 20);
      priceCode = '${priceCode.substring(0, 4)}.${priceCode.substring(4, 6)}';
      double priceDou = double.parse(priceCode);
      var priceFormat = NumberFormat('##0.00', 'en_US');
      priceCode = priceFormat.format(priceDou);
      print('priceCode====>$priceCode');
    });
  }
}
