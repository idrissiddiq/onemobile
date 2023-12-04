import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class SubmitScreen extends StatefulWidget {
  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  @override
  void initState() {
    super.initState();
    // Menavigasi kembali ke Home setelah 5 detik
    Timer(Duration(seconds: 5), () {
      checkToken().then((access_token){
            if(access_token!.isNotEmpty){
              checkUsername().then((username){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: access_token.toString(), username: username.toString())));
              });              
            }
          }); 
    });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.thumb_up, // Ikoni tangan jempol atas
              size: 80,
              color: Color(0xFFFF993C), // Warna ikon
            ),
            SizedBox(height: 20),
            Text(
              'Terima Kasih!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Jawaban survei Anda telah terkirim.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Menampilkan CircularProgressIndicator
          ],
        ),
      ),
    );
  }
}