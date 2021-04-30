import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('na3.sensitel.com/trackaware/handheldapi/transaction/'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Basic amV0c29uYXBpOlRyYWNrQXdhcmUxMQ=='
    },
    body: jsonEncode(<String, dynamic>{

        "HandHeldId": "CN51300X1601292", // this to string
        "User":"teresaf",
        "Location":"AMTEC",
        "Status":"tender",
        "id":4,
        "Packages":[{
            "DeliveryLocation":"AMTEC",
            "OrderNum":"077043105", // tostring
            "ContainerNum":"",//missing
            "LabelNum":"", // null here
            "Priority":"P1", //to string
            "Quantity":"55",//to string
            "ScanTime":"1618548484",//to string
            "ReceiverBadgeId":"", //missing
            "ReceivedBy":"",//missing
            "Item":"0770431073", // to string
            "Status":"",//missing
            "is_part":"" //null
          }
        ]

    }),
  );

  if (response.statusCode == 201) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String title;

  Album({this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<Album> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Enter Title'),
              ),
              ElevatedButton(
                child: Text('Create Data'),
                onPressed: () {
                  setState(() {
                    _futureAlbum = createAlbum(_controller.text);
                  });
                },
              ),
            ],
          )
              : FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
