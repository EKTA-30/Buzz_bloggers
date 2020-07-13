import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_blog_post/loginRegisterPage.dart';
//import 'LoginRegisterPage.dart';
import 'HomePage.dart';
import 'Mapping.dart';
import 'Authentication.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Post',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MappingPage(auth: Auth(),),
      debugShowCheckedModeBanner: false,
    );
  }
}
