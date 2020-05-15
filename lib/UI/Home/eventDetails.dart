import 'package:flutter/material.dart';
import 'package:event_app/API/eventsModel.dart';
import 'package:event_app/Const/colors.dart';
import 'package:event_app/API/plansModel.dart';
import 'package:http/http.dart' as http;
import 'planDetails.dart';
class EventDetail extends StatefulWidget {
  final Event event;
  EventDetail({Key key, this.event}) : super(key: key);


  @override
  _EventDetailState createState() => _EventDetailState(e: event);
}

class _EventDetailState extends State<EventDetail> {
  _EventDetailState({this.e});
  Event e;
  Plans plans;
  List<Plan> plansList;
  


  @override
  void initState() {
    super.initState();
    plansList=new List();
    _loadPlans();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        body: NestedScrollView(
          scrollDirection: Axis.vertical,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: c1,
                elevation: 6,
                forceElevated: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(),
                    background: Container(
                          decoration: new BoxDecoration(
                              image: DecorationImage(
                                  image:  AssetImage("assets/image1.png"),
                                  fit: BoxFit.cover),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: Container()),
                    ),
              ),
            ];
          },
          body: getBody(),
        )


    );
  }
  Widget getBody() {
    return Container(
      //height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(


              child: Row(children: <Widget>[
                Text(
                  "Title : ",
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.lerp(Colors.white, Colors.black, 0.65)),
                ), Text(
                    e.name,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Color.lerp(Colors.white, Colors.black, 0.65)),
                  ),

              ],)
          ),

          Container(
            margin: EdgeInsets.only(top: 40),
            child: Row(
              children: <Widget>[
                Container( margin: EdgeInsets.only(right: 10) ,child: Icon(Icons.date_range , color: Color.lerp(Colors.indigoAccent, Colors.black, 0.5 , ),size: 30,)),
                Text(
                  "Start : ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  e.startDate.toString(),
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Container(margin: EdgeInsets.only(right: 10) , child: Icon(Icons.check_circle , color: Color.lerp(Colors.indigoAccent, Colors.black, 0.5 , ),size: 30,)),                Text(
                  "End : ",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  e.endDate.toString(),
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ), // Text("End : "+ post.endTime.split("T")[0], style: TextStyle(fontSize: 20 ),),) ,
          Container(
            margin: EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width * 1,
            child: Center(
              child: Card(
                elevation: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Location",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.lightBlue),
                        ),
                        Text(
                          e.location.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.grey),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 3,
                      child: Container(
                        color: Colors.grey,
                        height: 80,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Organizer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.lightBlue),
                        ),
                        Text(
                          e.admin,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                              color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Description",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(e.description , style: TextStyle(fontSize: 20),),
          ),
          _getPlans(),
        ],
      ),
    );
  }
  
  Widget _getPlanCard(Plan p)
  {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        height: 190,
        width: 125,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.green,
          gradient: LinearGradient(colors: [c1,Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight)
        ),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(p.name),
              ),
              Text("Cost : "+p.cost.toString() +"TND")
            ], )),
      ),
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlanDetail(plan: p,)));
      },
    );
  }

  Widget _getPlans()
  {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 270,
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 2,
          offset: Offset(0,2), // changes position of shadow
        ),
      ],

    ),
    child: Column(
//      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
        child: Text("Plans",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
        Container(
          height: 200,
          child: ListView.builder(scrollDirection: Axis.horizontal,

          itemCount: plansList.length,
          itemBuilder: (BuildContext context,int index){
            return _getPlanCard(plansList[index]);
          },
      ),
        ),]
    ),
  );
  }

  void _loadPlans()
  {
    Map<String, String> headers ;
    headers= {
      'event': e.id,

    };
    http.get("https://event-manager-red.herokuapp.com/api/"+"plan",headers:headers).then((http.Response response){

      
      setState(() {
        plans = plansFromJson(response.body);
        plansList = plans.plans;
        

      });
    });
  }
}
