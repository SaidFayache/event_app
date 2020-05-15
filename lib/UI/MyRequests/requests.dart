import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:event_app/API/myRequestsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  MyRequests myReqs;
  List<RequestElement> reqList=new List();

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
            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: GestureDetector(
                  child: Container(
                    height: 50,
                    width: 200,
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
                          Text(" Delete Request",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),)
                        ],
                      ),
                    ),
                  ),
                  onTap: (){
                    _deleteReq(req);
                  },
                ),

              ),
            )
          ],
        ),
      ),
    );
  }

  void getRequests() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString("id");

    http.get("https://event-manager-red.herokuapp.com/api/" + "user/request",
        headers: {"user": i}).then((http.Response response) {
      setState(() {
        myReqs = myRequestsFromJson(response.body);
        reqList = myReqs.requests;
      });
    });
  }
  void _deleteReq(RequestElement r)  {

    http.delete("https://event-manager-red.herokuapp.com/api" + "/event/request",
        headers: {"id": r.request.id}).then((http.Response response) {
          print("deleted "+r.request.id);
          print(response.body);
          setState(() {
            reqList.remove(r);
          });

    });
  }
}
