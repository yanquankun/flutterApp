import 'package:flutter/material.dart';

class articleDetail extends StatefulWidget {
  @override
  _articleDetailState createState() => _articleDetailState();
}

class _articleDetailState extends State<articleDetail> {
  String articleId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    if (obj != null && obj['id']!=null) {
      articleId = obj['id'];
    }
    print('id is:'+articleId);
    return Scaffold(
      appBar: AppBar(
        // 跳转收藏页
        title: Text(
          "新闻详情页",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: (Text("12")),
      ),
    );
  }
}
