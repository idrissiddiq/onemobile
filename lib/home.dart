import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'mySurvey.dart';
import 'survey.dart';
import 'createSurvey.dart';
import 'utils/showAlert.dart';
import 'myAnswerHistory.dart';
import 'redeem.dart';
import 'myRedeem.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  final String id;
  final String url;
  final String poin;

  HomeScreen({required this.accessToken, required this.id, required this.url, required this.poin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState  extends  State<HomeScreen> {
  Map<String, String> _userData = {};       

  @override
  void initState() {
    super.initState();    
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();    
    _userData.addAll({"username": prefs.getString("username").toString(), "email": prefs.getString("email").toString()});    
  }

  // final List<Survey> availableSurveys = [
  //   Survey('Survey 1', '10 Poin', '5 Pertanyaan'),
  //   Survey('Survey 2', '8 Poin', '3 Pertanyaan'),
  //   Survey('Survey 3', '12 Poin', '7 Pertanyaan'),
  //   // Tambahkan survei lainnya sesuai kebutuhan
  // ];
  
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
                Text(
                  'Total Poin: ' + widget.poin,
                  // 'Access Token: ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
        //         SelectableText(
        //   widget.accessToken,
        //   style: TextStyle(fontSize: 16),
        // ),
                ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika untuk menu poin
                    // showAlert(context, 'This menu is currently unavailable');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RedeemScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, poin: widget.poin)));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFD632D),
                  ),
                  child: Text('Redeem Poin'),
                ),
                
              ],
            ),
          ),          
          ElevatedButton(
                  onPressed: () {
                    // Tambahkan logika untuk menu poin
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateSurveyScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url)));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFD632D),
                  ),
                  child: Text('Make Your Own Question'),
                ),                            
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {          
          // Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url)));
        },
        child: Icon(Icons.assignment),
        backgroundColor: Color(0xFFFF993C),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      drawer: Drawer(
        child: Container(
          color: Color(0xFFFF993C),
          child: ListView(
            children: [
              FutureBuilder<void>(
                    future: _fetchUserData(),
                    builder: (context, snapshot) {                      
                        return UserAccountsDrawerHeader(
                          accountName: Text(_userData["username"].toString()),
                          accountEmail: Text(_userData["email"].toString()),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 40.0,
                              color: Color(0xFFFF993C),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF993C),
                          ),
                          // onDetailsPressed: () {
                          //   Navigator.of(context).pop();
                          //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                          // },
                        );                    
                    },
                  ),
              // ListTile(
              //     leading: Icon(Icons.home),
              //   title: Text(
              //     'Home',
              //     style: TextStyle(color: Colors.white, fontSize: 18.0),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Navigasi ke halaman Home ketika "Home" di-klik
              //     // Tambahkan logika navigasi yang sesuai
              //   },
              // ),
              ListTile(
              leading: Icon(Icons.assignment), // Ikon untuk History
              title: Text(
                'My Question',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Tutup sidebar
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MySurveyScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url))); // Navigasi ke halaman profil
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyAnswerHistoryScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url))); // Navigasi ke halaman profil
              },
            ),
            ListTile(
              leading: Icon(Icons.money), // Ikon untuk History
              title: Text(
                'My Redeem',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Tutup sidebar
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyRedeemScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, poin: widget.poin))); // Navigasi ke halaman profil
              },
            ),
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

