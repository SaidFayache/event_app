import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'staffEventsDetails.dart';
import 'package:event_app/Const/strings.dart';



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
          child: Row(
            children: <Widget>[
              Container(height: 80,width: 5,color: Colors.deepOrange,),
              SizedBox(width: 30,),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                    child: Text(
                      e.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )),
              ),


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

     await http.get(baseUrl + "api/staff/events",
        headers: {"user": i}).then((http.Response response) {
          if(response.statusCode==200)
      setState(() {
        myEvts=staffEventsFromJson(response.body);
        evtsList=myEvts.events;
      });

    });
  }

}


