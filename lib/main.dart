// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'words/random-words.dart';
import 'google-map.dart';
import 'amap-map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'amap-navigation.dart';
import 'news/news.dart';
import 'httpService/login-http.dart';
import 'dart:convert' as convert;
import 'common/user.dart';
import 'news/articleDetail.dart';
import 'wy-news/wy-news.dart';
import 'wy-news/wy-news-list.dart';
import 'wy-news/wy-news-detail.dart';

void main() => runApp(MintApp());

class MintApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    'wordDetail': (context) => wordDetail(),
    'articleDetail': (context) => articleDetail(),
    'wyArticleDetail': (context) => wyNewsList(),
    'wyNewsDetail': (contenxt) => wyNewsDetail(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      routes: routes,
      home: Tabs(),
    );
  }
}

final List<Permission> needPermissionList = [
  Permission.location,
  Permission.storage,
  Permission.phone,
  Permission.camera,
];

/*
 * 底部tab抽离
 */
class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

// 全局http请求token
class _TabsState extends State<Tabs> {
  var response = null;
  @override
  void initState() {
    super.initState();
    _checkPermissions();
    login().then((res) => {
          response = convert.jsonDecode(res.body),
          if (res.statusCode == 200 && response['code'] == 200)
            {
              userGlobal.token = response['token'],
              userGlobal.userInfo.forEach((key, value) {
                userGlobal.userInfo[key] = response['data'][key];
                print('$key:${response['data'][key]}');
              }),
              print('登录成功 http token is: ${userGlobal.token}.')
            }
          else
            {print('Request failed with status: ${response.statusCode}.')}
        });
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
    wyNews(),
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
              label: '新闻',
              tooltip: '网易新闻',
              icon: Icon(Icons.new_releases_outlined, color: Colors.amber)),
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

///请求权限
// void _requestPermission() async {
//   debugPrint("进入闪屏页面");
//   // 申请权限
//   // PermissionStatus cameraStatus;
//
//   await [Permission.camera].request();
//   // .then((value){
//   //设置申请后的结果
//   // cameraStatus=value[Permission.camera];
//   // });
//   //或者直接调用:
//   debugPrint("请求权限,并获取权限");
//   if (await Permission.camera.isDenied) {}
//
//   //校验权限
//   if (await Permission.camera.isGranted) {
//     debugPrint("校验权限:用户都同意了");
//     //用户都同意了(用&&)
//     ///权限都申请成功初始化闪屏
//     _initSplash();
//   } else if (await Permission.camera.isDenied) {
//     debugPrint("校验权限:有任何一组权限被用户拒绝");
//     //用户拒绝了(用||)
//     ///有任何一组权限被用户拒绝
//     //拼接提示权限文本
//     StringBuffer sb = new StringBuffer();
//     sb.write(await Permission.camera.isDenied ? "相机," : "");
//     String tip = Utils.removePostfix(sb.toString(), ",");
//
//     Utils.showCustomDialog(
//         context,
//         ConfirmDialog(
//           "您拒绝了应用的必要权限:\n[$tip],是否重新申请?",
//           canBackDismiss: false,
//           confirmCallback: () => _requestPermission(),
//           cancelCallback: () => SystemNavigator.pop(),
//         ));
//   } else if (await Permission.camera.isPermanentlyDenied) {
//     debugPrint("校验权限:有权限永久拒绝");
//     //有权限永久拒绝(用||)
//     ///有任何一组权限选了不再提示
//     //拼接提示权限文本
//     StringBuffer sb = new StringBuffer();
//     sb.write(await Permission.camera.isPermanentlyDenied ? "相机," : "");
//     String tip = Utils.removePostfix(sb.toString(), ",");
//
//     Utils.showCustomDialog(
//         context,
//         ConfirmDialog(
//           "您禁用了应用的必要权限:\n[$tip],请到设置里允许?",
//           canBackDismiss: false,
//           confirmText: "去设置",
//           confirmCallback: () async {
//             await openAppSettings(); //打开设置页面
//             SystemNavigator.pop();
//           },
//           cancelCallback: () => SystemNavigator.pop(),
//         ));
//   }
// }
