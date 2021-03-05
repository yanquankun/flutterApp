import 'package:flutter/material.dart';
import '../httpService/login-http.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:mint_app/common/comfun.dart';

class wyNewsDetail extends StatefulWidget {
  @override
  _wyNewsDetailState createState() => _wyNewsDetailState();
}

class _wyNewsDetailState extends State<wyNewsDetail> {
  var artDetail = null;
  var docId = null;

  _getWyNewsDetail(String docid) {
    var data = null;
    getWYNewsDetail(docid).then((res) => {
          data = convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
          if (res.statusCode == 200)
            {
              setState(() => {
                    artDetail = data[docid],
                    artDetail['body'] = artDetail['body']
                        .toString()
                        .replaceAll(RegExp(r'<\/p><p>'), '\n')
                        .replaceAll(
                            RegExp(r'<!\--IMG#[1-9][0-9]{0,}-->'), 'picture')
                        .replaceAll(RegExp(r'<[^>]+>'), ''),
                    getWidgetSpan(artDetail['body'], artDetail['img']),
                  })
            }
          else
            {print('Request failed with status: ${res.statusCode}.')}
        });
  }

  // 新闻解析body文本，使用WidgetSpan将图片和文本结合
  List<InlineSpan> ws = [];
  getWidgetSpan(String str, List imgs) {
    var idx = 0;
    // str.replaceAllMapped(r'[picture]', (match) => match.start=idx.toString());
    str.split('picture').forEach((element) {
      ws.addAll([
        WidgetSpan(
            child: SizedBox(
          child: Text(element),
        )),
        WidgetSpan(
            child: SizedBox(
          child: imgs.length != 0
              ? Image.network(
                  imgs[idx]['src'] ?? '',
                  fit: BoxFit.cover,
                )
              : Text(''),
        )),
      ]);
      idx++;
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic obj = ModalRoute.of(context).settings.arguments;
    if (obj != null && obj['docid'] != null) {
      docId = obj['docid'];
      print('docid is:' + docId);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '网易新闻',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: artDetail != null
            ? _content(artDetail)
            : new comfun()
                .getMoreWidgetState(_getWyNewsDetail, [obj['docid']]));
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
                  Text(artDetail['source'] ?? ''),
                  Text(artDetail['ptime'] ?? '')
                ],
              ),
              Text(
                '关键词：' + artDetail['dkeys'],
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              // Column(
              //   children: getImgs(artDetail['img']),
              // ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  artDetail['headText'] ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.only(top: 10),
              //   child: Text(
              //     artDetail['body'] ?? '',
              //   ),
              // ),
              Text.rich(TextSpan(
                children: ws,
              ))
            ],
          ),
        ));
  }

  List<Widget> getImgs(List normal_pictures) {
    var imgs = <Widget>[];
    normal_pictures.forEach(
      (img) => imgs.add(
        Center(
          child: Image.network(
            img['src'],
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
