import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:event_app/API/eventsModel.dart';
import 'eventDetails.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Events events;
  List<Event> eventsList;
  List<Event> homeScreenList;

  void initState()
  {
    eventsList=new List();
    events=new Events();
    homeScreenList=new List();
    _getEvents();

  }
  bool isSearching=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _getDrawer(),
      appBar: AppBar(
        backgroundColor: c1,
        title: isSearching? TextField(
          decoration: InputDecoration(hintText: "Search an event here",
            fillColor: Colors.white,focusColor: Colors.white,),
          cursorColor: Colors.white,
          onChanged: (String txt){
            print(txt);
            if(txt!="")
              {
                homeScreenList=eventsList.where((event)=> event.name.toLowerCase().contains(txt.toLowerCase())).toList();
                setState(() {

                });
              }
            else
              homeScreenList=eventsList;
              setState(() {

              });



          },
        ):Text('Home'),
        actions: <Widget>[
          IconButton(
          icon: Icon(Icons.search),
            onPressed: (){
            setState(() {
              isSearching= !isSearching;
            });
            },
      )
        ],

      ),
      body: _getBody(),
    );
  }
  Widget _getBody()
  {
    return Container(
      child: ListView.builder(
        itemCount: homeScreenList.length,
      itemBuilder: (BuildContext context, int index){
        return _getCard(homeScreenList[index]);

    },),
      
    );
  }
  Widget _getCard(Event e)
  {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
        child: Container(
          height: 210,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,

              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/image1.png") ,fit: BoxFit.fitWidth, ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40))

              ),
              child: Container(),),
              Center(child: Text(e.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
              Container(
                padding: EdgeInsets.only(top:5,left: 5,bottom: 5),
                  child: Text("Starting Date : "+e.startDate.toString())),
              Container(padding: EdgeInsets.only(left: 5,bottom: 5),
                  child: Text("Ending Date : "+e.endDate.toString())),
              Container(padding: EdgeInsets.only(left: 5,bottom: 5),
                  child: Text("Location : "+e.location.toString())),
            ],

          ),

        ),
      ),
      onTap:(){
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => EventDetail(event: e,)));
        },
    );
  }

  void _getEvents()
  {
    http.get("https://event-manager-red.herokuapp.com/api/"+"events").then((http.Response response){

      print(response.body) ;
      setState(() {
        events= eventsFromJson(response.body);
        eventsList=events.data;
        print(eventsList[0].name);
        homeScreenList=events.data;
      });
    });
  }

 Widget _getDrawer(){
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Your Tickets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  YourPage()), //TODO change this
              );
            },
          ),
          ListTile(
            title: Text('Staff'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  YourPage()), //TODO change this
              );
            },
          ),
        ],
      ),
    );
  }

}
