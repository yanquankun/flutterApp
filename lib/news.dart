import 'package:flutter/material.dart';

class newsPage extends StatefulWidget {
  @override
  _newsPageState createState() => _newsPageState();
}

class _newsPageState extends State<newsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("新闻资讯"),
        ),
        body: Center(
          child: Text("新闻资讯"),
        ));
  }
}
