import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Container(
        child: new FutureBuilder<List<User>>(
          future: fetchUserFromGithub(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  return new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(snapshot.data[index].name,
                      style: new TextStyle(fontWeight: FontWeight.bold)),
                      new Divider(),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError){
              return new Text("${snapshot.error}");
            }

            return new CircularProgressIndicator();
          },
        )
      ),
    
    );
  }
}
Future<List<User>> fetchUserFromGithub() async {
  final response = await http.get('https://api.github.com/users');
  print(response.body);
  List reponseJson = json.decode(response.body.toString());
  List<User> userList = createUserList(reponseJson);
  return userList;
}

List<User> createUserList(List data){
  List<User> list = new List();

  for (int i = 0; i < data.length; i++){
    String title = data[i]["login"];
    int id = data[i]["id"];
    User movie = new User(name: title, id: id);
    list.add(movie);
  }
  return list;
}

class User {
  String name;
  int id;

  User({this.name, this.id});
}