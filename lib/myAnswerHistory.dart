import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';
import 'utils/showAlert.dart';
import 'utils/adHelper.dart';
import 'dart:async';

class MyAnswerHistoryScreen extends StatefulWidget {  
  final String accessToken;
  final String id;
  final String url;

  MyAnswerHistoryScreen({required this.accessToken, required this.id, required this.url});
  
  @override
  _MyAnswerHistoryScreenState createState() => _MyAnswerHistoryScreenState();
}

class _MyAnswerHistoryScreenState extends State<MyAnswerHistoryScreen> {
  List<Answer>? answers;
  bool hasRunAsync = false;

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
        Uri.parse("${widget.url}answer/myAnswerHistory"),
        body: jsonEncode(data),
        headers: {
         "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {             
        final parsedJson = json.decode(response.body);
        final responseCode = parsedJson['responseCode'];
        if(responseCode == "200"){            
            List<dynamic> answerDataList = parsedJson['data'];        
            answers = [];    
            for (var answerData in answerDataList) {
              Answer answer = Answer.fromJson(answerData);
              answers!.add(answer);
            }        
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
        title: Text('History'),
      ),
      body: !hasRunAsync
      ? Center(
        child: CircularProgressIndicator(),
      )
      : Column(
        children: [       
          if (AdHelper.bannerAd != null)
                Container(
                  height: AdHelper.bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: AdHelper.bannerAd!),
                ),    
          Expanded(
            child: ListView.builder(
              itemCount: answers!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(answers![index].question),
                  subtitle: Text("By " + answers![index].ownerUsername),
                  trailing: Text(answers![index].answer),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Answer {  
  final String question;
  final String ownerUsername;
  final String answer;  

  Answer({required this.question, required this.ownerUsername, required this.answer});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      question: json['question'],
      ownerUsername: json['ownerUsername'],
      answer: json['answer'],
    );
  }
}