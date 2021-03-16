import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:mint_app/common/comfun.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:mint_app/httpService/login-http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mint_app/httpService/file-http.dart';
import 'package:path_provider/path_provider.dart';

class mediaView extends StatefulWidget {
  @override
  _mediaViewState createState() => _mediaViewState();
}

class _mediaViewState extends State<mediaView> {
  final FijkPlayer player = FijkPlayer();
  var sourceList = [];
  var userId = '';

  Future<http.Response> getSources(String userId) async {
    var data = null;
    sourceList.length = 0;
    await getSourceByUserId(userId).then((res) => {
          data = convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
          if (res.statusCode == 200 && data['msg'] == 'success')
            {
              setState(() {
                if ((data['data'] as List).isNotEmpty) {
                  var type = null;
                  (data['data'] as List).forEach((value) => {
                        type = comfun().returnMediaFileType(value['name']),
                        if (type == 'video' || type == 'radio')
                          {
                            value['type'] = type,
                            sourceList.add(value),
                          }
                      });
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
    super.initState();
    get();
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('音阙诗听'),
        automaticallyImplyLeading: false, // 不显示返回按钮
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.cloud_upload),
        //     tooltip: '上传',
        //     onPressed: () {
        //       print('upload');
        //     },
        //   ),
        // ],
      ),
      body: !sourceList.isEmpty
          ? ListView.builder(
              itemCount: sourceList.length + 1,
              itemBuilder: (context, index) {
                return index <= sourceList.length - 1
                    ? _content(context, sourceList[index])
                    : _upload();
              },
            )
          : comfun().getMoreWidgetState(null, null),
    );
  }

  final fontStyle = TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

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

  Widget _upload() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      // ignore: deprecated_member_use
      child: RaisedButton(
        child: Text(
          '上传',
          style: fontStyle,
        ),
        color: Colors.blue,
        highlightColor: Colors.blueAccent,
        onPressed: () {
          uploadFile();
        },
      ),
    );
  }

  Widget _content(context, source) {
    return Container(
      child: InkWell(
          onTap: () => {
                player.setDataSource(source['presignedUrl'], autoPlay: true),
                comfun().showAlert(
                    context,
                    source['name'],
                    Container(
                        width: double.infinity,
                        child: FijkView(
                          player: player,
                          width: double.maxFinite,
                          fit: FijkFit(
                            sizeFactor: 1.0,
                            aspectRatio: -1,
                            alignment: Alignment.center,
                          ),
                          height: 300,
                          color: Colors.lightBlueAccent,
                        )),
                    notText: '关闭',
                    notFun: () => {
                          player.reset(),
                        }),
              },
          child: Container(
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.only(left: 5, right: 5),
            margin: EdgeInsets.only(right: 2, left: 2, top: 3, bottom: 3),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadiusDirectional.all(Radius.circular(5)),
            ),
            child: (Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Text(
                    source['name'],
                    style: fontStyle,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.arrow_downward),
                    color: Colors.white,
                    tooltip: '下载${source['name']}',
                    onPressed: () => {
                      _download(source['name'], source['presignedUrl']),
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.redAccent,
                    tooltip: '删除${source['name']}',
                    onPressed: () => {
                      comfun().showCupertinoAlertDialog(
                          context: context,
                          title: '删除',
                          content: '确定要删除${source['name']}吗？',
                          sureText: '确定',
                          notText: '取消',
                          sureFun: () => {
                                _delete(source['name']),
                              })
                    },
                  ),
                ),
              ],
            )),
          )),
    );
  }

  void _download(String fileName, String urlPath) async {
    var resUrl = urlPath;

    await getTemporaryDirectory().then((result) {
      print('临时存放路径为：${result.path}');
      //获取临时存放路径
      HttpReqUtil.getInstance()
          .downloadFile(resUrl, result.path + "/download-$fileName");
    });
  }

  void _delete(String fileName) async {
    print(fileName);
    print(userId);
    var data = null;
    await deleteFileByUserId(userId, fileName).then((res) => {
          data = convert.jsonDecode(new Utf8Decoder().convert(res.bodyBytes)),
          if (res.statusCode == 200 && data['code'] == 200)
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
                ),
              ),
              getSources(userId),
            }
          else
            {
              Scaffold.of(context).removeCurrentSnackBar(),
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '删除失败，请联系APP管理员!',
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
}
