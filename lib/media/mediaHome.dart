import 'package:flutter/material.dart';

class mediaView extends StatefulWidget {
  @override
  _mediaViewState createState() => _mediaViewState();
}

class _mediaViewState extends State<mediaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音阙诗听'),
        automaticallyImplyLeading: false, // 不显示返回按钮
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: '退出',
            onPressed: () {
              Navigator.popAndPushNamed(context, 'login');
            },
          ),
        ],
      ),
      bottomNavigationBar: tabs(),
      body: Center(
        child: Text('音阙诗听'),
      ),
    );
  }

  Widget tabs(){

  }

}
