import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'survey.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();    
    Future.delayed(Duration(seconds: 2), () {
      checkLoginStatus().then((isLoggedIn) {
        if (isLoggedIn) {
          checkToken().then((access_token){
            if(access_token!.isNotEmpty){
              checkId().then((id){
                checkUrl().then((url){
                  checkPoin().then((poin){
                    checkUsername().then((username){
                      checkEmail().then((email){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: access_token.toString(), id: id.toString(), url: url.toString(), username: username.toString(), email: email.toString(), poin: poin.toString())));                    
                      });
                    });                    
                  });                  
                });                
              });              
            }
          });          
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginForm()));          
        }
      });
    });
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<int?> checkId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  Future<int?> checkPoin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('poin');
  }

  Future<String?> checkUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('url');
  }

  Future<String?> checkUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> checkEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFD632D),
      body: Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [            
            Image.asset(
              'images/logo.png', 
              width: 120.0,
              height: 120.0,
            ),
            SizedBox(height: 20.0), 
            CircularProgressIndicator(), 
          ],
        ),
      ),
    );
  }
}