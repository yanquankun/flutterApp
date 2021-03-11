import 'package:flutter/material.dart';
import 'package:mint_app/httpService/login-http.dart';
import 'package:mint_app/common/user.dart';
import 'package:mint_app/home.dart';

class loginView extends StatefulWidget {
  @override
  _loginViewState createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(
          "登录",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      )),
      body: InkWell(
        onTap: () => {
          // 隐藏返回按钮
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => homeView(),
            ),
          ),
          print(userGlobal.realUserInfo)
        },
        child: Center(child: Text('123')),
      ),
    );
  }
}
