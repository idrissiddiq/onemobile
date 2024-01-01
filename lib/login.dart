import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'survey.dart';
import 'utils/showAlert.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginForm>  {
  bool isLoading = false;
  Future<void> _handleGitHubLogin(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
    final prefs = await SharedPreferences.getInstance();    
    String url = "http://192.168.1.7:8080/onemobile/api/";    
    prefs.setString('url', url);
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;      
    if (isLoggedIn) {      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: prefs.getString('access_token').toString(), id: prefs.getInt('id').toString(), url: url)));
      setState(() {
      isLoading = false;
    });
    } else {      
      final result = await FlutterWebAuth.authenticate(
      url: 'https://github.com/login/oauth/authorize?client_id=b7075d1df11ac68c2983&scope=user',
      callbackUrlScheme: 'oneopinion', // Ganti dengan skema kustom yang Anda konfigurasi
    );    
    if (result.isNotEmpty) {                            
        final data = {
          "code": Uri.parse(result).queryParameters['code'].toString(),          
        };    
        final response = await http.post(
          Uri.parse("${url}user/setToken"),
          body: jsonEncode(data),
          headers: {
             "Content-Type": "application/json",
          },
        );
        if (response.statusCode == 200) {              
          final parsedJson = json.decode(response.body);
          final responseCode = parsedJson['responseCode'];
          if(responseCode == "200"){            
            await prefs.setBool('isLoggedIn', true);     
            await prefs.setString('access_token', parsedJson['token']);
            await prefs.setString('username', parsedJson['username']);
            await prefs.setString('email', parsedJson['email']);
            await prefs.setInt('id', parsedJson['id']);
            await prefs.setInt('poin', parsedJson['poin']);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: prefs.getString('access_token').toString(), id: prefs.getInt('id').toString(), url: url)));
            setState(() {
      isLoading = false;
    });
          } else{
            showAlert(context, parsedJson['responseMessage']);
            setState(() {
      isLoading = false;
    });
          }                    
        } else {          
          showAlert(context, "HTTP Error: ${response.statusCode}");
          setState(() {
      isLoading = false;
    });
        }              
    } 
    }
  } catch (e) {
    showAlert(context, 'Error: $e');
    setState(() {
      isLoading = false;
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      backgroundColor: Color(0xFFFD632D),
      body: Center(
        child: Container(          
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle, 
                size: 48.0,
                color: Colors.white,
              ),
              SizedBox(height: 20.0),
              if (isLoading) CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () async {
                    _handleGitHubLogin(context);                  
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, 
                  ),
                  child: Text('Login with GitHub'),
                ),
            ],
          ),
        ),
      ),      
    );
  }
}