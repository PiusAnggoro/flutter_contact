import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://randomuser.me/api/?results=5';
  List data;

  Future<String> makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["results"];
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text('Contact List'),
        ),
        body: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              return ListTile(
                title: Text(data[i]["name"]["first"]),
                subtitle: Text(data[i]["phone"]),
                leading: new CircleAvatar(
                  backgroundImage:
                  new NetworkImage(data[i]["picture"]["thumbnail"]),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new SecondPage(data[i])));
                },
              );
            }
        )
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: AppBar(title: Text(data["name"]["first"])),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: new BoxDecoration(
                color: const Color(0xff7c94b6),
                image: new DecorationImage(
                  image: new NetworkImage(data["picture"]["large"]),
                  fit: BoxFit.cover,
                ),
                //borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
                border: new Border.all(
                  color: Colors.red,
                  width: 4.0,
                ),
              ),
            ),
          ),
          Text(data["gender"]),
          Text(data["phone"]),
          Text(data["email"]),
        ],
      ));
}