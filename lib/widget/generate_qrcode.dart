import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrcode extends StatefulWidget {
  @override
  _GenerateQrcodeState createState() => _GenerateQrcodeState();
}

class _GenerateQrcodeState extends State<GenerateQrcode> {
  File file;
  GlobalKey globalKey = GlobalKey();
  String code = '01110000000055565';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildImage(),
            buildBarcodeWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildBarcodeWidget() => Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: BarcodeWidget(
          data: code,
          barcode: Barcode.code128(),
        ),
      );

  Widget buildImage() {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        width: 200,
        child: QrImage(data: 'RCI123456789'),
      ),
    );
  }

  RaisedButton buildRaisedButton() {
    return RaisedButton(
      onPressed: () => generateThread(),
      child: Text('Generate QRCode'),
    );
  }

  Future<Null> generateThread() async {
    try {
      RenderRepaintBoundary boundary =
          GlobalKey().currentContext.findRenderObject();
      var imageQR = await boundary.toImage();
      ByteData byteData = await imageQR.toByteData(format: ImageByteFormat.png);
      Uint8List uint8list = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      var myfile = await File('${tempDir.path}/qrimage.png').create();
      await myfile.writeAsBytes(uint8list).then((value) {
        print('Success');
      });
    } catch (e) {
      print('e generate===>${e.toString()}');
    }
  }
}
