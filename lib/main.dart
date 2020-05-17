import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/Home/home.dart';
import 'UI/Login/welcome.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        initialData: Container(),
        future: getHomePage(),
        builder: _buider,
      ),
    );
  }

  Future<Widget>  getHomePage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("id")){
      print("there's key");
      return HomePage();
    }
    print("there's NO key");

    return WelcomePage();
  }



  Widget _buider(BuildContext context, AsyncSnapshot<Widget> snapshot) {
    return snapshot.data;
  }
}
