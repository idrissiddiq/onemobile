import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'profile.dart';
import 'history.dart';
import 'survey.dart';
import 'package:http/http.dart' as http;
import 'utils/showAlert.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  final String username;

  HomeScreen({required this.accessToken, required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState  extends  State<HomeScreen> {  
  String userName = 'Loading.....';
  String userEmail = 'Loading.....';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  final List<Survey> availableSurveys = [
    Survey('Survey 1', '10 Poin', '5 Pertanyaan'),
    Survey('Survey 2', '8 Poin', '3 Pertanyaan'),
    Survey('Survey 3', '12 Poin', '7 Pertanyaan'),
    // Tambahkan survei lainnya sesuai kebutuhan
  ];

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();  
    userName = prefs.getString("username")!;
    userEmail = prefs.getString("email")!;      
    final data = {
          "token": prefs.getString("access_token"),
          "id" : prefs.getInt("id").toString()
          // Tambahkan parameter lain jika diperlukan.
    };    
    final response = await http.post(
      Uri.parse("${prefs.getString("urlApi")}user/getMyData"),
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
        final responseData = parsedJson['data'];        
        userName = responseData['username'];
        userEmail = responseData['email'];        
      } else{
        showAlert(context, "Terjadi Error Fetching Data");
      }          
      // Selanjutnya, Anda dapat memproses data sesuai dengan kebutuhan.
    } else {
      // Respon gagal
      showAlert(context, "HTTP Error Fetching Data : ${response.statusCode}");
    }
  }
  
  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);  
    await prefs.remove('access_token');

    // Navigasi kembali ke halaman login
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        backgroundColor: Color(0xFFFD632D),
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Color(0xFFFF993C), // Warna latar belakang box
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   // 'Total Poin: 30',
                //   'Access Token: ',
                //   style: TextStyle(fontSize: 18, color: Colors.white),
                // ),
                SelectableText(
          widget.accessToken,
          style: TextStyle(fontSize: 16),
        ),
                // ElevatedButton(
                //   onPressed: () {
                //     // Tambahkan logika untuk menu poin
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: Color(0xFFFD632D),
                //   ),
                //   child: Text('Redeem Poin'),
                // ),
              ],
            ),
          ),
          Expanded(
        child: ListView.builder(
          itemCount: availableSurveys.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyScreen()));
                  // Tambahkan logika ketika survei dipilih
                  // Anda dapat membuka halaman survei atau melakukan tindakan lain sesuai kebutuhan
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF993C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      availableSurveys[index].name,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        Text(
                          availableSurveys[index].points,
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.question_answer,
                          color: Colors.green,
                        ),
                        Text(
                          availableSurveys[index].questions,
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
          ),
        ],
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Text('Mulai Survey'),
      //     Icon(Icons.arrow_forward),
      //   ],
      // ),
      drawer: Drawer(
        child: Container(
          color: Color(0xFFFF993C),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userName),
                accountEmail: Text(userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40.0,
                    color: Color(0xFFFF993C),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFF993C), // Warna latar belakang UserAccountsDrawerHeader #ff993c
                ),
                onDetailsPressed: () {
                Navigator.of(context).pop(); // Tutup sidebar
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen())); // Navigasi ke halaman profil
              },
              ),
              ListTile(
                  leading: Icon(Icons.home),
                title: Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigasi ke halaman Home ketika "Home" di-klik
                  // Tambahkan logika navigasi yang sesuai
                },
              ),
              ListTile(
              leading: Icon(Icons.history), // Ikon untuk History
              title: Text(
                'History',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Tutup sidebar
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryScreen())); // Navigasi ke halaman profil
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.dataset), // Ikon untuk History
            //   title: Text(
            //     'Data',
            //     style: TextStyle(color: Colors.white, fontSize: 18.0),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).pop(); // Tutup sidebar
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => GitHubDataWidget(accessToken: accessToken.toString()))); // Navigasi ke halaman profil
            //   },
            // ),
              ListTile(
                 leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onTap: () {
                  _handleLogout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Survey {
  final String name;
  final String points;
  final String questions;

  Survey(this.name, this.points, this.questions);
}

