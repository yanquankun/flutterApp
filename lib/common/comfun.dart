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
    if (cb != null) Function.apply(cb, args);
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
      {String sureText, notText, Function notFun}) async {
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
                    child: Text(notText, style: css),
                    onPressed: () {
                      if (notFun != null) {
                        Function.apply(notFun, null);
                      }
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

  showCupertinoAlertDialog({
    context,
    String title,
    String content,
    String sureText,
    String notText,
    Function sureFun,
  }) {
    showCupertinoDialog(
        context: context,
        builder: (cxt) {
          return CupertinoAlertDialog(
            title: Text(title ?? '默认标题'),
            content: Text(content ?? '默认内容'),
            actions: [
              CupertinoDialogAction(
                child: Text(notText ?? '取消'),
                onPressed: () {
                  Navigator.pop(cxt, 2);
                },
              ),
              CupertinoDialogAction(
                child: Text(sureText ?? '确定'),
                onPressed: () {
                  if (sureFun != null) {
                    Function.apply(sureFun, null);
                  }
                  Navigator.pop(cxt, 2);
                },
              )
            ],
          );
        });
  }

  final List<String> fileTypes = [
    'mp3',
    'mp4',
    'm2v',
    'mkv',
    'rmvb',
    'wmv',
    'avi',
    'flv',
    'mov',
    'm4v',
    'png',
    'jpg',
    'jpeg',
    'bmp',
    'gif',
    'webp',
    'psd',
    'svg',
    'tiff',
    'txt',
    'xls',
    'xlsx',
    'doc',
    'docx',
    'pdf',
    'ppt',
    'pptx'
  ];

  String returnMediaFileType(String filename) {
    final fileNameList = filename.split('.');
    final type = fileNameList[fileNameList.length - 1];
    final videos = 'mp4,m2v,mkv,rmvb,wmv,avi,flv,mov,m4v'.split(',');
    final radios = ['mp3'];
    final pictures = 'png,jpg,jpeg,bmp,gif,webp,psd,svg,tiff'.split(',');
    final documents = 'txt,xls,xlsx,doc,docx,pdf,ppt,pptx'.split(',');
    if (videos.contains(type)) {
      return 'video';
    } else if (radios.contains(type)) {
      return 'radio';
    } else if (pictures.contains(type)) {
      return 'picture';
    } else if (documents.contains(type)) return 'document';
  }

  snakTip(context, String title, int time) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: new Duration(milliseconds: time),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
