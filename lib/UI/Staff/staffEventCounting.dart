import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_app/API/staffEventsModel.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:event_app/API/eventCountingsModel.dart';


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

  void _getCountings(String eventId)
  {
    http.get("https://event-manager-red.herokuapp.com/api/" + "/event/presence",
        headers: {"event": eventId}).then((http.Response response) {
      print(response.body);
      setState(() {
        ctgs=countingsFromJson(response.body);
        countingList=ctgs.data;
        for (var c in countingList ){
          MyItem item= MyItem(counting: c);
          _loadCountingDetails(item);
          _items.add(item);


        }
      });
    });
  }
  void _loadCountingDetails(MyItem item)
  {
    http.get("https://event-manager-red.herokuapp.com/api/" + "/presence",
        headers: {"id": item.counting.id}).then((http.Response response) {
      print(response.body);
      setState(() {
        item.counting.details=countingDetailsFromJson(response.body);
      });
    });
  }

}

class MyItem{
  MyItem({this.isExpanded: false,this.counting});
  bool isExpanded;
  Counting counting;
}
