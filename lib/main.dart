// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'random-words.dart';
import 'google-map.dart';
import 'amap-map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: Tabs(),
    );
  }
}

/*
 * 底部tab抽离
 */
class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  //选中的条目
  var _currentIndex = 0;

  //tab对应的body页面
  var _pageList = [RandomWords(), googleMap(), gaodeMap()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        currentIndex: this._currentIndex,
        items: [
          BottomNavigationBarItem(
              label: "单词推荐", icon: Icon(Icons.remove_red_eye)),
          BottomNavigationBarItem(label: "谷歌地图", icon: Icon(Icons.map)),
          BottomNavigationBarItem(label: "高德地图", icon: Icon(Icons.map_rounded)),
        ],
        onTap: (value) {
          setState(() {
            this._currentIndex = value.toInt();
          });
        },
      ),
    );
  }
}
