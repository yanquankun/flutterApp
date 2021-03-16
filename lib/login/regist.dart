import 'package:flutter/material.dart';
import 'package:mint_app/httpService/login-http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 屏幕自适应
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // 第三方图标库
import 'package:mint_app/common/comfun.dart';
import 'dart:convert';
import 'package:mint_app/home.dart';
import 'package:mint_app/login/login.dart';

class regist extends StatefulWidget {
  @override
  _registState createState() => _registState();
}

class _registState extends State<regist> {
  // 焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();
  FocusNode _focusNodeRePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = ''; //用户名
  var _username = ''; //密码
  var _repassword = ''; //重复密码
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮

  Future<http.Response> registUser(String username, String password) async {
    var data = null;
    await userRegist(username, password).then((res) => {
          print(convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes))),
          data = convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
          if (res.statusCode == 200 && data['msg'] == '注册成功')
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => loginView(),
                ),
              ),
            }
          else
            {
              Scaffold.of(context).removeCurrentSnackBar(),
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    data['msg'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  duration: const Duration(milliseconds: 2000),
                  behavior: SnackBarBehavior.floating,
                  // action: SnackBarAction(
                  //   label: "Action",
                  //   onPressed: () {
                  //     // Code to execute.
                  //   },
                  // ),
                ),
              ),
              print('Request failed with status: ${res.statusCode}.'),
            }
        });
  }

  // 监听焦点
  Future<Null> _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      print('用户名框获取焦点');
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
      _focusNodeRePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
      _focusNodeRePassWord.unfocus();
    }
    if (_focusNodeRePassWord.hasFocus) {
      print("重复密码框获取焦点");
      // 取消重复密码框焦点状态
      _focusNodePassWord.unfocus();
      _focusNodeUserName.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    _focusNodeRePassWord.addListener(_focusNodeListener);

    //监听用户名框的输入改变
    _userNameController.addListener(() {
      print(_userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
  }

  /**
   * 验证用户名
   */
  String validateUserName(value) {
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value.isEmpty) {
      return '用户名不能为空!';
    }
    // else if (!exp.hasMatch(value)) {
    //   return '请输入正确手机号';
    // }
    return null;
  }

  /**
   * 验证密码
   */
  String validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 4 || value.trim().length > 18) {
      return '密码长度不正确';
    } else {
      _formKey.currentState.save();
    }
    return null;
  }

  /**
   * 验证重复密码
   */
  String validateRePassWord(value) {
    if (value.isEmpty) {
      return '重复密码不能为空';
    } else if (value != _password) {
      return '两次密码不一致';
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _focusNodeRePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // print(ScreenUtil().scaleHeight);

    // logo 图片区域
    Widget logoImageArea = Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          'assets/icon/launcher_icon.jpg',
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
    //输入文本框区域
    Widget inputTextArea = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: '用户名',
                hintText: '请输入用户名',
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          _userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value) {
                _username = value;
              },
            ),
            TextFormField(
              focusNode: _focusNodePassWord,
              decoration: InputDecoration(
                  labelText: '密码',
                  hintText: '请输入密码',
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )),
              obscureText: !_isShowPwd,
              //密码验证
              validator: validatePassWord,
              //保存数据
              onSaved: (String value) {
                _password = value;
              },
            ),
            TextFormField(
              focusNode: _focusNodeRePassWord,
              decoration: InputDecoration(
                  labelText: '确认密码',
                  hintText: '请再次输入密码',
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon(
                        (_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )),
              obscureText: !_isShowPwd,
              //密码验证
              validator: validateRePassWord,
              //保存数据
              onSaved: (String value) {
                _repassword = value;
              },
            )
          ],
        ),
      ),
    );

    // 注册按钮区域
    Widget loginButtonArea = Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45.0,
      child: RaisedButton(
        color: Colors.blue[300],
        child: Text(
          '注册',
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        // 设置按钮圆角
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
          _focusNodeRePassWord.unfocus();

          if (_formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState.save();
            //todo 登录操作
            registUser(_username, _password);
            print('$_username:$_password:$_repassword');
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: GestureDetector(
        onTap: () {
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
          _focusNodeRePassWord.unfocus();
        },
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(80),
            ),
            logoImageArea,
            SizedBox(
              height: ScreenUtil().setHeight(70),
            ),
            inputTextArea,
            SizedBox(
              height: ScreenUtil().setHeight(80),
            ),
            loginButtonArea,
          ],
        ),
      ),
    );
  }
}
