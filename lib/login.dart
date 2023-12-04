import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
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
    await prefs.setString('urlApi', 'http://192.168.43.146:8080/onemobile/api/');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;  
    final accessToken = prefs.getString('access_token');  
    final username = prefs.getString('username');
    if (isLoggedIn) {
      // Pengguna sudah login, langsung ke halaman Home
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: accessToken.toString(), username: username.toString(),)));
      setState(() {
      isLoading = false;
    });
    } else {
      // Pengguna belum login, jalankan proses login
      final result = await FlutterWebAuth.authenticate(
      url: 'https://github.com/login/oauth/authorize?client_id=b7075d1df11ac68c2983&scope=user',
      callbackUrlScheme: 'oneopinion', // Ganti dengan skema kustom yang Anda konfigurasi
    );    
    if (result.isNotEmpty) {
      // Pengguna berhasil login dengan GitHub
      // Lakukan apa yang diperlukan setelah login sukses
      // Simpan status login setelah berhasil login                      
        final data = {
          "code": Uri.parse(result).queryParameters['code'].toString(),
          // Tambahkan parameter lain jika diperlukan.
        };    
        final response = await http.post(
          Uri.parse("${prefs.getString("urlApi")}user/setToken"),
          body: jsonEncode(data),
          headers: {
             "Content-Type": "application/json",
          },
        );
        if (response.statusCode == 200) {
          // Respon sukses.          
          final parsedJson = json.decode(response.body);
          final responseCode = parsedJson['responseCode'];
          if(responseCode == "200"){            
            await prefs.setBool('isLoggedIn', true);     
            await prefs.setString('access_token', parsedJson['token']);
            await prefs.setString('username', parsedJson['username']);
            await prefs.setString('email', parsedJson['email']);
            await prefs.setInt('id', parsedJson['id']);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: parsedJson['token'], username: parsedJson['username'])));
            setState(() {
      isLoading = false;
    });
          } else{
            showAlert(context, parsedJson['responseMessage']);
            setState(() {
      isLoading = false;
    });
          }          
          // Selanjutnya, Anda dapat memproses data sesuai dengan kebutuhan.
        } else {
          // Respon gagal
          showAlert(context, "HTTP Error: ${response.statusCode}");
          setState(() {
      isLoading = false;
    });
        }        
      // Navigasi ke halaman "Home" atau lakukan apa yang diperlukan.      
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
                Icons.account_circle, // Ganti dengan ikon yang sesuai
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
                    primary: Colors.black, // Mengubah warna latar belakang tombol menjadi hitam
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