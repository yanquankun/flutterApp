import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:mint_app/common/user.dart';

// 登录 获取token
Future<http.Response> login() async {
  var params = convert.jsonEncode(
      {'name': 'yanquankun', 'password': '123456', 'remember': 'true'});

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
  };

  var client = http.Client();
  return await client.post('http://117.160.193.18:8071/api/login',
      headers: requestHeaders, body: params);
  // if (response.statusCode == 200) {
  //   var jsonResponse = convert.jsonDecode(response.body);
  //   var token = jsonResponse['token'];
  //   print('http token is: $token.');
  // } else {
  //   print('Request failed with status: ${response.statusCode}.');
  // }
}

// 获取用户订阅资讯
Future<http.Response> getNews() async {
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

  var url = 'http://117.160.193.18:8071/api/web/article/query?keyword=&page=1&size=50&classificationNodeId=225&ownerId=${userGlobal.userInfo['orgId']}';

  var client = http.Client();
  return await client.get(url,
      headers: requestHeaders);
}
