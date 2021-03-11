import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';

class userGlobal {
  static String token = '';
  static Map<String, String> userInfo = {
    'groupId': '',
    'id': '',
    'orgId': '',
    'userName': '',
    'sessionId': '',
  };
  static Map<String, String> realUserInfo = {
    'guid': '',
    'id': '',
    'email': '',
    'phone': '',
    'birthday': '',
  };
}

class userModel extends ChangeNotifier {
  final _token = userGlobal.token;

  String get token => _token;
}
