import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oneopinion/home.dart';
import 'dart:convert';
import 'utils/showAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSurveyScreen extends StatefulWidget {
  final String accessToken;
  final String id;
  final String url;

  CreateSurveyScreen({required this.accessToken, required this.id, required this.url});

  @override
  _CreateSurveyScreenState createState() => _CreateSurveyScreenState();
}

class _CreateSurveyScreenState extends State<CreateSurveyScreen> {  
  String question = "";
  String answerA = "";
  String answerB = "";
  String answerC = "";
  String answerD = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();                
  }

  Future<void> _createSurvey() async {    
    try {            
      final data = {
        "token": widget.accessToken,
        "id": widget.id,
        "question": question,
        "answerA": answerA,
        "answerB": answerB,
        "answerC": answerC,
        "answerD": answerD
      };    
      final response = await http.post(
        Uri.parse("${widget.url}survey/createMySurvey"),
        body: jsonEncode(data),
        headers: {
         "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {          
        final parsedJson = json.decode(response.body);
        final responseCode = parsedJson['responseCode'];
        if(responseCode == "200"){             
          final prefs = await SharedPreferences.getInstance();           
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, poin: prefs.getInt('poin').toString())));
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
  }  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFD632D),
        title: Text('Survey Form'),
      ),
      body: Container(
            // child: Center(
            //     child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Pertanyaan: ',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            TextField(              
              decoration: InputDecoration(
                hintText: 'Masukkan pertanyaan Anda...',
              ),
              onChanged: (value) {
                  setState(() {
                    question = value;
                  });
                },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
              'Jawaban A:',
              style: TextStyle(fontSize: 18),
            ),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),                
            TextField(              
              decoration: InputDecoration(
                hintText: 'Masukkan Jawaban Anda...',
              ),
              onChanged: (value) {
                  setState(() {
                    answerA = value;
                  });
                },
            ),
            Row(
              children: [
                Text(
              'Jawaban B:',
              style: TextStyle(fontSize: 18),
            ),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),        
            TextField(              
              decoration: InputDecoration(
                hintText: 'Masukkan Jawaban Anda...',
              ),
              onChanged: (value) {
                  setState(() {
                    answerB = value;
                  });
                },
            ),            
            Text(
              'Jawaban C:',
              style: TextStyle(fontSize: 18),
            ),        
            TextField(              
              decoration: InputDecoration(
                hintText: 'Masukkan Jawaban Anda...',
              ),
              onChanged: (value) {
                  setState(() {
                    answerC = value;
                  });
                },
            ),            
            Text(
              'Jawaban D:',
              style: TextStyle(fontSize: 18),
            ),        
            TextField(              
              decoration: InputDecoration(
                hintText: 'Masukkan Jawaban Anda...',
              ),
              onChanged: (value) {
                  setState(() {
                    answerD = value;
                  });
                },
            ),            
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator()
            else 
            ElevatedButton(
              onPressed: () {
                // Lakukan sesuatu dengan pertanyaan dan jawaban yang dimasukkan, misalnya simpan ke database atau tampilkan pesan                
                if (question.isNotEmpty && answerA.isNotEmpty && answerB.isNotEmpty){
                  setState(() {
                        isLoading = true;
                      });
                      _createSurvey();  
                }
              },
              style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFD632D),
              ),
              child: Text('Submit Question'),              
            ),
            if (question.isEmpty || answerA.isEmpty || answerB.isEmpty)
                Text(
                  'Mandatory Field Must Be Filled',
                  style: TextStyle(color: Colors.red),
                )
          ],
        ),
      ),
    // ),
    // ),
    );
  }
}