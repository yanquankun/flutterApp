// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'random-words.dart';
import 'google-map.dart';
import 'amap-map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'amap-navigation.dart';
import 'news.dart';

void main() => runApp(MintApp());

class MintApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      routes: <String, WidgetBuilder>{
        'wordDetail': (context) => wordDetail(),
      },
      home: Tabs(),
    );
  }
}

final List<Permission> needPermissionList = [
  Permission.location,
  Permission.storage,
  Permission.phone,
];

/*
 * 底部tab抽离
 */
class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void reassemble() {
    super.reassemble();
    _checkPermissions();
  }

  void _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await needPermissionList.request();
    statuses.forEach((key, value) {
      print('$key premissionStatus is $value');
    });
  }

  //选中的条目
  var _currentIndex = 0;

  //tab对应的body页面
  var _pageList = [
    RandomWords(),
    newsPage(),
    amapNavigatePage('高德导航', '地图导航'),
    Amapofficial()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        currentIndex: this._currentIndex,
        items: [
          BottomNavigationBarItem(
              label: '单词推荐',
              tooltip: '随机单词推荐',
              icon: Icon(Icons.remove_red_eye, color: Colors.amber)),
          BottomNavigationBarItem(
              label: '资讯',
              tooltip: '订阅推荐',
              icon: Icon(Icons.new_releases_sharp, color: Colors.amber)),
          BottomNavigationBarItem(
              label: '高德地图',
              tooltip: '个人高德地图使用测试',
              icon: Icon(Icons.maps_ugc_rounded, color: Colors.amber)),
          // BottomNavigationBarItem(label: '谷歌地图', icon: Icon(Icons.map)),
          BottomNavigationBarItem(
              label: '高德官方DEMO',
              tooltip: '集成高德官方地图demo',
              icon: Icon(Icons.map_rounded, color: Colors.amber)),
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
