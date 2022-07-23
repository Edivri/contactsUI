import 'package:flutter/material.dart';
import 'package:exemplo/src/home/home_module.dart';
import 'home/home_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routes = <String, WidgetBuilder>{
      HomePage.tag: (context) => HomePage(),
    };
    return MaterialApp(
      title: 'Flutter Contact',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeModule(),
      routes: routes,
    );
  }
}
