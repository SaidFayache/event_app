import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;

class StaffEventsDetailsPage extends StatefulWidget {
  final Event event;
  StaffEventsDetailsPage({Key key, this.event}) : super(key: key);
  @override
  _StaffEventsDetailsPageState createState() => _StaffEventsDetailsPageState(e: event);
}

class _StaffEventsDetailsPageState extends State<StaffEventsDetailsPage> {
  _StaffEventsDetailsPageState({this.e});
  Event e;
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Staff Events"),
        backgroundColor: c1,
      ),
      body: _getBody(),
    );
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Qrcode Scanner Example'),
//      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.end,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            SizedBox(
//              width: 200,
//              height: 200,
//              child: Image.memory(bytes),
//            ),
//
//            RaisedButton(onPressed: _scan, child: Text("Scan")),
//            RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
//            RaisedButton(onPressed: _generateBarCode, child: Text("Generate Barcode")),
//          ],
//        ),
//      ),
//    );
  }
  Widget _getBody()
  {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: GestureDetector(
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: c1,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Center(
                  child: Text("Scan QR code"),

                ),
              ),
              onTap: _scan,
            ),
          ),
          Text('RESULT  $barcode'),
        ],
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }

  Future _generateBarCode() async {
    Uint8List result = await scanner.generateBarCode('https://github.com/leyan95/qrcode_scanner');
    this.setState(() => this.bytes = result);
  }
}
