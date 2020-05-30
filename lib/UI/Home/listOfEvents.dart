import 'package:event_app/Const/strings.dart';
import 'package:event_app/UI/Home/eventDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../API/eventsModel.dart';


class ListOfEvents extends StatefulWidget {

  String title ;
  http.Response resp ;

  ListOfEvents(this.title, this.resp);

  @override
  _ListOfEventsState createState() => _ListOfEventsState(this.title, this.resp);
}

class _ListOfEventsState extends State<ListOfEvents> {

  String title ;
  http.Response resp ;
  List<Event> events = new List() ;

  _ListOfEventsState(this.title, this.resp);

  @override
  void initState() {

      events=  eventsFromJson(resp.body).data;


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: _getBody(),
    );
  }





  Widget _getBody()
  {
    return Container(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index){
          return _getCard(events[index]);

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
              Hero(
                tag: "Image"+e.id+"ListItem",
                child: Container(
                  height: card_height,

                  decoration: BoxDecoration(
                      image: DecorationImage(image: Image(
                        image: AdvancedNetworkImage(
                          e.imageLink,
                          useDiskCache: true,
                          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                        ),
                        fit: BoxFit.cover,
                      ).image ,fit: BoxFit.fitWidth, ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all( Radius.circular(8.0))

                  ),
                  child: Container(),),
              ),
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
            context, MaterialPageRoute(builder: (context) => EventDetail(event: e,hero: "ListItem",)));
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

}
