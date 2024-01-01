import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/showAlert.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class MyRedeemScreen extends StatefulWidget {  
  final String accessToken;
  final String id;
  final String url;
  final String poin;

  MyRedeemScreen({required this.accessToken, required this.id, required this.url, required this.poin});
  
  @override
  _MyRedeemScreenState createState() => _MyRedeemScreenState();
}

class _MyRedeemScreenState extends State<MyRedeemScreen> {
  List<Redeem>? redeems;
  bool hasRunAsync = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();            
    Future.delayed(Duration.zero, () async {
      if (!hasRunAsync) {
        await _fetchRedeem();
        print('Async function executed only once');        
        setState(() {
          hasRunAsync = true;
        });
      }
    });
  }

  Future<void> _fetchRedeem() async {    
    try {      
      final data = {
        "token": widget.accessToken,
        "id": widget.id
      };    
      final response = await http.post(
        Uri.parse("${widget.url}redeem/getAllMyRedeem"),
        body: jsonEncode(data),
        headers: {
         "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {             
        final parsedJson = json.decode(response.body);
        final responseCode = parsedJson['responseCode'];
        if(responseCode == "200"){            
            List<dynamic> redeemDataList = parsedJson['data'];        
            redeems = [];    
            for (var answerData in redeemDataList) {
              Redeem redeem = Redeem.fromJson(answerData);
              redeems!.add(redeem);
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

  Future<void> _cancelRedeem(String redeemId, int amount ) async {    
    try {            
      final data = {
        "token": widget.accessToken,
        "id": widget.id,
        "redeemId": redeemId
      };    
      final response = await http.post(
        Uri.parse("${widget.url}redeem/cancelRedeem"),
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
          await prefs.setInt('poin', int.parse(widget.poin) + amount);        
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, poin: (int.parse(widget.poin) + amount).toString())));
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
        title: Text('My Redeem History'),
      ),
      body: !hasRunAsync
      ? Center(
        child: CircularProgressIndicator(),
      )
      : Column(
        children: [          
          Expanded(
            child: ListView.builder(
              itemCount: redeems!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(redeems![index].status),
                  subtitle: Text(redeems![index].amount.toString() + " via " + redeems![index].channelName + " (" + redeems![index].transferNumber + ") on " + redeems![index].createdDate.replaceAll("T", " ")),
                  trailing:
                  redeems![index].status == "Waiting"
                  ? 
                  isLoading 
                  ? CircularProgressIndicator()
                  :
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      _cancelRedeem(redeems![index].id.toString(), redeems![index].amount); 
                    },
                    style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFD632D),
                      ),
                    child: Text('Cancel'),
                  )
                  : Text(""),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Redeem {  
  final int id;
  final String status;
  final int amount; 
  final String transferNumber;
  final String createdDate;
  final String channelName;

  Redeem({required this.id, required this.status, required this.amount, required this.transferNumber, required this.createdDate, required this.channelName});

  factory Redeem.fromJson(Map<String, dynamic> json) {
    return Redeem(
      id: json['id'],
      status: json['status'],
      amount: json['amount'],
      transferNumber: json['transferNumber'],      
      createdDate: json['createdDate'],
      channelName: json['channelName'],
    );
  }
}