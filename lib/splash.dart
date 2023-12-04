import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tambahkan delay untuk simulasi tampilan splash
    Future.delayed(Duration(seconds: 2), () {
      checkLoginStatus().then((isLoggedIn) {
        if (isLoggedIn) {
          checkToken().then((access_token){
            if(access_token!.isNotEmpty){
              checkUsername().then((username){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: access_token.toString(), username: username.toString())));
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

  Future<String?> checkUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFD632D),
      body: Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tambahkan logo di bawah ini
            Image.asset(
              'images/logo.png', // Ganti dengan path logo yang sesuai
              width: 120.0,
              height: 120.0,
            ),
            SizedBox(height: 20.0), // Berikan jarak antara logo dan CircularProgressIndicator
            CircularProgressIndicator(), // Anda dapat menyesuaikan tampilan CircularProgressIndicator
          ],
        ),
      ),
    );
  }
}