import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/showAlert.dart';
import 'newHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedeemScreen extends StatefulWidget {
  final String accessToken;
  final String id;
  final String url;
  final String poin;
  final String username;
  final String email;

  RedeemScreen({required this.accessToken, required this.id, required this.url, required this.poin, required this.username, required this.email});

  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}



class _RedeemScreenState extends State<RedeemScreen> {
  bool hasRunAsync = false;
  bool isLoading = false;
  String transferNumber = "";

  String selectedNominal = '10,000';
  String selectedChannel = '';

  List<String> nominals = ['10,000', '30,000', '50,000', '100,000'];  

  List<Channel>? channels;

  @override
  void initState() {
    super.initState();            
    Future.delayed(Duration.zero, () async {
      if (!hasRunAsync) {
        await _fetchChannel();
        print('Async function executed only once');        
        setState(() {
          hasRunAsync = true;
        });
      }
    });
  }

  Future<void> _fetchChannel() async {        
    try {      
      final data = {
        "token": widget.accessToken,
        "id": widget.id
      };    
      final response = await http.post(
        Uri.parse("${widget.url}channel/findAllChannel"),
        body: jsonEncode(data),
        headers: {
         "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {             
        final parsedJson = json.decode(response.body);
        final responseCode = parsedJson['responseCode'];
        if(responseCode == "200"){                      
            List<dynamic> channelDataList = parsedJson['data'];        
            channels = [];    
            for (var channelData in channelDataList) {
              Channel channel = Channel.fromJson(channelData);
              channels!.add(channel);
            } 
            selectedChannel = channels!.first.id.toString();                     
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

  Future<void> _createRedeem() async {    
    try {            
      final data = {
        "token": widget.accessToken,
        "id": widget.id,
        "channelId": selectedChannel,
        "amount": selectedNominal.replaceAll(',', ''),
        "transferNumber": transferNumber
      };    
      final response = await http.post(
        Uri.parse("${widget.url}redeem/createRedeem"),
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
          await prefs.setInt('poin', int.parse(widget.poin) - int.parse(selectedNominal.replaceAll(',', '')));        
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, poin: prefs.getInt('poin').toString(), email: widget.email, username: widget.username)));
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {              
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(accessToken: widget.accessToken, id: widget.id, url: widget.url, poin: widget.poin, email: widget.email, username: widget.username)));
            },
          ),
          backgroundColor: Color(0xFFFD632D),
          title: Text('Redeem Form'),
        ),
        body: !hasRunAsync
      ? Center(
        child: CircularProgressIndicator(),
      )
      : Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pilih Nominal:'),
          DropdownButton<String>(
            value: selectedNominal,
            onChanged: (String? newValue) {
              setState(() {
                selectedNominal = newValue!;
              });
            },
            items: nominals.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20.0),
          Text('Pilih Channel Pembayaran:'),
          DropdownButton<String>(
            value: selectedChannel,
            onChanged: (String? newValue) {
              setState(() {
                selectedChannel = newValue!;
              });
            },
            items: channels!.map<DropdownMenuItem<String>>((Channel channel) {
              return DropdownMenuItem<String>(
                value: channel.id.toString(),
                child: Text(channel.channelName),
              );
            }).toList(),
          ),
          Row(children: [
            Text(
              'Transfer Number:',
              style: TextStyle(fontSize: 18),
            ),        
            Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
          ],),          
            TextField(           
              keyboardType: TextInputType.number,               
              decoration: InputDecoration(
                hintText: 'example : 08123456',
              ),
              onChanged: (value) {
                  setState(() {
                    transferNumber = value;
                  });
                },
            ),
          SizedBox(height: 20.0),
          if (isLoading) CircularProgressIndicator()
          else 
          ElevatedButton(
            onPressed: () {
              if (transferNumber.isNotEmpty){
                  setState(() {
                        isLoading = true;
                      });
                      _createRedeem();  
                }
            },
            style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFD632D),
              ),
            child: Text('Redeem Poin'),
          ),
          if (transferNumber.isEmpty)
                Text(
                  'Mandatory Field Must Be Filled',
                  style: TextStyle(color: Colors.red),
                )
        ],
      ),),
      ),
    );    
  }
}

class Channel {  
  final String id;
  final String channelName;  

  Channel({required this.id, required this.channelName});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      channelName: json['channelName'],      
    );
  }
}