import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'survey.dart';
import 'utils/showAlert.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginForm>  {
  bool isLoading = false;
  String url = "https://test.my.id/apidev/public/api/";

  Future<void> _handleGitHubLogin(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
    final prefs = await SharedPreferences.getInstance();            
    prefs.setString('url', url);
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;      
    if (isLoggedIn) {      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: prefs.getString('access_token').toString(), id: prefs.getInt('id').toString(), url: url, username: prefs.getString('username').toString(), email: prefs.getString('email').toString(), poin: prefs.getInt('point').toString())));
      setState(() {
      isLoading = false;
    });
    } else {      
      final result = await FlutterWebAuth.authenticate(
      url: 'https://github.com/login/oauth/authorize?client_id=client_id_test&scope=user',
      callbackUrlScheme: 'oneopinion', // Ganti dengan skema kustom yang Anda konfigurasi
    );    
    if (result.isNotEmpty) {                            
        final data = {
          "code": Uri.parse(result).queryParameters['code'].toString(), 
          "modeId": '1',         
        };    
        final response = await http.post(
          Uri.parse("https://test.my.id/apidev/public/api/user"),
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: prefs.getString('access_token').toString(), id: prefs.getInt('id').toString(), url: url, username: prefs.getString('username').toString(), email: prefs.getString('email').toString(), poin: prefs.getInt('poin').toString())));
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

  Future<void> loginWithFacebook(BuildContext context) async {    
    final String facebookAppId = 'app_id_test';
    final String redirectUri = 'https://192.168.1.6/redirect/index.html'; 
    final String clientSecret = 'client_secret_test';
    setState(() {
      isLoading = true;
    });   
    try{
      final String codeUrl =
        'https://www.facebook.com/dialog/oauth?client_id=$facebookAppId&redirect_uri=$redirectUri&scope=email,public_profile';
      final result = await FlutterWebAuth.authenticate(
        url: codeUrl,
        callbackUrlScheme: 'oneopinion', // Ganti dengan skema kustom yang Anda konfigurasi
      );    
      if (result.isNotEmpty) {  
        final data = {
          "code": Uri.parse(result).queryParameters['code'].toString(),  
          "modeId": '2',        
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
            final prefs = await SharedPreferences.getInstance();           
            await prefs.setBool('isLoggedIn', true);     
            await prefs.setString('access_token', parsedJson['token']);
            await prefs.setString('username', parsedJson['username']);
            await prefs.setString('email', parsedJson['email']);
            await prefs.setInt('id', parsedJson['id']);
            await prefs.setInt('poin', parsedJson['poin']);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: prefs.getString('access_token').toString(), id: prefs.getInt('id').toString(), url: url, username: prefs.getString('username').toString(), email: prefs.getString('email').toString(), poin: prefs.getInt('poin').toString())));
          } else{
            showAlert(context, parsedJson['responseMessage']);
          }                    
        } else {          
          showAlert(context, "HTTP Error: ${response.statusCode}");
        }             
      } else {
        showAlert(context, 'Gagal mengambil code aplikasi');
      }
    } catch(e){
      showAlert(context, 'Error: $e');
    }
    setState(() {
      isLoading = false;
    }); 
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
              // Text(
              //   "Login with :",
              //   style: TextStyle(fontSize: 20),              
              // ),
              isLoading? 
                CircularProgressIndicator()
              :                
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {                    
                        loginWithFacebook(context);                 
                      },
                      icon: FaIcon(FontAwesomeIcons.facebook),     
                      label: Text("Login with Facebook"),               
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF316FF6),
                      ),                  
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {                    
                        _handleGitHubLogin(context);                 
                      },
                      icon: FaIcon(FontAwesomeIcons.github),     
                      label: Text("Login with Github"),               
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),                  
                    ),                
                    // IconButton(
                    //   onPressed: () async {                    
                    //     loginWithFacebook(context);                 
                    //   }, 
                    //   icon: FaIcon(FontAwesomeIcons.facebook),
                    //   color: Color.fromARGB(255, 0, 115, 255),
                    // ),
                    // IconButton(
                    //   onPressed: () async {                    
                    //     _handleGitHubLogin(context);                 
                    //   }, 
                    //   icon: FaIcon(FontAwesomeIcons.github),
                    //   color: Colors.black,
                    // ),
                  ],
                )
                // ElevatedButton(
                //   onPressed: () async {                    
                //     loginWithFacebook(context);                 
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: Color.fromARGB(255, 0, 115, 255),
                //   ),
                //   child: Text('Login with Facebook'),
                // ),
                // ElevatedButton(
                //   onPressed: () async {
                //     _handleGitHubLogin(context);                  
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.black, 
                //   ),
                //   child: Text('Login with GitHub'),
                // ),
            ],
          ),
        ),
      ),      
    );
  }
}
