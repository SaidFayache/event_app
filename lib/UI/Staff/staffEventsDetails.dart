import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:event_app/API/eventRequests.dart';

class StaffEventsDetailsPage extends StatefulWidget {
  final Event event;
  StaffEventsDetailsPage({Key key, this.event}) : super(key: key);
  @override
  _StaffEventsDetailsPageState createState() => _StaffEventsDetailsPageState(e: event);
}

class _StaffEventsDetailsPageState extends State<StaffEventsDetailsPage> {
  _StaffEventsDetailsPageState({this.e});
  List<String> requestState ;
  int status;
  Requests requests;
  Event e;
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  @override
  void initState() {
    status=0;
    requestState= ["Pending","Unpaid","Accepted","Refused"];
    _getRequests(e.id);
  }
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
              onTap:(){
                _scan().then((val){
                  if(barcode !='')
                  {
                    RequestElement r=requests.requests.where((req)=> req.request.id==barcode).toList()[0];
                  _createPopUp(context,r);
                  }
                });

              } ,
            ),
          ),

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

  void _getRequests(String eventId)
  {
    http.get("https://event-manager-red.herokuapp.com/api/" + "user/request",
        headers: {"event": eventId}).then((http.Response response) {
      setState(() {
        requests=requestsFromJson(response.body);
      });
    });
  }

  Future<void> _createPopUp(BuildContext context,RequestElement r)
  {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Ticket Details"),
          content: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                    child: Text("Ticket's owner : "+r.user.name)
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 5,left: 5),
                    child: Text("Ticket's Price : "+r.plan.cost.toString() +" TND")
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 5,left: 5),
                    child: Text("Ticket's Status : "+requestState[r.request.state]),
                ),
                Container(
                   child: DropdownButton<String>(
                      value: requestState[status],
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 15,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: c1,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          status = requestState.indexOf(newValue);
                        });
                      },
                      items: requestState
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                )
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text("Submit"),
              onPressed: (){

              },
            )
          ],
        );
      },

    );

  }
}
