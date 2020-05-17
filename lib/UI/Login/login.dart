import 'package:event_app/API/login/loginResponse.dart';
import 'package:flutter/material.dart';
import 'package:event_app/Const/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_app/UI/Signup/signup.dart';
import 'package:toast/toast.dart';
import 'Widgets/bezierContainer.dart';
import 'package:event_app/API/userModel.dart';
import 'package:event_app/API/loginModel.dart';
import 'package:event_app/UI/Home/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:event_app/Const/strings.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  Map<String,String> body;
  User user;
  String error;

  @override
  void initState(){

    body=new Map();
    user= new User();

  }
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,String key, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
              onChanged: (String data) {
                setState(() {
                  body[key]=data;
                });

              }
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [c1, c2])),
        child: InkWell(
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
//          onTap: (){
//            Navigator.push(
//                context, MaterialPageRoute(builder: (context) => HomePage()));
//          },
        )
      ),
      onTap: (){
        _sendLogin();
      },
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignupPage()));
            },
            child: Text(
              'Sign Up',
              style: TextStyle(
                  color: c1,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Event',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: c2,
          ),
          children: [
            TextSpan(
              text: 'App',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Name',
              style: TextStyle(color: c2, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id","email"),
        _entryField("Password","password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        error!= null ?  Text(error,style: TextStyle(color: Colors.red,fontSize: 20),) :Container() ,
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Text('Forgot Password ?',
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),

                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _createAccountLabel(),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                  Positioned(
                      top: -MediaQuery.of(context).size.height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer())

                ],
              ),
            )
        )
    );
  }

  Future<void> _sendLogin() async
  {
    final SharedPreferences prefs = await _prefs;
    Login log=Login.fromJson(body);
    String bod=loginToJson(log);
    print(bod);
    http.post(baseUrl+"api/login",body: bod,headers: {
      "Content-Type": "application/json"
    }).then((http.Response response) async {

      print(response.body);

      if(response.statusCode==444){
        Toast.show(json.decode(response.body)["message"], context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else
      if(response.statusCode==200)  {
        print(response.body);
        LoginResponse l = loginResponseFromJson(response.body);
        await prefs.setString("id", l.id) ;
        await prefs.setString("name", l.name) ;
        await prefs.setString("email", body["email"]) ;
        await prefs.setString("token", l.token) ;
        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pop(context);
        Navigator.pushReplacement(context, route);
      }
      else 
        {
          print("error");
          setState(() {
            error="user not found";
          });
        }
    });

  }
  }

