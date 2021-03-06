import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:event_app/API/Event/allTags.dart';
import 'package:event_app/API/Event/eventById.dart';
import 'package:event_app/API/Event/eventCategories.dart';
import 'package:event_app/API/Event/searchsuggestions.dart';
import 'package:event_app/Services/sendHtmlRequest.dart';
import 'package:event_app/UI/Login/welcome.dart';
import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:http/http.dart' as http;
import 'package:event_app/API/eventsModel.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'eventDetails.dart';
import 'package:event_app/UI/MyRequests/requests.dart';
import 'package:event_app/UI/Staff/staffEvents.dart';
import 'package:event_app/UI/MyQR/myQR.dart';
import 'package:event_app/Const/strings.dart';

import 'listOfEvents.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Events events;
  List<Event> eventsList;
  List<Event> homeScreenList;
  double cardwidth ;
  double squareItemSize = 200 ;
  List<TagItem> tags = new List();
  List<Suggestion> suggestions = new List();
  List<EventCategoryItem> eventCat = new List();
  Suggestion selected ;
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<Suggestion>>();
  Widget searchbar ;
  final m = new DateFormat('MMM');


  void initState()
  {


    eventsList=new List();
    events=new Events();
    homeScreenList=new List();
    _loadEvents();
    _loadTags();
    _loadCategories();

  }
  bool isSearching=false;

  @override
  Widget build(BuildContext context) {
    cardwidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      drawer: _getDrawer(),

      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: c1,
        title: Text('Home') ,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.blur_linear),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  MyQrPage()),
              );
            },
          )
        ],

      ),
      body: NestedScrollView(
        scrollDirection: Axis.vertical,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: Container(),
              backgroundColor: c1,
              elevation: 6,
              forceElevated: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              expandedHeight: 300.0,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                    decoration: new BoxDecoration(

                        borderRadius: new BorderRadius.all(
                            new Radius.circular(20.0))),
                    child: Container(child:
                      Stack(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                              child: Text("Find amazing events Happening around you",style: TextStyle(fontSize: 50 , fontWeight: FontWeight.w600,color: Colors.white),),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 20,
                            right: 20,
                            child:Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10
                              ),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(20.0))),
                              child: searchbar
                            ) ,
                          ),
                        ],
                      ),)),
              ),
            ),
          ];
        },
        body: _getBody(),
      ),
    );
  }
  Widget _getBody()
  {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getTitle("Comming Events ..."),
            Container(
                height: cardwidth/1.5,
                child: _buildLastEvents()),
            _getTitle("Tags ..."),
            Container(child: _getTags(),),
            SizedBox(height: 100,),
            Container(
              color: Color.lerp(Colors.black, Colors.blue, 0.1),
              child: Column(
                children: _getCategoriesWidget(),
              ),
            )
          ],
        ),

      ),
    );
  }

  _loadTags(){

    HttpBuilder httpBuilder = new HttpBuilder(url: "api/tags",context: context,showLoading: false);
    httpBuilder
        .getWithCache()
        .onSuccess((http.Response response) async {

      tags = tagsListFromJson(response.body).data ;
      tags.removeWhere((tag)=> tag.count==0);
      _loadSuggestion();
      setState(() {

      });
    });

    httpBuilder.run();

  }

  _loadSuggestion(){
    HttpBuilder httpBuilder = new HttpBuilder(url: "api/search",context: context,showLoading: false);
    httpBuilder
        .getWithCache()
        .headers({
      "number_tags" : "4" ,
      "number_events" : "4"
    })
        .onSuccess((http.Response response) async {

      suggestions = searchSuggestionsFromJson(response.body).data ;
      setState(() {
        searchbar = _getSearchBar() ;
      });

    });

    httpBuilder.run();

  }

  _loadCategories(){

    HttpBuilder httpBuilder = new HttpBuilder(url: "api/events/categories",context: context,showLoading: false);
    httpBuilder
        .getWithCache()
        .headers({
      "number_tags" : "4" ,
      "number_events" : "4"
    })
        .onSuccess((http.Response response) async {

      eventCat = eventCategoriesFromJson(response.body).data ;
      setState(() {

      });

    });

    httpBuilder.run();

  }


  Widget _buildLastEvents(){
    return Container(

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: homeScreenList.length+1,
        itemBuilder: (BuildContext context, int index){
          if(index==homeScreenList.length) return GestureDetector(
            child: Card(
              margin: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Container(
                child: Container( width: cardwidth, child: Center(child: Text("Load more events",style: TextStyle(fontSize: 30),))),),
            ),
            onTap: (){
              _getMoreLasts();
            },
          );
          return _getCard(homeScreenList[index]);

        },),


    );
  }

  Widget _getSearchBar(){
    return AutoCompleteTextField<Suggestion>(
      minLength: 3,
      key : key,
      decoration: new InputDecoration(
          hintText: "Search Event:", suffixIcon: new Icon(Icons.search,color: c1,)),
      itemSubmitted: (item) {
        _goToEventBySuggestion(item);
      },
      suggestions: suggestions,

      itemBuilder: (context, suggestion)=> new Padding(

            child: new ListTile(
                title: new Text(suggestion.name),
                trailing: Text(suggestion.start.day.toString()+" "+m.format(suggestion.start))),
            padding: EdgeInsets.all(8.0)),
      itemSorter: (a, b) => a.name.compareTo(b.name),
      itemFilter: (suggestion, input) => suggestion.name.toLowerCase().contains(input.toLowerCase())

    );
  }

  Widget _getTitle(String str){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(str,style: TextStyle(fontSize: 30 , fontWeight: FontWeight.w300),textAlign: TextAlign.start,),
    );
  }

  Widget _getTags(){

    double _fontSize = 22.0 ;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical :10.0 , horizontal:MediaQuery.of(context).size.width*0.05 ),
      child: Center(
        child: Tags(

          itemCount: tags.length, // required
          itemBuilder: (int index){
            final item = tags[index];

            return ItemTags(
              // Each ItemTags must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(index.toString()),
              index: index, // required
              title: item.name+" (${item.count})",
              customData: item.id,
              icon: ItemTagsIcon(icon: MdiIcons.fromString(item.name)),
              textStyle: TextStyle( fontSize: _fontSize, ),
              combine: ItemTagsCombine.withTextAfter,
              onPressed: (item) {
                _getEventsByTag(item.customData,item.title);
              },
              onLongPressed: (item) => print(item),
              color: Colors.deepOrange,
              activeColor: Colors.deepOrange,
              textColor: Colors.white,
            );

          },
        ),
      ),
    );
  }

  Widget _getCard(Event e)
  {
    double ration =2;
    double cardHeight = cardwidth /ration;
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Container(
          height: cardHeight/ration,
          width: cardwidth,

          child: Stack(
            children: <Widget>[
              Hero(
                tag: "Image"+e.id,
                child: Container(
                  height: cardHeight,

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

                  height: cardHeight*.5,
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
            context, MaterialPageRoute(builder: (context) => EventDetail(event: e,hero: "",)));
      },
    );
  }

  Widget _getCategoryCard(Event e,String tag)
  {

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Container(
          height: squareItemSize,
          width: squareItemSize,

          child: Stack(
            children: <Widget>[
              Hero(
                tag: "Image"+e.id+tag,
                child: Container(
                  height: squareItemSize,

                  decoration: BoxDecoration(
                      image: DecorationImage(image: Image(
                        image: AdvancedNetworkImage(
                          e.imageLink,
                          useDiskCache: true,
                          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                        ),
                        fit: BoxFit.cover,
                      ).image ,fit: BoxFit.cover, ),
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

                  height: squareItemSize*.5,
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
                    ],
                  ),

                ),
              ),


            ],

          ),

        ),
      ),
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventDetail(event: e,hero :tag)));
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


  void _loadEvents() async {


    HttpBuilder httpBuilder = new HttpBuilder(url: "api/events/lasts",context: context,showLoading: false);
    httpBuilder
        .getWithCache()
        .headers({
      "count":5.toString()
    })
        .onSuccess((http.Response response) async {

      print(response.body) ;
      setState(() {
        events= eventsFromJson(response.body);
        eventsList=events.data;
        print(eventsList[0].name);
        homeScreenList=events.data;
      });

    });

    httpBuilder.run();

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

            child: Column(
              children: <Widget>[
                Text("User Name"),
                RaisedButton(child: Text("Logout"),onPressed: _logout,)
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          ListTile(
            title: Text('My Tickets'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  RequestPage()),
              );
            },
          ),
          ListTile(

            title: Text('Staff'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  StaffEventsPage()),
              );
            },
          ),
          ListTile(

            title: Text('My QR Code'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  MyQrPage()),
              );
            },
          ),


        ],
      ),

    );
  }


  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    Route route = MaterialPageRoute(builder: (context) => WelcomePage());
    Navigator.pushReplacement(context, route);

  }

  List<Widget> _getCategoriesWidget() {
List<Widget> list = new List();
list.add(
  Padding(
    padding: const EdgeInsets.all(30.0),
    child: Text("Descover More Events ...",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white, fontSize: 40),textAlign: TextAlign.center,),
  )
);

for (int index = 0  ;index<eventCat.length;index++){
  list.add(
      Container(

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical :8.0,horizontal: 20),
          child: Text(eventCat[index].tag.name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25),),
        ) ,
        Container(
          width: MediaQuery.of(context).size.width,
          height: squareItemSize,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: eventCat[index].events.length+1,
              itemBuilder: (BuildContext context , int i) {
                if(i ==eventCat[index].events.length){
                  return GestureDetector(
                    onTap: (){
                      _getEventsByTag(eventCat[index].tag.id, eventCat[index].tag.name);
                    },
                    child: Card(
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Container(
                        child: Container( width: squareItemSize, child: Center(child: Text("Load more events",style: TextStyle(fontSize: 20),))),),
                    ),
                  );
                }
                return Container(
                  child: _getCategoryCard(eventCat[index].events[i],eventCat[index].tag.name),);
              }),
        )
      ],
    ),));
}
return list ;
  }

  void _goToEventBySuggestion(Suggestion item) {
    http.get(baseUrl+"api/events/${item.id}").then((http.Response res){
      if(res.statusCode==200){
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventDetail(event: eventByIdFromJson(res.body).data,hero : "Suggestion")));

      }
    });
  }

  void showListofEvents(String title , http.Response resp){

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListOfEvents(title,resp)));

    }

  _getEventsByTag(String tagId,String tag){

    HttpBuilder httpBuilder = new HttpBuilder(url: "api/events/tag?tag="+tagId,context: context,showLoading: false);
    httpBuilder
        .getWithCache()
        .headers({
      "tag":tagId
    })
        .onSuccess((http.Response response) async {

      showListofEvents("Tag :"+tag, response);

    });

    httpBuilder.run();

  }

  void _getMoreLasts() {

    HttpBuilder httpBuilder = new HttpBuilder(url: "api/events/lasts",context: context,showLoading: false);
    httpBuilder
        .getWithCache()
        .headers({
      "count":"0"
    })
        .onSuccess((http.Response response) async {

      showListofEvents("Lasts", response);

    });

    httpBuilder.run();

  }


}


