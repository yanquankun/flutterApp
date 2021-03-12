// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'words/random-words.dart';
import 'news/articleDetail.dart';
import 'wy-news/wy-news-list.dart';
import 'wy-news/wy-news-detail.dart';
import 'login/login.dart';
import 'login/regist.dart';
import 'home.dart';

void main() => runApp(MintApp());

class MintApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    'login': (context) => loginView(),
    'homeView': (contenxt) => homeView(),
    'wordDetail': (context) => wordDetail(),
    'articleDetail': (context) => articleDetail(),
    'wyArticleDetail': (context) => wyNewsList(),
    'wyNewsDetail': (contenxt) => wyNewsDetail(),
    'regist': (contenxt) => regist(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.redAccent,
      ),
      routes: routes,
      // home: Tabs(),
      home: loginView(),
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
