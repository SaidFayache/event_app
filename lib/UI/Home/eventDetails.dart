import 'package:event_app/API/TimeLine/timeline.dart';
import 'package:event_app/Const/strings.dart';
import 'package:flutter/material.dart';
import 'package:event_app/API/eventsModel.dart';
import 'package:event_app/Const/colors.dart';
import 'package:event_app/API/plansModel.dart';
import 'package:event_app/API/socialLinksModel.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:http/http.dart' as http;
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'planDetails.dart';
import 'package:event_app/UI/MyRequests/requests.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:event_app/Services/sendHtmlRequest.dart';

class EventDetail extends StatefulWidget {
  final Event event;
  final String hero ;
  EventDetail({Key key, this.event,this.hero}) : super(key: key);


  @override
  _EventDetailState createState() => _EventDetailState(e: event , hero : hero);
}

class _EventDetailState extends State<EventDetail> {
  _EventDetailState({this.e,this.hero});
  Event e;
  List<SocialMediaLink>linksList;
  String hero ;
  Plans plans;
  List<Timeslot> timeslots = new List();
  final m = new DateFormat('MMMEd');
  final d = new DateFormat('jm');

  @override
  void initState() {
    super.initState();
    linksList=List();
    _loadLinks();
    _loadTimeSlots();
  }
  

  @override
  Widget build(BuildContext context) {


    print("id : "+e.id);
    print("hero : "+hero);
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
                    title: Container(
                    ),
                    background: Hero(
                      tag: "Image"+e.id+hero,
                      child: Container(
                            decoration: new BoxDecoration(
                                image: DecorationImage(
                                    image:  Image(
                                      image: AdvancedNetworkImage(
                                        e.imageLink,
                                        useDiskCache: true,
                                        cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                                      ),
                                      fit: BoxFit.cover,
                                    ).image,
                                    fit: BoxFit.cover),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20.0))),
                            child: Container()),
                    ),
                    ),
              ),
            ];
          },
          body: getBody(),
        )


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
                Text(m.format(dateTime), style: TextStyle(color: Colors.blue,fontSize: 40),),
                Text(dateTime.day.toString() , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey , fontSize: 55),),
              ],
            ),),
          )
      ),
    );

  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          //height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40,),
              Row(
                children: <Widget>[
                  _getDate(e.startDate),
                  SizedBox(width: 20,),
                  Container(


                      child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          Text(
                             e.name,
                             style: TextStyle(
                                 fontSize: 45,
                                 fontWeight: FontWeight.bold,
                                 color: Color.lerp(Colors.white, Colors.black, 0.65)),
                           ),
                          SizedBox(height: 15,),
                          Text(
                            "Hosted by "+e.admin,
                            style: TextStyle(

                                fontSize: 19,
                                color: Colors.grey),
                          )
                        ],
                      )
                  ),
                ],
              ),

              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Container( margin: EdgeInsets.only(right: 10) ,child: Icon(Icons.date_range , color: Color.lerp(Colors.indigoAccent, Colors.black, 0.5 , ),size: 30,)),
                    Text(
                      "Start : ",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      m.format(e.startDate) +" at "+ d.format(e.startDate),
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
                      m.format(e.endDate)+" at "+ d.format(e.endDate),
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ), // Text("End : "+ post.endTime.split("T")[0], style: TextStyle(fontSize: 20 ),),) ,
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(right: 10) , child: Icon(Icons.location_on , color: Color.lerp(Colors.indigoAccent, Colors.black, 0.5 , ),size: 30,)),                Text(
                      "",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      e.location,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ), // Text("End : "+ post.endTime.split("T")[0], style: TextStyle(fontSize: 20 ),),) ,
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
              //_getPlans(),
              _buyButton(),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "TimeLine",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              _getTimeLine(),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "Social Media links",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              _getRedirectingGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buyButton (){
    return GestureDetector(
      child: Center(
        child: Container(
          width: 200,
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: c1
          ),
          child: Center(
            child: Text("Buy a Ticket",style: TextStyle(color: Colors.white,fontSize: 18),),
          ),

        ),
      ),
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlanDetail(event: e,))
        );
      },
    );


  }
  
  Widget _getRedirectingGrid()
  {
    return Container(
      height: 300,
      child: GridView.count(crossAxisCount: 3,
      children: List.generate(linksList.length, (index){
        return Container(
          height: 100,
          child: GestureDetector(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Icon(MdiIcons.fromString(linksList[index].website),size: 50,)
                  ,SizedBox(height: 5,),
                  Text(linksList[index].title,style: TextStyle(color: Colors.grey),)

                ],
              ),
            ),
            onTap: (){

              _launchURL(linksList[index].link);
            },
          )
        );

      }),),
    );
  }
  



  _loadTimeSlots() async {

    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/timeslot",context: context,showLoading: false);
    httpBuilder
        .get()
        .headers({
      "event":e.id,
    })
        .onSuccess((http.Response response){
      timeslots =  timeSlotsFromJson(response.body).timeslots;
      timeslots.sort((Timeslot a, Timeslot b) => a.startDate.compareTo(b.startDate) );
      setState(() {

      });
    });

    httpBuilder.run();

  }

  Widget _getTimeLine(){
    double width = 300 ;

    List<TimelineModel> temp = new List();


    int day = 0;
    int month =0 ;

    if(timeslots.isNotEmpty) timeslots.forEach((t){

      if(t.startDate.day!=day||t.startDate.month!=month){

        day = t.startDate.day ;
        month = t.startDate.month ;
        temp.add(
            (TimelineModel(Card(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.blue, Colors.blueGrey])),
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(m.format(t.startDate) , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold ,color: Colors.white),),
                  )

              ),
            ),
                position: TimelineItemPosition.left,
                iconBackground: Colors.blue,
                icon: Icon(Icons.stars))
            ));
      }
      temp.add(TimelineModel(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: width,
            child: Column(
              children: <Widget>[
                Text(t.title , style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold),),
                Text(t.location , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                Text(d.format(t.startDate) +" to " +d.format(t.endDate), style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
      ),
          position: TimelineItemPosition.right,
          iconBackground: Colors.purpleAccent,
          icon: Icon(Icons.blur_circular)));
    });

    return Timeline(children: temp, position: TimelinePosition.Center ,shrinkWrap: true,);


  }
  _launchURL(String url) async {

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _loadLinks() async
  {
    SocialLinks s;

    HttpBuilder httpBuilder = new HttpBuilder(url: "api/event/sociallinks",context: context,showLoading: false);
    httpBuilder
        .get()
        .headers({
      "event":e.id,
        })
        .onSuccess((http.Response response){
      s=socialLinksFromJson(response.body);
      setState(() {
        linksList=s.socialMediaLinks;
      });
    });

    httpBuilder.run();

  }


}
