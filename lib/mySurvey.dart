import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/showAlert.dart';
import 'dart:async';

class MySurveyScreen extends StatefulWidget {  
  final String accessToken;
  final String id;
  final String url;

  MySurveyScreen({required this.accessToken, required this.id, required this.url});
  
  @override
  _MySurveyScreenState createState() => _MySurveyScreenState();
}

class _MySurveyScreenState extends State<MySurveyScreen> {
  List<Survey>? surveys;
  bool hasRunAsync = false;

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
    try {      
      final data = {
        "token": widget.accessToken,
        "id": widget.id
      };    
      final response = await http.post(
        Uri.parse("${widget.url}survey/getMySurveyHistory"),
        body: jsonEncode(data),
        headers: {
         "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {             
        final parsedJson = json.decode(response.body);
        final responseCode = parsedJson['responseCode'];
        if(responseCode == "200"){            
            List<dynamic> surveyDataList = parsedJson['data'];        
            surveys = [];    
            for (var surveyData in surveyDataList) {
              Survey survey = Survey.fromJson(surveyData);
              surveys!.add(survey);
            }
            // question = data['question'];
            // answerA = data['answerA'];
            // answerB = data['answerB'];
            // answerC = data['answerC'];
            // answerD = data['answerD'];
            // ownerUsername = data['ownerUsername'];
            // surveyId = data['surveyId'].toString();            
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
        title: Text('My Survey'),
      ),
      body: !hasRunAsync
      ? Center(
        child: CircularProgressIndicator(),
      )
      : Column(
        children: [          
          Expanded(
            child: ListView.builder(
              itemCount: surveys!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(surveys![index].question),
                  subtitle: Text(surveys![index].answerCount.toString() + " Answered"),
                  trailing: ElevatedButton(onPressed: () {
                    showAlert(context, 'This menu is currently unavailable');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFD632D),
                  ),
                  child: Text('Redeem Poin')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // int calculateTotalPointsEarned(List<CompletedSurvey> surveys) {
  //   int totalPoints = 0;
  //   for (var survey in surveys) {
  //     // Parsing jumlah poin dari string dan menambahkannya ke totalPoints
  //     totalPoints += int.parse(survey.points.split(' ')[0]);
  //   }
  //   return totalPoints;
  // }
}

class Survey {
  final int id;
  final String question;
  final int answerCount;

  Survey({required this.id, required this.question, required this.answerCount});

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      question: json['question'],
      answerCount: json['answerCount'],
    );
  }
}