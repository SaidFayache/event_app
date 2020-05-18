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


class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  Uint8List bytes = Uint8List(200);
  MyRequests myReqs;
  List<RequestElement> reqList=new List();

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
    return Container(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                  child: Text(
                "Event : " + req.event.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Row(
                    children :<Widget>[
                      Text(
                      "Plan : ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                      Text(
                        req.plan.name,
                        style: TextStyle( fontSize: 20),
                      ),
                    ]
                  ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Row(
                  children :<Widget>[
                    Text(
                      "Price : ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      req.plan.cost.toString()+" TND",
                      style: TextStyle(fontSize: 20),
                    ),
                  ]
              ),
            ),Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Row(
                  children :<Widget>[
                    Text(
                      "Request Status : ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      req.request.state.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Container(
                margin: EdgeInsets.all(10),
                child: GestureDetector(
                  child: Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.delete,color: Colors.white,),
                          Text("Delete Request ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    _deleteReq(req);
                  },
                ),
              ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: c1,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.comment,color: Colors.white,),
                            Text(" Ticket Code",style: TextStyle(color: Colors.white,fontSize: 18),)
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      _generateBarCode(req.request.id);
                      _createPopUpQr(context);

                    },
                  ),
                ),
                ]
            )
          ],
        ),
      ),
    );
  }

  void getRequests() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString("id");
    String token = await pref.getString("token");

    http.get(baseUrl + "api/user/request",
        headers: {"user": i,
          "x-access-token":token}).then((http.Response response) {
      setState(() {
        myReqs = myRequestsFromJson(response.body);
        reqList = myReqs.requests;
      });
    });
  }
  void _deleteReq(RequestElement r)  async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("token");

    http.delete(baseUrl + "api/event/request",
        headers: {"id": r.request.id,
          "x-access-token":token}).then((http.Response response) {
          print("deleted "+r.request.id);
          print(response.body);
          setState(() {
            reqList.remove(r);
          });

    });
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
        child: QrImage(
          data: "1234567890",
          version: QrVersions.auto,
          size: 250.0,
        ),
        height: 270,
      ),
      expandedHeight: 500,
      expandIcon: CircleAvatar(
        maxRadius: 14,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 20,
        ),
      ),
      expansionTitle: Text(
        'QR CODE',
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

  Future _generateBarCode(String id) async {

    Uint8List result = await scanner.generateBarCode(id);
    this.setState(() => this.bytes = result);
  }
}
