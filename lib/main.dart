// import 'package:http/http.dart' as http;
// Future<http.Response> pepTalk() async {
//   var url = Uri.http('44.201.156.169:5000', '/');
//   var response = await http.get(url);
//   if (response.statusCode == 200) {
//     var jsonResponse =
//         convert.jsonDecode(response.body) as Map<String, dynamic>;
//     var pepTalk = jsonResponse['message'];
//     return pepTalk;
//   }
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Motivation> fetchMotivation() async {
  var url = Uri.http('44.201.156.169:5000', '/');
  print(url);
  final response = await http.get(url);
  print(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Motivation.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Motivation {
  final String message;

  const Motivation({
    required this.message,
  });

  factory Motivation.fromJson(Map<String, dynamic> json) {
    return Motivation(
      message: json['message'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Motivation> futureMessage;

  @override
  void initState() {
    super.initState();
    futureMessage = fetchMotivation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motivational Speaker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Get Motivated'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<Motivation>(
              future: futureMessage,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(snapshot.data!.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            SizedBox.square(
              dimension: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  futureMessage = fetchMotivation();
                });
              },
              child: Text('Motivate Me!'),
            )
          ],
        ),
      ),
    );
  }
}
