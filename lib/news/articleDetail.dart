import 'package:flutter/material.dart';
import '../httpService/login-http.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:mint_app/common/comfun.dart';

class articleDetail extends StatefulWidget {
  @override
  _articleDetailState createState() => _articleDetailState();
}

class _articleDetailState extends State<articleDetail> {
  String articleId = '';
  var artDetail = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _getNewsDetail(String id) {
    var data = null;
    getNewsDetail(id).then((res) => {
          data = convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
          if (res.statusCode == 200 && data['code'] == 200)
            {
              setState(() => {
                    artDetail = data['data'],
                  })
            }
          else
            {print('Request failed with status: ${res.statusCode}.')}
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    if (obj != null && obj['id'] != null) {
      articleId = obj['id'];
      print('id is:' + articleId);
    }
    return Scaffold(
      appBar: AppBar(
        // 跳转收藏页
        title: Text(
          "新闻详情",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: artDetail != null
          ? _content(artDetail)
          : comfun().getMoreWidgetState(_getNewsDetail, [articleId]),
    );
  }

  Widget _content(artDetail) {
    return Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
          color: const Color(0xff6d999b),
        )),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
            // 折行展示
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              GestureDetector(
                child: Title(
                    color: Colors.red,
                    child: Text(
                      artDetail['title'] ?? '暂无标题',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, //
                children: [
                  Text(artDetail['i_sn'] ?? ''),
                  Text(artDetail['push_time'] ?? '')
                ],
              ),
              Row(children: getImgs(artDetail['normal_pictures'] ?? [])),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  artDetail['cont'] ?? '暂无内容',
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> getImgs(List normal_pictures) {
    var imgs = <Widget>[];
    normal_pictures.forEach(
      (img) => imgs.add(
        Expanded(
          flex: 3,
          child: Image.memory(
            base64.decode(
              img.split(',')[1],
            ),
            height: 100.0,
            fit: BoxFit.cover,
            gaplessPlayback: true, //防止重绘
          ),
        ),
      ),
    );
    return imgs;
  }
}
