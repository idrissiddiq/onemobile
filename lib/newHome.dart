import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/utils.dart';
import 'utils/adHelper.dart';
import 'main.dart';
import 'mySurvey.dart';
import 'survey.dart';
import 'createSurvey.dart';
import 'myAnswerHistory.dart';
import 'redeem.dart';
import 'myRedeem.dart';

class HomeScreen extends StatefulWidget {
  final String accessToken;
  final String id;
  final String username;
  final String email;
  final String url;
  final String poin;

  HomeScreen({required this.accessToken, required this.id, required this.username, required this.email, required this.url, required this.poin});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState  extends  State<HomeScreen> {
  Map<String, String> _userData = {};       

  @override
  void initState() {
    super.initState();    
    _fetchUserData();
    AdHelper.bannerAd?.dispose();
    AdHelper.loadBannerAd();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();    
    _userData.addAll({"username": prefs.getString("username").toString(), "email": prefs.getString("email").toString()});    
  }
  
  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);  
    await prefs.remove('access_token');
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(      
      key: _scaffoldKey,
      body: Container(
      width: double.infinity,
      child: Container(        
        width: double.infinity,
        decoration: BoxDecoration (
          color: Color(0xfff6f6f9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(              
              padding: EdgeInsets.fromLTRB(30*fem, 63*fem, 0*fem, 1*fem),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(                    
                    margin: EdgeInsets.fromLTRB(4*fem, 0*fem, 33.5*fem, 20*fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(                          
                          child: ElevatedButton(
                            onPressed: () {                              
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFD632D),
                            ),
                            child: Icon(Icons.menu),
                          ),  
                          ),
                      ],
                    ),
                  ),
                  Container(                                        
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 98*fem, 30*fem),
                    child: Text(
                      'Welcome, '+ widget.username + '.',
                      style: SafeGoogleFont (
                        'DM Sans',
                        fontSize: 34*ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.3025*ffem/fem,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(                    
                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 30*fem, 19*fem),
                    width: 354*fem,
                    height: 146*fem,
                    decoration: BoxDecoration (
                      borderRadius: BorderRadius.circular(20*fem),
                    ),
                    child: Stack(
                      children: [                        
                        Positioned(                          
                          left: 0*fem,
                          top: 0*fem,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(30*fem, 30*fem, 10*fem, 22*fem),
                            width: 354*fem,
                            height: 125*fem,
                            decoration: BoxDecoration (
                              borderRadius: BorderRadius.circular(20*fem),
                              gradient: LinearGradient (
                                begin: Alignment(-0, -1),
                                end: Alignment(-0.919, 0.5),
                                colors: <Color>[Color(0xFFFD632D), Color(0xFFFF993C)],
                                stops: <double>[0, 1],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(                                  
                                  margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 9*fem),
                                  child: Text(
                                    'Your total poin',
                                    style: SafeGoogleFont (
                                      'SF Pro Text',
                                      fontSize: 16*ffem,
                                      fontWeight: FontWeight.w500,
                                      height: 1.2575*ffem/fem,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                                Container(                                  
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(                                        
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 60*fem, 2*fem),
                                        child: Text(
                                          widget.poin,
                                          style: SafeGoogleFont (
                                            'SF Pro Display',
                                            fontSize: 32*ffem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2575*ffem/fem,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      Container(                                        
                                        width: 125*fem,
                                        height: 40*fem,
                                        child: Stack(
                                          children: [                                            
                                            Positioned(                                              
                                              left: 0*fem,
                                              top: 0*fem,                                              
                                                child: ElevatedButton(
                                                  onPressed: () {                                                    
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RedeemScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, poin: widget.poin, email: widget.email, username: widget.username)));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Color(0xFFFFFFFF),                                                    
                                                    
                                                  ),
                                                  child: Text(
                                                    'Redeem now',
                                                    style: SafeGoogleFont (
                                                      'SF Pro Text',
                                                      fontSize: 14*ffem,
                                                      fontWeight: FontWeight.w600,
                                                      height: 1.2575*ffem/fem,
                                                      color: Color(0xFFFD632D),
                                                    ),
                                                  ),
                                                ),
                                              // ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),           
                ],
              ),
            ),
          ],
        ),
      ),
          ),
          floatingActionButton: FloatingActionButton(
        onPressed: () {          
          Navigator.push(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: widget.accessToken, id: widget.id, username: widget.username, email: widget.email, poin: widget.poin, url: widget.url)));
        },
        child: Icon(Icons.assignment),
        backgroundColor: Color(0xFFFF993C),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
      bottomNavigationBar: AdHelper.bannerAd != null
          ? Container(
              height: AdHelper.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: AdHelper.bannerAd!),
            )
          : null,
      
      drawer: Drawer(
        child: Container(
          color: Color(0xFFFF993C),
          child: ListView(
            children: [
              FutureBuilder<void>(
                    future: _fetchUserData(),
                    builder: (context, snapshot) {                      
                        return UserAccountsDrawerHeader(
                          accountName: Text(widget.username),
                          accountEmail: Text(widget.email),
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
              ListTile(
                  leading: Icon(Icons.question_mark),
                title: Text(
                  'Create Question',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateSurveyScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, email: widget.email, username: widget.username, poin: widget.poin)));                  
                },
              ),
              ListTile(
              leading: Icon(Icons.assignment), 
              title: Text(
                'My Question',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MySurveyScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url))); // Navigasi ke halaman profil
              },
            ),
            ListTile(
              leading: Icon(Icons.history), 
              title: Text(
                'History',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyAnswerHistoryScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url))); // Navigasi ke halaman profil
              },
            ),
            ListTile(
              leading: Icon(Icons.money), 
              title: Text(
                'My Redeem',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              onTap: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyRedeemScreen(accessToken: widget.accessToken, id: widget.id, username: widget.username, email: widget.email, url: widget.url, poin: widget.poin))); // Navigasi ke halaman profil
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