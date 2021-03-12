import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:mint_app/common/user.dart';

final Map<String, Object> channelMap = {
  'toutiao': {
    'type': 'headline',
    'sourceId': 'T1348647853363',
    'cn_name': '头条',
  },
  'yule': {
    'type': 'list',
    'sourceId': 'T1348648517839',
    'cn_name': '娱乐',
  },
  'tiyu': {
    'type': 'list',
    'sourceId': 'T1348649079062',
    'cn_name': '体育',
  },
  'caijin': {
    'type': 'list',
    'sourceId': 'T1348648756099',
    'cn_name': '财经',
  },
  // 'fangchan': {
  //   'type': 'house',
  //   'sourceId': 'T1348648756099',
  //   'cn_name': '房产',
  // },
  'keji': {
    'type': 'list',
    'sourceId': 'T1348649580692',
    'cn_name': '科技',
  },
};

// 登录 获取token
Future<http.Response> login() async {
  var params = convert.jsonEncode(
      {'name': 'yanquankun', 'password': '123456', 'remember': 'true'});

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };

  var client = http.Client();
  return await client.post('http://内容接口环境/api/login',
      headers: requestHeaders, body: params);
  // if (response.statusCode == 200) {
  //   var jsonResponse = convert.jsonDecode(response.body);
  //   var token = jsonResponse['token'];
  //   print('http token is: $token.');
  // } else {
  //   print('Request failed with status: ${response.statusCode}.');
  // }
}

// 获取新闻详情
Future<http.Response> getNewsDetail(String id) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'token': userGlobal.token,
    'login-user-id': userGlobal.userInfo['id'],
    'sessionId': userGlobal.userInfo['sessionId'],
  };

  var url = 'http://内容接口环境/api/web/article/$id';
  var client = http.Client();
  return await client.get(url, headers: requestHeaders);
}

// 获取用户订阅资讯
Future<http.Response> getNews(int page) async {
  var params = convert.jsonEncode({
    'keyword': '',
    'page': 1,
    'size': 50,
    'classificationNodeId': 227,
    'ownerId': userGlobal.userInfo['orgId'],
  });

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'token': userGlobal.token,
    'login-user-id': userGlobal.userInfo['id'],
    'sessionId': userGlobal.userInfo['sessionId'],
  };

  var url =
      'http://内容接口环境/api/web/article/query?keyword=&page=$page&size=10&classificationNodeId=225&ownerId=${userGlobal.userInfo['orgId']}';

  var client = http.Client();
  return await client.get(url, headers: requestHeaders);
}

// 获取网易数据
Future<http.Response> getWangYiNews(
    String type, String sourceId, int offsetStart, int offsetEnd) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };

  var client = http.Client();
  var url =
      'http://c.m.163.com/nc/article/$type/$sourceId/$offsetStart-$offsetEnd.html';
  return await client.get(url, headers: requestHeaders);
}

// 获取网易新闻详情
Future<http.Response> getWYNewsDetail(String docId) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };

  var client = http.Client();
  var url = 'http://c.m.163.com/nc/article/$docId/full.html';
  return await client.get(url, headers: requestHeaders);
}

// 真实登录
Future<http.Response> realLogin(String username, String password) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };

  var client = http.Client();
  var url =
      'http://39.97.119.181:9400/user/loginUser?username=${username}&password=${password}';
  return await client.get(url, headers: requestHeaders);
}

// 注册
Future<http.Response> userRegist(String username, String password) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };

  var client = http.Client();
  var url =
      'http://39.97.119.181:9400/user/regis?username=${username}&password=${password}';
  return await client.get(url, headers: requestHeaders);
}

