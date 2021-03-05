import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../httpService/login-http.dart';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:mint_app/common/comfun.dart';

class wyNewsList extends StatefulWidget {
  final Object ch;
  wyNewsList({Key key, this.ch}) : super(key: key);

  @override
  _wyNewsListState createState() => _wyNewsListState();
}

class _wyNewsListState extends State<wyNewsList> {
  var ch = null;
  List articleLists = [];
  var offsetStart = 0;
  var offsetEnd = 10;
  bool isloading = false;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ch = super.widget.ch;
    print(ch);
    // this._getNews(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        offsetStart += 10;
        offsetEnd += 10;
        isloading = true;
        _getNews(offsetStart, offsetEnd);
      }
    });
  }

  //下拉刷新
  Future<void> _onRefresh() async {
    offsetStart = 0;
    offsetEnd = 10;
    await Future.delayed(Duration(milliseconds: 2000), () {
      articleLists.clear();
      _getNews(offsetStart, offsetEnd);
    });
  }

  _getNews(int offsetStart, int offsetEnd) {
    var data = null;
    getWangYiNews(ch['type'], ch['sourceId'], offsetStart, offsetEnd)
        .then((res) => {
              print(
                  convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes))),
              isloading = false,
              data =
                  convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
              if (res.statusCode == 200)
                {
                  print(data),
                  setState(() {
                    data[ch['sourceId']].forEach((element) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ch['cn_name'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: !articleLists.isEmpty
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: articleLists.length,
                itemBuilder: (context, index) {
                  return _news(articleLists[index]);
                },
                controller: _scrollController,
              ),
            )
          : comfun().getMoreWidgetState(_getNews, [offsetStart, offsetEnd]),
    );
  }

  Widget _news(article) {
    return Container(
      child: InkWell(
          onTap: () => Navigator.pushNamed(context, 'wyNewsDetail',
              arguments: {'docid': article['docid']}),
          child: Container(
            height: 170.0,
            padding: EdgeInsets.only(left: 5, right: 5), //给最外层添加padding
            margin: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(15)),
            ),
            child: (Row(
              // mainAxisAlignment:
              //     MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
              children: <Widget>[
                Expanded(
                  flex: article['imgsrc'] == null
                      ? 3
                      : 2, //这个item占据剩余空间的份数，因为总数为3，所以此处占据2/3
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, //子组件的在交叉轴的对齐方式为起点
                    // mainAxisAlignment:
                    //     MainAxisAlignment.spaceAround, //子组件在主轴的排列方式为两端对齐
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //   color: const Color(0xff6d999b),
                        // )),
                        width: double.infinity,
                        height: 70.0,
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
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          article['digest'] ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                      Container(
                        // padding:
                        // const EdgeInsets.only(right: 13.0, bottom: 5.0),
                        // decoration: BoxDecoration(
                        //     border: Border.all(
                        //   color: const Color(0xff6d999b),
                        // )),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, //子组件在主轴的排列方式为两端对齐
                            children: <Widget>[
                              Container(
                                child: Text(
                                  article['source'] ?? '无来源',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                article['ptime'] == null
                                    ? ''
                                    : article['ptime'].toString(),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: article['imgsrc'] == null ? 0 : 1,
                  child: Image.network(
                    article['imgsrc'] ?? '',
                    width: 100,
                    height: 100.0,
                    fit: BoxFit.cover,
                    gaplessPlayback: true, //防止重绘
                  ),
                ),
              ],
            )),
          )),
    );
  }
}
