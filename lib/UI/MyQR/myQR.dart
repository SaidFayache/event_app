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
  String username = "";

  @override
  void initState() {
    _generateBarCode();
    super.initState();
  }
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
      child: Card(
        elevation: 12,
        child: Container(
          height: MediaQuery.of(context).size.height*0.7,
          width: MediaQuery.of(context).size.width*0.9,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(username,style: TextStyle(fontSize: 40),),
                  SizedBox(height: 50,),
                  Image.memory(bytes)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _generateBarCode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString("id");
    username = pref.getString("name");
    print(i);
    Uint8List result = await scanner.generateBarCode(i);
    this.setState(() => this.bytes = result);
  }
}
