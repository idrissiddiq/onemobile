import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GitHubDataWidget extends StatefulWidget {
  final String accessToken;
  
  GitHubDataWidget({required this.accessToken});

  @override
  _GitHubDataWidgetState createState() => _GitHubDataWidgetState();
}

class _GitHubDataWidgetState extends State<GitHubDataWidget> {
  String githubData = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.https('api.github.com', '/user');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        githubData = data.toString();
      });
    } else {
      setState(() {
        githubData = 'Status Code : ' + response.statusCode.toString() + ", Body : " + json.decode(response.body).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data GitHub'),
      ),
      body: Center(
        child: Text(githubData),
      ),
    );
  }
}