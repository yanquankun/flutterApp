import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mint_app/common/comfun.dart';
import 'dart:math';
import 'package:mint_app/httpService/login-http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:mint_app/httpService/file-http.dart';

class picsView extends StatefulWidget {
  @override
  _picsViewState createState() => _picsViewState();
}

class _picsViewState extends State<picsView> {
  List imgList = [];
  String userId = '';

  Future<http.Response> getSources(String userId) async {
    var data = null;
    imgList.clear();
    await getSourceByUserId(userId).then((res) => {
          data = convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
          if (res.statusCode == 200 && data['msg'] == 'success')
            {
              setState(() {
                if ((data['data'] as List).isNotEmpty) {
                  var type = null;
                  (data['data'] as List).forEach((value) => {
                        type = comfun().returnMediaFileType(value['name']),
                        if (type == 'picture')
                          {
                            value['type'] = type,
                            imgList.add(value),
                          }
                      });
                } else {
                  comfun().showCupertinoAlertDialog(
                    context: context,
                    title: '提示',
                    content: '暂无图片展示，请通过导航栏上传按钮上传图片',
                    sureText: '确定',
                  );
                }
              }),
            }
          else
            {
              Scaffold.of(context).removeCurrentSnackBar(),
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '资源获取失败，请联系APP管理员!',
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
                ),
              ),
              print('Request failed with status: ${res.statusCode}.'),
            }
        });
  }

  get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    await getSources(prefs.getString('userId') ?? '');
  }

  @override
  void initState() {
    get();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('图阁'),
          actions: [
            IconButton(
                icon: const Icon(Icons.upload_file),
                onPressed: () => {
                      uploadFile(),
                    }),
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: '退出',
              onPressed: () {
                comfun().removeShared();
                Navigator.popAndPushNamed(context, 'login');
              },
            ),
          ],
        ),
        body: imgList.isEmpty ? null : _content());
  }

  uploadFile() async {
    //allowedExtensions 文件选择 格式，可以设置更多，权限问题filepicker会帮你处理
    var files = await FilePicker.getMultiFile(
        type: FileType.custom, allowedExtensions: comfun().fileTypes);
    if (files.isNotEmpty) comfun().snakTip(context, '文件上传中，请耐心等待!', 2000000);
    files.forEach((file) {
      var fileName =
          file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
      print("上传文件地址：" + file.path);
      print("上传文件地址：" + fileName);
      comfun().snakTip(context, '文件上传中，请耐心等待!', 2000000);
      HttpReqUtil.getInstance()
          .uploadFiles(userId, file.path, fileName)
          .then((result) {
        print("返回数据：${result.toString()}");
      }).whenComplete(() {
        getSources(userId);
        comfun().snakTip(context, '$fileName 上传成功!', 2000);
        print("请求结束");
      }).catchError((err) {
        comfun().snakTip(context, '$fileName 上传失败，请稍后再次尝试!', 2000);
        print("请求报错:" + err.toString());
      });
    });
    // HttpReqUtil.getInstance().upload(files, userId).then((value) => null);
  }

  _content() {
    var rightList = [];
    var leftList = [];
    var flag = true;
    const margin = EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5);
    imgList.forEach((element) {
      if (flag)
        leftList.add(element);
      else
        rightList.add(element);
      flag = !flag;
    });
    print(leftList);
    print(rightList);
    return SingleChildScrollView(
        child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: _leftContent(leftList, margin),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: _rightContent(rightList, margin),
          ),
        )
      ],
    ));
  }

  List<Widget> _leftContent(lists, margin) {
    List list = [];
    bool flag = false;
    list = lists.map<Widget>((child) {
      flag = !flag;
      return Container(
          margin: margin,
          height: flag ? 220 : 180,
          decoration: BoxDecoration(
              color: Colors.primaries[Random().nextInt(18)],
              borderRadius: BorderRadiusDirectional.all(Radius.circular(15))),
          padding: EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () => {
              comfun().showPureModal(
                  context, child['name'], imgPaint(child['presignedUrl']),
                  barrierDismissible: true),
            },
            child: imgPaint(child['presignedUrl']),
          ));
    }).toList();
    return list;
  }

  List<Widget> _rightContent(lists, margin) {
    List list = [];
    bool flag = false;
    list = lists.map<Widget>((child) {
      flag = !flag;
      return Container(
          margin: margin,
          height: flag ? 190 : 230,
          decoration: BoxDecoration(
            color: Colors.primaries[Random().nextInt(18)],
            borderRadius: BorderRadiusDirectional.all(Radius.circular(15)),
          ),
          padding: EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () => {
              comfun().showPureModal(
                  context, child['name'], imgPaint(child['presignedUrl']),
                  barrierDismissible: true),
            },
            child: imgPaint(child['presignedUrl']),
          ));
    }).toList();
    return list;
  }

  Widget imgPaint(url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.maxFinite,
      gaplessPlayback: true, //防止重绘
    );
  }
}
