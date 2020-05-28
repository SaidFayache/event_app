import 'package:event_app/API/eventsModel.dart';
import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'staffEventCounting.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:event_app/API/eventRequests.dart';
import 'package:event_app/Const/strings.dart';
import 'package:event_app/Services/sendHtmlRequest.dart';


class StaffEventsDetailsPage extends StatefulWidget {
  final Event event;
  StaffEventsDetailsPage({Key key, this.event}) : super(key: key);
  @override
  _StaffEventsDetailsPageState createState() => _StaffEventsDetailsPageState(e: event);
}

class _StaffEventsDetailsPageState extends State<StaffEventsDetailsPage> {
  _StaffEventsDetailsPageState({this.e});
  String val;
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
                    print("barcode found :"+barcode);
                    RequestElement r=requests.requests.where((req)=> req.request.id.compareTo(barcode)==0).toList()[0];
                    _createPopUp(context,r);
                  }
                });

              } ,
            ),
          ),
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
                  child: Text("Countings"),

                ),
              ),
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  EventCountingPage(event: e,)),
                );
              } ,
            ),
          ),

        ],
      ),
    );
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
                          status=requestState.indexOf(newValue);
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
                _updateRequest(r.request.id);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },

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

  void _getRequests(String eventId) async
  {
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/request",context: context,showLoading: false);
    httpBuilder
        .get()
        .headers({
      "event": eventId,
    })
        .onSuccess((http.Response response) async {
      setState(() {
        requests=requestsFromJson(response.body);
      });

    });

    httpBuilder.run();

  }
  void _updateRequest(String reqId,) async
  {

    String body = '{"id":"'+reqId+'","state":"'+status.toString()+'"}';
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/request",context: context,showLoading: false);
    httpBuilder
        .put()
        .body(body)
        .headers({
      "Content-Type": "application/json",
    })
        .onSuccess((http.Response response) async {
      setState(() {
        _getRequests(e.id);
      });

    });

    httpBuilder.run();

  }
  void change(String n)
  {
    print(n);

    setState(() {
      this.val=n;
    });
    print(val);

  }
}
