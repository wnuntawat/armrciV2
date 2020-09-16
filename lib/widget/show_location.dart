import 'dart:convert';

import 'package:armrci/models/location_model.dart';
import 'package:armrci/utility/my_constant.dart';
import 'package:armrci/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowLocation extends StatefulWidget {
  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  bool statusClick = true;
  double lat = 13.647603, lng = 100.320767;
  List<LocationModel> locationModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, bottom: 20),
            child: FloatingActionButton(
              backgroundColor:
                  statusClick ? Colors.brown : Colors.brown.shade50,
              onPressed: () {
                if (statusClick) {
                  print('You Click Add');

                  insertLocationToServer();

                  setState(() {
                    statusClick = false;
                  });
                } else {
                  print('Cannot Click Add');
                }
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: locationModels.length == 0
          ? MyStyle().showProgress()
          : buildShowMap(),
    );
  }

  Marker currentMarker() {
    return Marker(
      markerId: MarkerId('currentId'),
      position: LatLng(13.647603, 100.320767),
      infoWindow:
          InfoWindow(title: 'คุณอยู่ที่นี่', snippet: 'ตำแหน่งปัจจุบันของคุณ'),
    );
  }

  Set<Marker> setMarkers() {
    List<Marker> myMarker = List();
    int index = 0;
    double colorHue = 60.0;
    for (var model in locationModels) {
      colorHue = colorHue + index * 10;
      Marker marker = Marker(
          markerId: MarkerId('id$index'),
          position: LatLng(
            double.parse(model.lat.trim()),
            double.parse(model.lng.trim()),
          ),
          infoWindow: InfoWindow(title: model.name, snippet: model.dateTime),
          icon: BitmapDescriptor.defaultMarkerWithHue(colorHue));
      myMarker.add(marker);
      index++;
    }
    myMarker.add(currentMarker());
    return myMarker.toSet();
  }

  Widget buildShowMap() {
    LatLng latLng = LatLng(13.647603, 100.320767);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16,
    );
    return GoogleMap(
      initialCameraPosition: cameraPosition,
      mapType: MapType.normal,
      onMapCreated: (controller) {},
      markers: setMarkers(),
    );
  }

  Future<Null> insertLocationToServer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String name = preferences.getString('Name');
    DateTime currentDateTime = DateTime.now();
    String dateTime = DateFormat('dd-MM-yyyy HH:mm').format(currentDateTime);

    String path =
        '${MyConstant().domain}/RCI/addLocation.php?isAdd=true&Name=$name&DateTime=$dateTime&Lat=$lat&Lng=$lng';
    print('path===>$path');
    await Dio().get(path).then((value) {});
  }

  Future<Null> readAllLocation() async {
    String path = '${MyConstant().domain}/RCI/getAllLocation.php';
    await Dio().get(path).then((value) {
      // print('value===>$value');

      var result = json.decode(value.data);
      for (var json in result) {
        LocationModel model = LocationModel.fromJson(json);

        setState(() {
          locationModels.add(model);
        });
      }
    });
  }
}
