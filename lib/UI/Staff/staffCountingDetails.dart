import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:event_app/API/eventCountingsModel.dart';
import 'package:event_app/Const/strings.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class CountingDetailsPage extends StatefulWidget {
  final Counting counting;
  CountingDetailsPage({Key key, this.counting}) : super(key: key);
  @override
  _CountingDetailsPageState createState() => _CountingDetailsPageState(c: counting);
}

class _CountingDetailsPageState extends State<CountingDetailsPage> {
  _CountingDetailsPageState({this.c});
  Counting c;
  String barcode = '';
  @override
  void initState() {
    _loadCounting();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Counting Details"),
        backgroundColor: c1,
      ),
      body: _getBody(),
    );
  }

  Widget _getBody(){
    List<ListInElement> list= c.details.listIn + c.details.listOut;
      return Container(
        child: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                bool isFirst = index<c.details.listIn.length;
                return Container(child:
                Card(child: Row(
                  children: <Widget>[
                    Container(height: 50.0,width: 4,color: isFirst? Colors.green:Colors.deepOrange,),
                    SizedBox(width: 20,),
                    Text(list[index].name),
                  ],
                ),),);
              },
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top:20),
                padding: EdgeInsets.all(15),
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: c1,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Center(
                  child: Text("Add User Presence"),

                ),
              ),
              onTap:() async {
                _scan().then((val){
                  if(barcode !='')
                  {
                    print("barcode found :"+barcode);
                    _createPopUp(context,barcode);
                  }
                });
              } ,
            )
          ],
        ),
      );

  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);

  }

  Future<void> _createPopUp(BuildContext context,String code)
  {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("User Details"),
          content: Container(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(5),
                    child: Text("User's id : "+code)
                ),

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
              child: Text("Submit presence"),
              onPressed: (){
                _addPresence(code);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },

    );
  }

  void _addPresence(String userId) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("token");
    String body='{"event_counting" :"'+c.id+'","user":"'+userId+'"}';
    http.post(baseUrl + "api/event/presence/user",
        headers: {
          "Content-Type": "application/json",
          "x-access-token":token},body:body ).then((http.Response response) {
            print(body);
            print(userId);
            print(c.id);
            print(response.body);
      _loadCounting();
    });

  }
  void _loadCounting() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString("token");
    http.get(baseUrl + "api/presence",
        headers: {"id": c.id,
          "x-access-token":token}).then((http.Response response) {
      //print(response.body);
      setState(() {
        c.details=countingDetailsFromJson(response.body);
      });
    });
  }
}
