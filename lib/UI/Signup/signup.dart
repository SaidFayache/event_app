import 'package:flutter/material.dart';
import 'package:event_app/UI/Login/login.dart';
import 'package:event_app/UI/Login/Widgets/bezierContainer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_app/Const/colors.dart';
import 'package:event_app/API/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:event_app/Const/strings.dart';



class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();

}


class _SignupPageState extends State<SignupPage> {
   Map<String,String> body;
    User user;


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
                print('data $data');
              setState(() {
                body[key]=data;
              });

              print(' bodyy ${body[key]}');




            }
          )
        ],
      ),
    );
  }


  Widget _submitButton() {
    return Container(
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
      child: InkWell(onTap: () {
        addPersonName();
      },
        child: Text(
        'Register Now',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      )

    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Login',
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
        _entryField("Full Name","name"),
        _entryField("Email id","email"),
        _entryField("Phone Number","number"),
        _entryField("Password","password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            controller: ScrollController(),
            child:Container(
              height: MediaQuery.of(context).size.height,
              child:Stack(
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
                          height: 10,
                        ),
                        _emailPasswordWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        _submitButton(),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _loginAccountLabel(),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),

                ],
              ),
            )
        )
    );
  }

  void addPersonName() async{

      User user=User.fromJson(body);
     String bod=userToJson(user);
     print(bod);

    http.post(baseUrl+"api/users",body: bod, headers: {
      "Content-Type": "application/json"
    }).then((http.Response response){
      print(body);
      print(response.body) ;
    }) ;
  }
}
