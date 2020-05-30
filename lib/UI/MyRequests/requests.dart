import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:event_app/API/myRequestsModel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:ticket_pass_package/ticket_pass.dart';
import 'package:intl/intl.dart';
import 'package:event_app/Const/strings.dart';
import 'package:event_app/Services/sendHtmlRequest.dart';


class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  Uint8List bytes = Uint8List(200);
  MyRequests myReqs;
  List<RequestElement> reqList=new List();

  List<String> status = ["Unproved","Unpaid","Accepted","Refused"];

  final date = new DateFormat('MMMEd');
  final time = new DateFormat('jm');

  @override
  void initState() {
    reqList = new List();
    super.initState();

    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
        backgroundColor: c1,
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Container(
      child: ListView.builder(
        itemCount: reqList.length,
        itemBuilder: (BuildContext context, int index) {
          return getCard(reqList[index]);
        },
      ),
    );
  }

  Widget getCard(RequestElement req) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: getTicket(req),
    );

  }

  void getRequests() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString("id");
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/user/request",context: context,showLoading: false);
    httpBuilder
        .getWithCache()
        .headers({
      "user": i,
    })
        .onSuccess((http.Response response) async {
      setState(() {
        myReqs = myRequestsFromJson(response.body);
        reqList = myReqs.requests;
      });

    });

    httpBuilder.run();

  }
  void _deleteReq(RequestElement r)  async{
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/request",context: context,showLoading: true);
    httpBuilder
        .delete()
        .headers({
      "id": r.request.id,
    })
        .showDefaultOnFailureAlert("error")
        .showDefaultOnSuccessAlert("Success", "Request "+r.request.id+" deleted successfully")
        .showWarningAlert("Delete", "Do you really wanna delete the request ? ")
        .onSuccess((http.Response response) async {
      print("deleted "+r.request.id);
      setState(() {
        reqList.remove(r);
      });

    });

    httpBuilder.run();

  }

  Future<void> _createPopUpQr(BuildContext context)
  {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Your generated Code"),
          content: SizedBox(
            width: 200,
            height: 200,
            child: Image.memory(bytes),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },

    );

  }

  Widget getTicket(RequestElement req){
    return TicketPass(
      alignment: Alignment.center,
      animationDuration: Duration(seconds: 2),
      expansionChild: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Ticket Status : "+status[req.request.state] , style: TextStyle(fontSize: 20),),
                  RaisedButton.icon( onPressed:req.request.state!=0?null:(){
                    _deleteReq(req);
                  }, icon: Icon(Icons.delete,color: Colors.white,), label: Text("delete",style: TextStyle(color: Colors.white),)  , color: Colors.redAccent,)
                ],
              ),
            ),
            QrImage(
              data: req.request.id,
              version: QrVersions.auto,
              size: 250.0,
            ),
          ],
        ),
        height: 350,
      ),
      expandedHeight: 600,
      expandIcon: CircleAvatar(
        maxRadius: 14,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 20,
        ),
      ),
      expansionTitle: Text(
        'More Details',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
      separatorColor: Colors.black,
      separatorHeight: 2.0,
      color: Colors.white,
      curve: Curves.easeOut,
      titleColor: Colors.blue,
      shrinkIcon: CircleAvatar(
        maxRadius: 14,
        child: Icon(
          Icons.keyboard_arrow_up,
          color: Colors.white,
          size: 20,
        ),
      ),
      ticketTitle: Text(
        'QR Code',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      titleHeight: 50,
      width: 300,
      height: 200,
      shadowColor: Colors.blue.withOpacity(0.5),
      elevation: 8,
      shouldExpand: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 5),
        child: Container(
          height: 140,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Event',
                                style: TextStyle(color: Colors.black.withOpacity(0.5)),
                              ),
                              Text(
                                req.event.name,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: <Widget>[
                              Text(
                                'Plan',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                req.plan.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Text(
                              'Date',
                              style: TextStyle(color: Colors.black.withOpacity(0.5)),
                            ),
                            Text(
                              date.format(req.event.startDate),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Text(
                              'PRICE',
                              style: TextStyle(color: Colors.black.withOpacity(0.5)),
                            ),
                            Text(
                              '${req.plan.cost} TND',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }


}
