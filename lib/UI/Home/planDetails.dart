import 'package:flutter/material.dart';
import 'package:event_app/API/eventsModel.dart';
import 'package:event_app/Const/colors.dart';
import 'package:event_app/API/plansModel.dart';
import 'package:event_app/API/planRequestModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlanDetail extends StatefulWidget {
  final Plan plan;
  PlanDetail({Key key, this.plan}) : super(key: key);
  @override
  _PlanDetailState createState() => _PlanDetailState(p: plan);
}

class _PlanDetailState extends State<PlanDetail> {
  _PlanDetailState({this.p});
  Plan p;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: Text("Plan Details"),

      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text("Description :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text(p.description,style: TextStyle(fontSize: 15),),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text("Cost :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Text(p.cost.toString()+"TND",style: TextStyle(fontSize: 15)),
            ),
            Center(
              child: GestureDetector(
                child: Container(
                  width: 200,
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.green
                  ),
                  child: Center(
                    child: Text("Reserve",style: TextStyle(color: Colors.white,fontSize: 18),),
                  ),

                ),
                onTap: (){
                  _sendRequest(p);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendRequest(Plan p) async
  {
    Map<String,dynamic> bod =new Map();


    SharedPreferences pref= await SharedPreferences.getInstance();
    String i=pref.getString("id");
    bod["user"]=i;
    bod["event"]=p.event;
    bod["plan"]=p.id;
    PlanReq pl = PlanReq.fromJson(bod);
    String body=planReqToJson(pl);
    http.post("https://event-manager-red.herokuapp.com/api/"+"/event/request",body: body,headers: {
      "Content-Type": "application/json"
    }).then((http.Response response){
      print(response.body);

    });


  }
}
