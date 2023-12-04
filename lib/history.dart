import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<CompletedSurvey> completedSurveys = [
    CompletedSurvey('Survey 1', '5 Poin', 'Completed'),
    CompletedSurvey('Survey 2', '8 Poin', 'Completed'),
    CompletedSurvey('Survey 3', '12 Poin', 'Completed'),
    // Tambahkan survei yang telah selesai sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    // int totalSurveys = completedSurveys.length;
    // int totalPointsEarned = calculateTotalPointsEarned(completedSurveys);
    // int totalPointsRedeemed = 0; // Anda dapat menghitung total poin yang di-redeem

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFD632D),
        title: Text('History Survey'),
      ),
      body: Column(
        children: [
          // Container(
          //   padding: EdgeInsets.all(16.0),
          //   color: Color(0xFFFF993C), // Warna latar belakang box
          //   child: Column(
          //     children: [
          //       Text(
          //         'Total Survei Dikerjakan: $totalSurveys',
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ),
          //       Text(
          //         'Total Poin Didapatkan: $totalPointsEarned',
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ),
          //       Text(
          //         'Total Poin Redeem: $totalPointsRedeemed',
          //         style: TextStyle(fontSize: 18, color: Colors.white),
          //       ),
          //     ],
          //   ),
          // ),
          // Divider(), // Garis pemisah
          Expanded(
            child: ListView.builder(
              itemCount: completedSurveys.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(completedSurveys[index].name),
                  subtitle: Text(completedSurveys[index].points),
                  trailing: Text(completedSurveys[index].status),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int calculateTotalPointsEarned(List<CompletedSurvey> surveys) {
    int totalPoints = 0;
    for (var survey in surveys) {
      // Parsing jumlah poin dari string dan menambahkannya ke totalPoints
      totalPoints += int.parse(survey.points.split(' ')[0]);
    }
    return totalPoints;
  }
}

class CompletedSurvey {
  final String name;
  final String points;
  final String status;

  CompletedSurvey(this.name, this.points, this.status);
}