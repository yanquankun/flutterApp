import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common/user.dart';
import 'dart:convert' as convert;
import 'httpService/login-http.dart';
import 'dart:convert';

class newsPage extends StatefulWidget {
  @override
  _newsPageState createState() => _newsPageState();
}

class _newsPageState extends State<newsPage> {
  List articleLists = [];

  void _getNews() {
    var data = null;
    getNews().then((res) => {
          print(convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes))),
          data = convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
          if (res.statusCode == 200 && data['code'] == 200)
            {
              setState(() {
                data['data']['articleLists'].forEach((element) {
                  element['publishTime'] = DateTime.fromMillisecondsSinceEpoch(
                          element['publishTime'])
                      .toString()
                      .substring(0, 10);
                  articleLists.add(element);
                });
                print(articleLists);
                print(articleLists.length);
              }),
            }
          else
            {print('Request failed with status: ${res.statusCode}.')}
        });
  }

  @override
  void initState() {
    print(userGlobal.token);
    userGlobal.userInfo.forEach((key, value) {
      print('$key:$value');
    });
    this._getNews();
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 2000), () {
      print('请求数据完成');
      _getNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新闻资讯'),
        ),
        body: !articleLists.isEmpty
            ? RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: articleLists.length,
                  itemBuilder: (context, index) {
                    return _news(articleLists[index]);
                  },
                ),
              )
            : _getMoreWidget());
  }

  //加载中的圈圈
  Widget _getMoreWidget() {
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

  Widget _news(article) {
    return Container(
      child: Container(
        height: 140.0,
        padding: EdgeInsets.only(left: 20, right: 20), //给最外层添加padding
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.red, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
          children: <Widget>[
            Expanded(
              flex: article['smallPicture'] == null
                  ? 3
                  : 2, //这个item占据剩余空间的份数，因为总数为3，所以此处占据2/3
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //子组件的在交叉轴的对齐方式为起点
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, //子组件在主轴的排列方式为两端对齐
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 15.0), //标题写一个top-padding
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //   color: const Color(0xff6d999b),
                    // )),
                    width: double.infinity,
                    height: 60.0,
                    margin: EdgeInsets.only(bottom: 0),
                    child: Text(
                      article['title'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Container(
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //   color: const Color(0xff6d999b),
                    // )),
                    width: double.infinity,
                    child: Text(
                      article['zhTitle'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 13.0, bottom: 5.0),
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //   color: const Color(0xff6d999b),
                    // )),
                    child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, //子组件在主轴的排列方式为两端对齐
                        children: <Widget>[
                          Text(
                            article['source'] ?? '无来源',
                            maxLines: 1,
                          ),
                          Text(
                            article['publishTime'] == null
                                ? ''
                                : article['publishTime'].toString(),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: article['smallPicture'] == null ? 0 : 1,
              child: Image.memory(
                base64.decode(
                  article['smallPicture'] == null
                      ? ''
                      : article['smallPicture'].split(',')[1],
                ),
                height: 100.0,
                fit: BoxFit.cover,
                gaplessPlayback: true, //防止重绘
              ),
            ),
          ],
        ),
      ),
    );
  }
}
