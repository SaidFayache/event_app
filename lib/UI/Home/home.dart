import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:event_app/API/eventsModel.dart';
import 'package:intl/intl.dart';
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

    double card_height = 220.0 ;
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
        child: Container(
          height: card_height,

          child: Stack(
            children: <Widget>[
              Container(
                height: card_height,

                decoration: BoxDecoration(
                    image: DecorationImage(image: Image.network("https://event-manager-red.herokuapp.com/"+"api/event/image?event="+e.id+"&rand="+DateTime.now().millisecondsSinceEpoch.toString()).image ,fit: BoxFit.fitWidth, ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all( Radius.circular(8.0))

                ),
                child: Container(),),
              //Center(child: Text(e.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
              Positioned(
                bottom: 0.0,
                left: 0,
                right: 0,
                child: Container(

                  height: card_height*.5,
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(8.0)),
                      gradient: LinearGradient(
                          begin: Alignment(0.0, 2.0),
                          end: Alignment(0.0, -2.0)
                          , stops: [
                        0.1,
                        0.6,
                        0.8,

                      ], colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(.6),
                        Colors.black.withOpacity(.0)
                      ])),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top:5,left: 5,bottom: 5),
                          child: Text(e.name , style: TextStyle(fontSize: 25 , color: Colors.white , fontWeight: FontWeight.bold),)),
                      Container(padding: EdgeInsets.only(left: 5,bottom: 5),
                          child: Text("Location : "+e.location.toString(), style: TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold))),
                    ],
                  ),

                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: _getDate(e.startDate),
              )

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


  Widget _getDate(DateTime dateTime){
    final m = new DateFormat('MMM');
    return Container(
      child: Card(
          child :  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(dateTime.day.toString() , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue , fontSize: 25),),
                Text(m.format(dateTime), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
              ],
            ),),
          )
      ),
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
          /*
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
          */

        ],
      ),
    );
  }

}
