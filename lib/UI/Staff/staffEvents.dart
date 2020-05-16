import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'staffEventsDetails.dart';


class StaffEventsPage extends StatefulWidget {
  @override
  _StaffEventsPageState createState() => _StaffEventsPageState();
}

class _StaffEventsPageState extends State<StaffEventsPage> {
  StaffEvents myEvts;

  List<Event> evtsList;

  @override
  void initState() {
    evtsList = new List();
    _getEventsList();
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
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                    child: Text(
                      "Event : " +e.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Row(
                    children :<Widget>[
                      Text(
                        "Location : ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        e.location,
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
                        "Start Date : ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        e.startDate.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ]
                ),
              )

            ],
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

  void _getEventsList() async
  {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String i = pref.getString("id");

     await http.get("https://event-manager-red.herokuapp.com/api/" + "staff/events",
        headers: {"user": i}).then((http.Response response) {
          if(response.statusCode==200)
      setState(() {
        myEvts=staffEventsFromJson(response.body);
        evtsList=myEvts.events;
      });

    });
  }

}


