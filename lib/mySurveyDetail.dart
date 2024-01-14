import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/showAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySurveyDetailScreen extends StatefulWidget {
  final String accessToken;
  final String id;
  final String url;
  final String surveyId;

  MySurveyDetailScreen({required this.accessToken, required this.id, required this.url, required this.surveyId});

  @override
  _MySurveyDetailScreenState createState() => _MySurveyDetailScreenState();
}

class _MySurveyDetailScreenState extends State<MySurveyDetailScreen> {
  String selectedAnswer = "";
  bool isQuestionRequired = false;
  String question = "Loading.....";
  String answerA = "Loading.....";
  String answerB = "Loading.....";
  String answerC = "Loading.....";
  String answerD = "Loading.....";
  String ownerUsername = "Loading.....";
  String surveyId = "";
  int poin = 0;
  bool hasRunAsync = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();            
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
    final prefs = await SharedPreferences.getInstance(); 
    poin = prefs.getInt('poin')!.toInt();
    try {      
      final data = {
        "token": widget.accessToken,
        "id": widget.id,
        "surveyId": widget.surveyId
      };    
      final response = await http.post(
        Uri.parse("${widget.url}survey/getMySurveyDetail"),
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

  @override
  Widget build(BuildContext context) {     
    return Scaffold(
      appBar: AppBar(        
        backgroundColor: Color(0xFFFD632D),
        title: Text('My Survey Detail'), 
      ),
      body: !hasRunAsync?
        Center(
        child: CircularProgressIndicator(),
      )
      :   Container(                                        
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
                Text("A. " + answerA),
                Text("B. " + answerB),
                !answerC.isEmpty?
                  Text("C. " + answerC) 
                : Text(""),
                !answerD.isEmpty?
                  Text("D. " + answerD)
                : Text(""),
            ]  
          ),
        )
      // },
    // ),
  ),
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