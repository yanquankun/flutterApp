import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wy-news/wy-news.dart';
import '../words/random-words.dart';
import 'package:mint_app/media/mediaHome.dart';
import '../amap-navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class comfun {
  Widget getMoreWidgetState(
    Function cb,
    List args,
  ) {
    Function.apply(cb, args);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  void removeShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // 公共bottom tab
  getBottomTabs() {
    return [
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
    ];
  }

  // 对应tab body页面
  getPageList() {
    return [
      RandomWords(),
      mediaView(),
      wyNews(),
      amapNavigatePage('高德导航', '地图导航'),
    ];
  }

  showAlert(context, String title, Widget msgWidget,
      {String sureText, notText}) async {
    final css = TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700);
    await showDialog(
      context: context,
      barrierDismissible: false, // 点击外部不关闭
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: css),
          content: msgWidget,
          backgroundColor: Colors.lightBlueAccent,
          elevation: 24,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          actions: <Widget>[
            // ignore: deprecated_member_use
            notText != null
                ? FlatButton(
                    child: Text(notText),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                : null,
            // ignore: deprecated_member_use
            sureText != null
                ? FlatButton(
                    child: Text(sureText, style: css),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                : null,
          ],
        );
      },
    );
  }

  showCupertinoAlertDialog(
      {context, String title, String content, String sureText}) {
    showCupertinoDialog(
        context: context,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text(sureText),
                onPressed: () {
                  Navigator.pop(cxt, 2);
                },
              )
            ],
          );
        });
  }
}
