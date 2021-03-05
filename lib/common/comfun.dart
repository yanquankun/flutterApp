import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../wy-news/wy-news.dart';
import '../words/random-words.dart';
import '../news/news.dart';
import '../amap-map.dart';
import '../amap-navigation.dart';

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
      newsPage(),
      wyNews(),
      amapNavigatePage('高德导航', '地图导航'),
      Amapofficial()
    ];
  }

  showAlert([String message = '暂无数据']) async {
    await AlertDialog(
      title: Text('提示'),
      content: Text(message),
      backgroundColor: Colors.redAccent,
      elevation: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      // actions: <Widget>[
      //   FlatButton(
      //     child: Text('取消'),
      //     onPressed: () {},
      //   ),
      //   FlatButton(
      //     child: Text('确认'),
      //     onPressed: () {},
      //   ),
      // ],
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
