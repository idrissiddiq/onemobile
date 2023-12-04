import 'package:flutter/material.dart';
import 'submit.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int selectedAnswer1 = -1;
  int selectedAnswer2 = -1;
  int selectedAnswer3 = -1;
  int selectedAnswer4 = -1;
  int selectedAnswer5 = -1;
  bool isQuestionRequired = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFD632D),
        title: Text('Survey'), // Ganti dengan nama survei yang sesuai
      ),
      body: Container(        
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pertanyaan 1: Apakah Anda suka buah apel?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,                  
                ),
              ),
              RadioListTile(
                value: 1,
                groupValue: selectedAnswer1,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer1 = value!;
                  });
                },
                title: Text('Suka'),
                activeColor: Color(0xFFFF993C),
              ),
              RadioListTile(
                value: 2,
                groupValue: selectedAnswer1,
                onChanged: (value) {
                  setState(() {
                    selectedAnswer1 = value!;
                  });
                },
                title: Text('Tidak Suka'),
                activeColor: Color(0xFFFF993C),
              ),
              // Pertanyaan 2
            Text('Pertanyaan 2: Apakah Anda suka buah pisang?',
            style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,                  
                ),),        
            RadioListTile(
              value: 1,
              groupValue: selectedAnswer2,
              onChanged: (value) {
                setState(() {
                  selectedAnswer2 = value!;
                });
              },
              title: Text('Suka'),
              activeColor: Color(0xFFFF993C),
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedAnswer2,
              onChanged: (value) {
                setState(() {
                  selectedAnswer2 = value!;
                });
              },
              title: Text('Tidak Suka'),
              activeColor: Color(0xFFFF993C),
            ),
              ElevatedButton(
                onPressed: () {
                  if (selectedAnswer1 == -1 || selectedAnswer2 == -1) {
                    // Validasi jika pertanyaan 1 atau 2 belum diisi
                    setState(() {
                      isQuestionRequired = true;                      
                    });
                  } else{
                    isQuestionRequired = false;                      
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubmitScreen())); // Navigasi ke halaman profil
                  }
                  // Tambahkan logika untuk mengirim jawaban survei
                  // Misalnya, Anda dapat menyimpan jawaban ke database atau server.                  
                },
                child: Text(
                  'Kirim Jawaban',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF993C),
                ),
              ),
               if (isQuestionRequired)
                Text(
                  'Semua pertanyaan wajib diisi',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}