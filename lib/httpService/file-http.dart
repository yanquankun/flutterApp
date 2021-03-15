import 'package:http/http.dart' as http;
import 'package:file/file.dart';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:common_utils/common_utils.dart';

class HttpReqUtil {
  Dio dio = null;

  HttpReqUtil._() {
    dio = new Dio();
    // 添加拦截器
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("\n================== 请求数据 ==========================");
      print("url = ${options.uri.toString()}");
      print("headers = ${options.headers}");
      print("params = ${options.data}");
    }, onResponse: (Response response) {
      print("\n================== 响应数据 ==========================");
      print("code = ${response.statusCode}");
      print("data = ${response.data}");
      print("\n");
    }, onError: (DioError e) {
      print("\n================== 错误响应数据 ======================");
      print("type = ${e.type}");
      print("message = ${e.message}");
      print("stackTrace = ${e.error}");
      print("\n");
    }));
  }

  static HttpReqUtil dbUtils;

  static HttpReqUtil getInstance() {
    if (null == dbUtils) dbUtils = HttpReqUtil._();
    return dbUtils;
  }

  Future<Response> getData(String url) async {
    return await dio.get(url);
  }

  Future<Response> postForm(String url, Map<String, Object> params) async {
    var option = Options(
        method: "POST", contentType: "application/x-www-form-urlencoded");
    return await dio.post(url, data: params, options: option);
  }

  Future<Response> postJson(String url, Map<String, Object> params) async {
    var option = Options(method: "POST", contentType: "application/json");
    return await dio.post(url, data: params, options: option);
  }

  /**
   * 上传文件
   * 注：file是服务端接受的字段字段，如果接受字段不是这个需要修改
   */
  Future<Response> uploadFiles(
      String userId, String filePath, String fileName) async {
    var postData = FormData.fromMap({
      "files": await MultipartFile.fromFile(filePath, filename: fileName),
      "userId": userId
    });
    var option = Options(
        method: "POST",
        contentType: "multipart/form-data"); //上传文件的content-type 表单
    return await dio.post(
      'http://39.97.119.181:9400/minio/uploadByUserId',
      data: postData,
      options: option,
      // onSendProgress: (int sent, int total) {
      //   print("上传进度：" +
      //       NumUtil.getNumByValueDouble(sent / total * 100, 2)
      //           .toStringAsFixed(2) +
      //       "%"); //取精度，如：56.45%
      // },
    );
  }

  /**
   * 下载文件
   */
  Future<Response> downloadFile(String resUrl, String savePath) async {
    // 相对路劲
    return await dio.download(resUrl, savePath,
        onReceiveProgress: (int loaded, int total) {
      print("下载进度：" +
          NumUtil.getNumByValueDouble(loaded / total * 100, 2)
              .toStringAsFixed(2) +
          "%"); //取精度，如：56.45%
    });
  }

  Future<http.Response> upload(fileList, String userId) async {
    FormData formData = FormData();
    FormData.fromMap({'files': fileList, 'userId': userId});
    print(formData.readAsBytes());

    // for (int i = 0; i < fileList.length; i++) {
    //   formData.files.add(MapEntry(
    //       "file", await MultipartFile.fromFile(fileList[i].path.toString())));
    //       "file", await MultipartFile.fromFile(fileList[i].path.toString())));
    // }

    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
    };

    var client = http.Client();
    return await client.post('http://localhost:3000/minio/uploadByUserId',
        headers: requestHeaders, body: formData);
  }
}
