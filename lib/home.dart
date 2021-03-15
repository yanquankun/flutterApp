import 'package:flutter/material.dart';
import 'package:mint_app/common/comfun.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

final List<Permission> needPermissionList = [
  Permission.location,
  Permission.storage,
  Permission.phone,
  Permission.camera,
];

class homeView extends StatefulWidget {
  @override
  _homeViewState createState() => _homeViewState();
}

class _homeViewState extends State<homeView> {
  var response = null;
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

  @override
  Widget build(BuildContext context) {
    return tabs(context);
  }

  //选中的条目
  var _currentIndex = 0;

  @override
  Widget tabs(BuildContext context) {
    return Scaffold(
      body: comfun().getPageList()[this._currentIndex],
      floatingActionButton: _floatBtn(context),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.blue,
        currentIndex: this._currentIndex,
        items: [
          BottomNavigationBarItem(
              label: '单词推荐',
              tooltip: '随机单词推荐',
              icon: Icon(Icons.remove_red_eye, color: Colors.amber)),
          BottomNavigationBarItem(
              label: '音频',
              tooltip: '音阙诗听',
              icon: Icon(Icons.music_video, color: Colors.amber)),
          BottomNavigationBarItem(
              label: '新闻',
              tooltip: '网易新闻',
              icon: Icon(Icons.new_releases_outlined, color: Colors.amber)),
          BottomNavigationBarItem(
              label: '实时地图',
              tooltip: '高德地图',
              icon: Icon(Icons.maps_ugc_rounded, color: Colors.amber)),
        ],
        onTap: (value) {
          setState(() {
            this._currentIndex = value.toInt();
          });
        },
      ),
    );
  }

  // 悬浮按钮
  Widget _floatBtn(BuildContext context) {
    return InkWell(
      onTap: () => {
        Future.delayed(Duration(milliseconds: 200), () {
          final css = TextStyle(
              fontSize: 18,
              decoration: TextDecoration.underline,
              color: Colors.black,
              fontWeight: FontWeight.w700);
          setState(() {
            comfun().showAlert(
                context,
                '个人介绍：',
                Container(
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('闫全堃（Mint）',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 10),
                      InkWell(
                          child: Text(
                            '个人介绍（点击后跳转）',
                            style: css,
                          ),
                          onTap: () =>
                              launch('http://39.97.119.181/myself/index.html')),
                      SizedBox(height: 10),
                      InkWell(
                          child: Text('个人git（点击后跳转）', style: css),
                          onTap: () => launch('https://github.com/yanquankun')),
                      SizedBox(height: 10),
                      InkWell(
                          child: Text('个人AngularUI库（点击后跳转）', style: css),
                          onTap: () =>
                              launch('http://39.97.119.181/ng-mui/#/start')),
                    ],
                  ),
                ),
                sureText: '看完了呦~');
          });
        }),
      },
      child: Opacity(
        opacity: 0.6,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(30)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '关于我',
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
