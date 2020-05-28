import 'dart:convert';

import 'package:event_app/Const/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';


class HttpBuilder {

  String url ;
  dynamic _headers;
  bool showLoading = false;

  String  _body;
  int requestType ;
  BuildContext context;
  Function(http.Response) _onSuccess ;
  Function(http.Response) _onFailure ;
  Function(http.Response response) _showDefaultOnSuccessAlert ;
  Function() _showDefaultOnWarningAlert ;
  Function(String error , http.Response response) _showDefaultOnFailureAlert ;
  String error ;

  HttpBuilder({this.url,this.context,this.showLoading});



  HttpBuilder get(){
    this.requestType = 0 ;
    return this ;
  }
  HttpBuilder post(){
    this.requestType = 1 ;
    return this ;
  }
  HttpBuilder put(){
    this.requestType = 2 ;
    return this ;
  }
  HttpBuilder delete(){
    this.requestType = 3 ;
    return this ;
  }


  HttpBuilder onSuccess(Function(http.Response response) function){
    this._onSuccess = function ;
    return this ;
  }
  HttpBuilder onFailure(Function(http.Response response) function){
    this._onFailure = function ;
    return this ;
  }

  HttpBuilder headers(dynamic headers){
    this._headers = headers ;
    return this ;
  }
  HttpBuilder body(String body){
    this._body = body ;
    return this ;
  }


  HttpBuilder showDefaultOnSuccessAlert(String title , String description){
    this._showDefaultOnSuccessAlert =  (http.Response response){
      SweetAlert.show(context,
          title: title==null?"Success":title,
          subtitle: description==null?"":description,
          style: SweetAlertStyle.success,
          onPress: (val){
            _onSuccess(response);
            return true ;
          }
      );
    };

   return this ;
  }


  HttpBuilder showDefaultOnFailureAlert(String title){
    this._showDefaultOnFailureAlert =  (error , http.Response response){
      SweetAlert.show(context,
          title: title==null?null:"Error",
          subtitle: error,
          style: SweetAlertStyle.error ,
        onPress: (val){
          _onFailure(response);
          return true ;
        }

      );
    };

    return this ;
  }

  void _showLoading(){
    SweetAlert.show(
      context,
      title: "Loading",
      style: SweetAlertStyle.loading,
    );
  }

  HttpBuilder showWarningAlert(String title , String description){
    this._showDefaultOnWarningAlert =  (){
      SweetAlert.show(context,
          title: title==null?"Success":title,
          subtitle: description==null?"":description,
          style: SweetAlertStyle.confirm,
          showCancelButton: true,
          onPress: (val){
        if(val){
          if(showLoading)_showLoading();
          send();
          return false ;
        }else{
          return true ;
        }

          }
      );
    };

    return this ;
  }



  void run(){

    if(_showDefaultOnWarningAlert!=null) {
      _showDefaultOnWarningAlert();
    }else{
      if(showLoading)_showLoading();      send();
    }


  }

  void send() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString("token");

    if(_headers!=null) {
      _headers["x-access-token"]=token ;
    }else{
      _headers = {

      };
    }
    if(_body==null){
      _body ="";
    }
    Future<http.Response> request ;

    switch(requestType){
      case 0 : request = http.get(baseUrl+url,headers: _headers);break ;
      case 1 : request = http.post(baseUrl+url,headers: _headers , body: _body);break ;
      case 2 : request = http.put(baseUrl+url,headers: _headers,body: _body);break ;
      case 3 : request = http.delete(baseUrl+url,headers: _headers);break ;
    }
    http.Response response = await request ;

    print(response.body);
    if(200<=response.statusCode&& response.statusCode<300){
      if(_showDefaultOnFailureAlert!=null){
        _showDefaultOnSuccessAlert(response);

      }else{

      if(_onSuccess!=null)  _onSuccess(response);
      }
    }else if(response.statusCode==444){
      if(_showDefaultOnFailureAlert!=null){
        _showDefaultOnFailureAlert(json.decode(response.body)["message"],response);

      }else{
        if(_onFailure!=null){
          _onFailure(response);
        }
      }
    }else{
      if(_showDefaultOnFailureAlert!=null){
        _showDefaultOnFailureAlert("Error",response);

      }else{
        if(_onFailure!=null){
          _onFailure(response);
        }
      }
    }


  }





}