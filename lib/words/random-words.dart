import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

var _saved = new Set<WordPair>();

class wordDetail extends StatefulWidget {
  @override
  _wordDetailState createState() => _wordDetailState();
}

class _wordDetailState extends State<wordDetail> {
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final tiles = _saved.map(
      (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: Icon(
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
    final List<Widget> divided =
        ListTile.divideTiles(context: context, tiles: tiles).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('单词收藏'),
      ),
      body: ListView(children: divided),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  // 集合存储用户喜欢（收藏）的单词对
  // final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 跳转收藏页
        title: Text(
          "随机单词推荐",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.list), onPressed: _pushed),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: '退出',
            onPressed: () {
              Navigator.popAndPushNamed(context, 'login');
            },
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushed() {
    Navigator.pushNamed(context, 'wordDetail').then((value) => {
          setState(() {
            _buildSuggestions();
          }),
        });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次 itemBuilder，然后将单词对添加到 ListTile 行中。在偶数行，该函数会为单词对添加一个 ListTile row，在奇数行，该函数会添加一个分割线的 widget，来分隔相邻的词对
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线 widget
          if (i.isOdd) return Divider();

          // 语法 i ~/ 2 表示 i 除以 2，但返回值是整形（向下取整），比如 i 为：1, 2, 3, 4, 5 时，结果为 0, 1, 1, 2, 2，这个可以计算出 ListView 中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            // 如果是建议列表中最后一个单词对，接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    // 检查确保单词对还没有添加到收藏夹中
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        //  添加一个心形 ❤️图标到 ListTiles以启用收藏功能
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        // 收藏功能 icon点击事件
        // 调用 setState() 会为 State 对象触发 build() 方法，从而导致对 UI 的更新
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
