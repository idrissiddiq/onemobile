import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/showAlert.dart';
import 'utils/adHelper.dart';
import 'newHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveyScreen extends StatefulWidget {
  final String accessToken;
  final String id;
  final String username;
  final String email;
  final String url;
  final String poin;

  SurveyScreen({required this.accessToken, required this.id, required this.username, required this.email, required this.url, required this.poin});

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String selectedAnswer = "";
  bool isQuestionRequired = false;
  String question = "Loading.....";
  String answerA = "Loading.....";
  String answerB = "Loading.....";
  String answerC = "Loading.....";
  String answerD = "Loading.....";
  String ownerUsername = "Loading.....";
  String surveyId = "";  
  bool hasRunAsync = false;
  bool isLoading = false;
  int poinTemp = 0;

  @override
  void initState() {
    super.initState();   
    AdHelper.bannerAd?.dispose();
    AdHelper.loadBannerAd();         
    Future.delayed(Duration.zero, () async {
      if (!hasRunAsync) {
        await _fetchSurvey();
        print('Async function executed only once');        
        setState(() {
          hasRunAsync = true;
        });
      }
    });
  }

  Future<void> _fetchSurvey() async {        
    try {      
      final data = {
        "token": widget.accessToken,
        "id": widget.id
      };    
      final response = await http.post(
        Uri.parse("${widget.url}survey/getSurvey"),
        body: jsonEncode(data),
        headers: {
         "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {             
        final parsedJson = json.decode(response.body);
        final responseCode = parsedJson['responseCode'];
        if(responseCode == "200"){            
            final data = parsedJson['data'];
            question = data['question'];
            answerA = data['answerA'];
            answerB = data['answerB'];
            answerC = data['answerC'];
            answerD = data['answerD'];
            ownerUsername = data['ownerUsername'];
            surveyId = data['surveyId'].toString();            
        } else{
          surveyErrorAlert(context, parsedJson['responseMessage']);          
          throw Exception("HTTP Error: ${response.statusCode}");
        }                    
        } else {          
          surveyErrorAlert(context, "HTTP Error: ${response.statusCode}");          
          throw Exception("HTTP Error: ${response.statusCode}");
        }                    
    } catch (e) {
    surveyErrorAlert(context, 'Error: $e');    
    throw Exception("HTTP Error: $e");
    }
  }

  Future<void> _submitSurvey() async {    
    try {            
      final data = {
        "token": widget.accessToken,
        "id": widget.id,
        "surveyId": surveyId,
        "answer": selectedAnswer
      };    
      final response = await http.post(
        Uri.parse("${widget.url}answer/submitAnswer"),
        body: jsonEncode(data),
        headers: {
         "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {          
        final parsedJson = json.decode(response.body);
        final responseCode = parsedJson['responseCode'];
        if(responseCode == "200"){             
          poinTemp = int.parse(widget.poin) + 1;
          final prefs = await SharedPreferences.getInstance(); 
          await prefs.setInt('poin', poinTemp);

        } else{
          showAlert(context, parsedJson['responseMessage']);          
        }                    
        } else {          
          showAlert(context, "HTTP Error: ${response.statusCode}");          
        }              
    } catch (e) {
    showAlert(context, 'Error: $e');    
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SurveyScreen(accessToken: widget.accessToken, id: widget.id, username: widget.username, email: widget.email, poin: poinTemp.toString(), url: widget.url)));
  }  

  @override
  Widget build(BuildContext context) {     
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {              
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: widget.accessToken, id: widget.id, username: widget.username, email: widget.email, poin: widget.poin, url: widget.url)));
            },
          ),
        backgroundColor: Color(0xFFFD632D),
        title: Text('Survey'), 
      ),
      body: !hasRunAsync?
        Center(
        child: CircularProgressIndicator(),
      )
      :      Container(                                        
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(question,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,                  
                ),),
                Text("by $ownerUsername",
                style: TextStyle(
                  fontSize: 10,                                   
                ),),
                RadioListTile(value: "A",
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
                title: Text(answerA),
                activeColor: Color(0xFFFF993C),),
                RadioListTile(value: "B",
                groupValue: selectedAnswer,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer = value!;
                  });
                },
                title: Text(answerB),
                activeColor: Color(0xFFFF993C),),
                !answerC.isEmpty?                
                  RadioListTile(value: "C",
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value!;
                    });
                  },
                  title: Text(answerC),
                  activeColor: Color(0xFFFF993C),)
                : Text(""),
                !answerD.isEmpty?                
                  RadioListTile(value: "D",
                  groupValue: selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value!;
                    });
                  },
                  title: Text(answerD),
                  activeColor: Color(0xFFFF993C),)
                : Text(""),
                SizedBox(height: 20.0),
                if (isLoading) CircularProgressIndicator()
                else                                     
                  ElevatedButton(onPressed: () {
                    if (selectedAnswer.isEmpty) {                      
                      setState(() {
                        isQuestionRequired = true;                      
                      });
                    } else{
                      isQuestionRequired = false;                      
                      setState(() {
                        isLoading = true;
                      });
                      _submitSurvey();                   
                    }                                    
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF993C),
                  ),
                  child: Text(
                    'Kirim Jawaban',
                    style: TextStyle(color: Colors.white),
                  ),
                    ),                                                      
               if (isQuestionRequired)
                Text(
                  'Semua pertanyaan wajib diisi',
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
        )
      // },
    // ),
  ),
  bottomNavigationBar: AdHelper.bannerAd != null
        ? Container(
              height: AdHelper.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: AdHelper.bannerAd!),
            )
          : null,
  );
  }
  
}

class Survey {  
  final String questions;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final int surveyId;  

  Survey(this.questions, this.answerA, this.answerB, this.answerC, this.answerD, this.surveyId);
}