import 'package:flutter/material.dart';

class gaodeMap extends StatefulWidget {
  @override
  _gaodeMapState createState() => _gaodeMapState();
}

class _gaodeMapState extends State<gaodeMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('高德地图'),
          backgroundColor: Colors.green[700],
        ),
      ),
    );
  }
}
