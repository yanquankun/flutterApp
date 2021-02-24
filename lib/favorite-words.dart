import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class favoriteWords extends StatefulWidget {
  @override
  _favoriteWordsState createState() => _favoriteWordsState();
}

class _favoriteWordsState extends State<favoriteWords> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _pushSaved(_saved,_biggerFont,context) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
                trailing: new Icon(
                  //  添加一个心形 ❤️图标到 ListTiles以启用收藏功能
                  Icons.favorite,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    _saved.remove(pair);
                  });
                },
              );
            },
          );

          // ListTile 的 divideTiles() 方法在每个 ListTile 之间添加 1 像素的分割线
          // 该 divided 变量持有最终的列表项
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          // Navigator（导航器）会在应用栏中自动添加一个"返回"按钮，无需调用Navigator.pop，点击后退按钮就会返回到主页路由
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('单词收藏'),
            ),
            body: new ListView(children: divided),
            // bottomNavigationBar: BottomNavigationBar(
            //   items: [
            //     BottomNavigationBarItem(label: "首页", icon: Icon(Icons.home)),
            //     BottomNavigationBarItem(
            //         label: "地图", icon: Icon(Icons.recommend)),
            //     // BottomNavigationBarItem(label: "我的", icon: Icon(Icons.person))
            //   ],
            // ),
          );
        },
      ),
    );
  }
}


