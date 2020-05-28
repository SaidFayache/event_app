import 'package:flutter/material.dart';
import 'package:event_app/API/eventsModel.dart';
import 'package:event_app/Const/colors.dart';
import 'package:event_app/API/plansModel.dart';
import 'package:event_app/API/planRequestModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/Const/strings.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:event_app/Services/sendHtmlRequest.dart';


class PlanDetail extends StatefulWidget {
  final Event event;

  PlanDetail({Key key, this.event}) : super(key: key);
  @override
  _PlanDetailState createState() => _PlanDetailState(e: event);
}

class _PlanDetailState extends State<PlanDetail> {
  _PlanDetailState({this.e});
  Event e;
  Plans plans;
  List<Plan> plansList;
  List<ButtonState> stateTextWithIcon ;


  @override
  void initState() {

    plansList=new List();
    stateTextWithIcon=new List();
    _loadPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: Text("Plans"),

      ),
      body: getBody(),
    );
  }

  Widget getBody(){

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: MediaQuery.of(context).size.height-100,
        child: ListView.builder(
          itemCount: plansList.length,
          itemBuilder: (BuildContext context , int index){
            return getPlanCard(plansList[index],index);

          },
        ),
      ),
    );
  }

  Widget getPlanCard(Plan p,int index)
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 2),
      child: Stack(
        children : <Widget>[
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children : <Widget>[
                      Text("Plan : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                      Text(p.name,style: TextStyle(color: Colors.grey,fontSize: 30),)
                    ],

                    ),
                  ),
                ),
                Container(
                    margin:  EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Text("Description : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                Container(
                  margin:  EdgeInsets.symmetric(horizontal: 5),
                    child: Text(p.description,style: TextStyle(fontSize: 20),)),
                Container(
                    margin:  EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Text("Cost : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                Container(
                    margin:  EdgeInsets.symmetric(horizontal: 5),
                    child: Text(p.cost.toString()+" TND",style: TextStyle(fontSize: 20),)),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
//                    child: GestureDetector(
//                      child: Container(
//                        width: 200,
//                        height: 50,
//                        margin: EdgeInsets.symmetric(vertical: 15),
//                        decoration: BoxDecoration(
//                            shape: BoxShape.rectangle,
//                            borderRadius: BorderRadius.all(Radius.circular(15)),
//                            color: Colors.green
//                        ),
//                        child: Center(
//                          child: Text("Reserve now",style: TextStyle(color: Colors.white,fontSize: 18),),
//                        ),
//
//                      ),
//                      onTap: (){
//                        _sendRequest(p);
//                      },
//                    ),
                  child: buildTextWithIcon(p,index),
                  ),
                ),

              ],

            ),
          ),
//          Positioned(
//            top: 5,
//            right: 10,
//            child: Container(
//              width: 95,
//              height: 100,
//              margin: EdgeInsets.symmetric(vertical: 15),
//              decoration: BoxDecoration(
//                  shape: BoxShape.rectangle,
//                  borderRadius: BorderRadius.all(Radius.circular(15)),
//                  color: c1
//              ),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  Text("Cost : ",style: TextStyle(fontSize: 25,color: Colors.black),),
//                  Text(p.cost.toString()+" TND",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),)
//                ],
//              )
//
//            ),
//          )
        ]
      ),
    );
  }
  Widget buildTextWithIcon(Plan p,int index) {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: "Send Reservation",
          icon: Icon(Icons.send, color: Colors.white),
          color: c1),
      ButtonState.loading:
      IconedButton(text: "Loading", color: Colors.orangeAccent.shade700),
      ButtonState.fail: IconedButton(
          text: "Failed",
          icon: Icon(Icons.cancel, color: Colors.white),
          color: Colors.red.shade300),
      ButtonState.success: IconedButton(
          text: "Success",
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400)
    }, onPressed: (){
      onPressedIconWithText(p,index);
    },
        state: stateTextWithIcon[index]);
  }
  void onPressedIconWithText(Plan p,int index) {
    switch (stateTextWithIcon[index]) {
      case ButtonState.idle:
        stateTextWithIcon[index] = ButtonState.loading;
       _sendRequest(p,index);

        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon[index] = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon[index] = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIcon[index] = stateTextWithIcon[index];
    });
  }

  Widget _getBody1(Plan p,int index) {
    return Container(
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
                _sendRequest(p,index);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _sendRequest(Plan p,int index) async
  {

    Map<String,dynamic> bod =new Map();
    SharedPreferences pref= await SharedPreferences.getInstance();
    String i=pref.getString("id");
    bod["user"]=i;
    bod["event"]=p.event;
    bod["plan"]=p.id;
    PlanReq pl = PlanReq.fromJson(bod);
    String body=planReqToJson(pl);
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/request",context: context,showLoading: true);
    httpBuilder
        .post()
        .body(body)
        .headers({
      "Content-Type": "application/json"
    })
        .showDefaultOnFailureAlert("error")
        .showDefaultOnSuccessAlert("Success", "Reservation sent successfully")
        .showWarningAlert("Reservation", "Do you really wanna Reserve a ticket ? ")
        .onSuccess((http.Response response) async {
      setState(() {
        stateTextWithIcon[index] = ButtonState.success;
      });

    })
    .onFailure((http.Response response) async {
      setState(() {
        stateTextWithIcon[index] = ButtonState.fail;
      });

    });

    httpBuilder.run();

  }

  void _loadPlans() async
  {
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/plan",context: context,showLoading: false);
    httpBuilder
        .get()
        .headers({
      'event': e.id.toString(),
    })
        .onSuccess((http.Response response) async {
          int i;

      setState(() {

        plans = plansFromJson(response.body);
        plansList = plans.plans;
        for(i=0;i<plansList.length;i++)
        {
          stateTextWithIcon.add(ButtonState.idle);
        }
      });

    });

    httpBuilder.run();
  }
}
