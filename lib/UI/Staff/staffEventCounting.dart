import 'package:event_app/API/eventsModel.dart';
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
import 'staffCountingDetails.dart';
import 'package:event_app/Services/sendHtmlRequest.dart';



class EventCountingPage extends StatefulWidget {
  final Event event;
  EventCountingPage({Key key, this.event}) : super(key: key);
  @override
  _EventCountingPageState createState() => _EventCountingPageState(e: event);
}

class _EventCountingPageState extends State<EventCountingPage> {
  List<MyItem> _items = new List();
  _EventCountingPageState({this.e});
  Event e;
  Countings ctgs;
  List<Counting> countingList = new List();
  @override
  void initState() {
    _items=new List();
    countingList=new List();
    _getCountings(e.id);
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

  Widget _getBody()
  {
    return Container(
      child: ListView.builder(
        itemCount: countingList.length,
        itemBuilder: (BuildContext context,int index){
          return _getItemCard(countingList[index]);
        },


      ),
    );
  }
  Widget _getItemCard(Counting c)
  {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(c.name,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "People In : "+c.countIn.toString(),style: TextStyle(fontSize: 18),
                ),

              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "People Out : "+c.countOut.toString(),style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  CountingDetailsPage(counting: c,)),
        );
      },
    );
  }

  Widget _getBody1()
  {
    return ListView(
      children: <Widget>[
        ExpansionPanelList(
          expansionCallback: (int index,bool isExpanded){
            setState(() {
              _items[index].isExpanded=!_items[index].isExpanded;
            });
          },
          children: _items.map((MyItem item){

            return ExpansionPanel(
              headerBuilder: (BuildContext context , bool isExpanded){
                return Container(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(item.counting.name,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "People In : "+item.counting.countIn.toString(),style: TextStyle(fontSize: 18),
                        ),

                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "People Out : "+item.counting.countOut.toString(),style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                );
              },
              isExpanded: item.isExpanded,
              body: _getItemBody(item),
            );
          }).toList(),

        )
      ],
    );

  }

  Widget _getItemBody(MyItem item){
    List<ListInElement> list= item.counting.details.listIn + item.counting.details.listOut;

    double itemHeight = 200;
    return Container(
            height:  itemHeight,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                bool isFirst = index<item.counting.details.listIn.length;
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


    );
  }

  void _getCountings(String eventId) async
  {
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/presence",context: context,showLoading: false);
    httpBuilder
        .get()
        .headers({
      "event": eventId,
    })
        .onSuccess((http.Response response) async {
      setState(() {
        ctgs=countingsFromJson(response.body);
        countingList=ctgs.data;
        for (var c in countingList ){
          _loadCountingDetails(c);
        }
      });

    });

    httpBuilder.run();
  }
  void _loadCountingDetails(Counting item) async
  {
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/presence",context: context,showLoading: false);
    httpBuilder
        .get()
        .headers({
      "id": item.id,
    })
        .onSuccess((http.Response response) async {
      setState(() {
        item.details=countingDetailsFromJson(response.body);
      });

    });

    httpBuilder.run();
  }

}

class MyItem{
  MyItem({this.isExpanded: false,this.counting});
  bool isExpanded;
  Counting counting;
}
