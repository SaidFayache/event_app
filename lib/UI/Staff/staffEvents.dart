import 'package:event_app/API/eventsModel.dart';
import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'staffEventsDetails.dart';
import 'package:event_app/Const/strings.dart';
import 'package:event_app/Services/sendHtmlRequest.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:event_app/API/eventRequests.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:toast/toast.dart';
import 'package:event_app/UI/Staff/staffEventCounting.dart';



class StaffEventsPage extends StatefulWidget {
  @override
  _StaffEventsPageState createState() => _StaffEventsPageState();
}

class _StaffEventsPageState extends State<StaffEventsPage> {
  StaffEvents myEvts;
  String val;
  List<String> requestState ;
  int status;
  Map<String,Requests> requests;
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  List<Event> evtsList;

  @override
  void initState() {
    evtsList = new List();
    requests=new Map();
    _getEventsList();
    status=0;
    requestState= ["Pending","Unpaid","Accepted","Refused"];
    super.initState();
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
  Widget _getBody() {
    return Container(
      child: ListView.builder(
        itemCount: evtsList.length,
        itemBuilder: (BuildContext context, int index) {
          return getCard(evtsList[index]);
        },
      ),
    );
  }

  Widget getCard(Event e) {
    return GestureDetector(
      child: Container(
        child: Card(
          child: Row(
            children:<Widget>[
              Container(height: 150,width: 5,color: Colors.deepOrange,),
              SizedBox(width: 15,),
              Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                      child: Text(
                        e.name,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 150,
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
                        _scan().then((val) async{
                          int s;
                          if(barcode !='')
                          {
                            print("barcode found :"+barcode);
                            if(!requests[e.id].requests.where((req)=> req.request.id.compareTo(barcode)==0).toList().isEmpty)
                            {RequestElement r=requests[e.id].requests.where((req)=> req.request.id.compareTo(barcode)==0).toList()[0];
                            await _createPopUp(context,r);
                            }
                            else
                            {
                              Toast.show("Request id not found", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                            }

                          }
                          _getRequests(e.id);
                        });

                      } ,
                    ),
                    SizedBox(width: 15,),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: 150,
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

                  ],
                )
              ],
            ),

            ]
          ),
        ),
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  StaffEventsDetailsPage(event: e,)),
        );
      },
    );
  }
  Future<void> _createPopUp(BuildContext context,RequestElement r)
  {
    int val=0;
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
                    child:
                    Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child:Text("Update Ticket status to :"),
                        ),
                        sendChoice(0, r,context),
                        sendChoice(1, r,context),
                        sendChoice(2, r,context),
                        sendChoice(3, r,context),
//                        ListTile(
//                          title:  Text(requestState[0]),
//                          leading: Radio(
//                            value: 0,
//                            groupValue: val,
//                            onChanged: (int value) {
//                              setState(() {
//                                status = value;
//                                val=value;
//                              });
//                              setState(() {
//                                super.setState((){});
//                              });
//                            },
//                          ),
//                        ),
//                        ListTile(
//                          title:  Text(requestState[1]),
//                          leading: Radio(
//                            value: 1,
//                            groupValue: val,
//                            onChanged: (int value) {
//                              setState(() {
//                                status = value;
//                                val=value;
//                              });
//                              setState(() {
//                                super.setState((){});
//                              });
//                            },
//                          ),
//                        ),
//                        ListTile(
//                          title:  Text(requestState[2]),
//                          leading: Radio(
//                            value: 2,
//                            groupValue: val,
//                            onChanged: (int value) {
//
//                              setState(() {
//                                super.setState((){
//                                  status = value;
//                                val=value;});
//                              });
//                            },
//                          ),
//                        ),
//                        ListTile(
//                          title:  Text(requestState[3]),
//                          leading: Radio(
//                            value: 3,
//                            groupValue: val,
//                            onChanged: (int value) {
//                              setState(() {
//                                status = value;
//                                val=value;
//                              });
//                            },
//                          ),
//                        ),

                      ],
                    )
//                    DropdownButton<String>(
//                      value: requestState[status],
//                      icon: Icon(Icons.arrow_downward),
//                      iconSize: 15,
//                      elevation: 16,
//                      underline: Container(
//                        height: 2,
//                        color: c1,
//                      ),
//                      onChanged: (String newValue) {
//                        setState(() {
//                          status=requestState.indexOf(newValue);
//                        });
//
//                      },
//                      items: requestState
//                          .map<DropdownMenuItem<String>>((String value) {
//                        return DropdownMenuItem<String>(
//                          value: value,
//                          child: Text(value),
//                        );
//                      }).toList(),
//                    )
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
//            MaterialButton(
//              child: Text("Submit"),
//              onPressed: (){
//                _updateRequest(r.request.id,this.context,r.request.event);
//               // Navigator.of(context).pop();
//              },
//            )
          ],
        );
      },

    );
  }
  Widget sendChoice(int i,RequestElement r,BuildContext ctxt)
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(color: c1,blurRadius: 5)
          ]
      ),
      child: Card(
        child: GestureDetector(
          child: Center(child: Text(requestState[i])),
          onTap: (){
            setState(() {
              status=i;
            });
            _updateRequest(r.request.id, context, r.request.event);
          },
        ),
      ),
    );


  }
  void _getEventsList() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString("id");
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/staff/events",context: context,showLoading: false);
    httpBuilder
        .get()
        .headers({
      "user": i,
    })
        .onSuccess((http.Response response) async {
      setState(() {
        myEvts=staffEventsFromJson(response.body);
        evtsList=myEvts.events;
        for (var e in evtsList)
        {
          _getRequests(e.id);
        }
      });

    });

    httpBuilder.run();

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
      print(response.body);
      setState(() {
        requests[eventId]=requestsFromJson(response.body);
      });

    });

    httpBuilder.run();

  }
  void _updateRequest(String reqId,BuildContext ctxt,String eventId) async
  {

    String body = '{"id":"'+reqId+'","state":"'+status.toString()+'"}';
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/request",context: ctxt,showLoading: true);
    httpBuilder
        .put()
        .body(body)
        .headers({
      "Content-Type": "application/json",
    })
        .showWarningAlert("Update", "Are you sure to update the ticket status to "+requestState[status]+" ?")
        .showDefaultOnSuccessAlert("Success", "Status changed to "+requestState[status])
        .showDefaultOnFailureAlert("Updating status error")
        .onSuccess((http.Response response) async {
          _getRequests(eventId);
          Navigator.of(ctxt).pop();
    });

    httpBuilder.run();

  }
  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }

}


