import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;

class MyQrPage extends StatefulWidget {
  @override
  _MyQrPageState createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  Uint8List bytes = Uint8List(200);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My QR code"),
        backgroundColor: c1,
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 200,
              child: Image.memory(bytes),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: RaisedButton(
                onPressed: _generateBarCode,
                child: Text("Generate My QR Code"),
                color: c1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _generateBarCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString("id");
    Uint8List result = await scanner.generateBarCode(i);
    this.setState(() => this.bytes = result);
  }
}
