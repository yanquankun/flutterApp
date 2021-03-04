import 'package:flutter/material.dart';
import '../httpService/login-http.dart';
import 'wy-news-list.dart';

class wyNews extends StatefulWidget {
  @override
  _wyNewsState createState() => _wyNewsState();
}

class _wyNewsState extends State<wyNews> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "网易新闻分类",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: _buildWYNews(),
    );
  }

  Widget _buildWYNews() {
    return ListView.builder(
      itemCount: channelMap.length,
      itemBuilder: (context, index) {
        return _channelList(channelMap.values.elementAt(index));
      },
    );
  }

  Widget _channelList(channel) {
    return Container(
        height: 60.0,
        margin: EdgeInsets.only(
          top: 20,
        ),
        padding: EdgeInsets.only(
            top: 10, left: 20, right: 20, bottom: 10), //给最外层添加padding
        decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadiusDirectional.all(Radius.circular(30))),
        child: InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => wyNewsList(ch: channel),
              ),
            ),
            // Navigator.pushNamed(context, 'wyArticleDetail',
            //     arguments: {'ch': channel})
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                    child: Text(
                  channel['cn_name'] + '  新闻栏目',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900),
                )),
              )
            ],
          ),
        ));
  }
}
