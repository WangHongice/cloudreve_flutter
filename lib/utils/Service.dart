import 'dart:io';

import 'package:cloudreve/utils/HttpUtil.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

/// 新建目录
Future<Response> addDirectory(dynamic data) {
  return HttpUtil.dio.put("/api/v3/directory", data: data);
}

/// 通过用户[id]获取头像缩略图
Future<Response> avatar(String id) {
  return HttpUtil.dio.get("/api/v3/user/avatar/$id/l",
      options: Options(responseType: ResponseType.bytes));
}

/// 通过[fileId]或者[dirs]删除文件或目录
Future<Response> deleteItem(List<String> dirs, List<String> fileId) async {
  return HttpUtil.dio
      .delete("/api/v3/object", data: {"dirs": dirs, "items": fileId});
}

/// 退出登录
Future<Response> deleteSession() {
  return HttpUtil.dio.delete("/api/v3/user/session");
}

/// 通过当前路径[path]获取文件列表
Future<Response> directory(String path) {
  return HttpUtil.dio.get('/api/v3/directory$path');
}

/// 通过[fileId]获取下载路径
Future<Response> getDownloadUrl(String fileId) async {
  return HttpUtil.dio.put("/api/v3/file/download/$fileId");
}

/// 通过[downloadUrl]获取图片
Future<Response> getImage(String downloadUrl) async {
  return HttpUtil.dio
      .get(downloadUrl, options: Options(responseType: ResponseType.bytes));
}

/// 通过[fileId]获取缩略图
Future<Response> getThumb(String fileId) async {
  return await HttpUtil.dio.get("/api/v3/file/thumb/$fileId",
      options: Options(responseType: ResponseType.bytes));
}

/// 注册
/// [userName]用户名
/// [password]密码
Future<Response> register(String userName, String password) {
  return HttpUtil.dio.post("/api/v3/user",
      data: {'userName': userName, 'Password': password, 'captchaCode': ''});
}

/// 登录
/// [userName]用户名
/// [password]密码
Future<Response> session(String userName, String password) {
  return HttpUtil.dio.post("/api/v3/user/session",
      data: {'userName': userName, 'Password': password, 'captchaCode': ''});
}

/// 获取用户容量
Future<Response> getStorage() {
  return HttpUtil.dio.get("/api/v3/user/storage");
}

/// 上传文件
/// [file]具体文件
/// [path]路径
/// [onSendProgress]上传回调函数
Future<Response> uploadFile(
    PlatformFile file, String path, void Function(int, int) onSendProgress) {
  var option = Options(
      method: "POST",
      contentType: "application/octet-stream",
      headers: {
        "x-filename": Uri.encodeComponent(file.name),
        "x-path": Uri.encodeComponent(path),
        HttpHeaders.contentLengthHeader: file.size
      },
      sendTimeout: 100000);
  return HttpUtil.dio.post("/api/v3/file/upload",
      options: option, data: file.readStream, onSendProgress: (process, total) {
    onSendProgress(process, total);
  });
}

/// 获取webdav数据
Future<Response> webdav() {
  return HttpUtil.dio.get("/api/v3/webdav/accounts");
}

/// 获取设置
Future<Response> setting() {
  return HttpUtil.dio.get("/api/v3/user/setting");
}

Future<Response> newShare(
    {required String fileId,
    required bool isDir,
    required String password,
    required bool preview,
    required int downloads,
    required int expive}) {
  return HttpUtil.dio.post("/api/v3/share", data: {
    "id": fileId,
    "is_dir": isDir,
    "password": password,
    "preview": preview,
    "downloads": downloads,
    "expive": expive
  });
}

Future<Response> getShare(
    {int page = 1, required String order, required String orderBy}) {
  return HttpUtil.dio.get("/api/v3/share",
      queryParameters: {"page": page, "order": order, "order_by": orderBy});
}

Future<Response> editShare(String key,
    {required String prop, required dynamic value}) {
  return HttpUtil.dio
      .patch("/api/v3/share/$key", data: {"prop": prop, "value": value});
}

Future<Response> deleteShare(String key) {
  return HttpUtil.dio.delete("/api/v3/share/$key");
}

Future<Response> renameObjects(
    String newName, List<String> dirs, List<String> items) {
  return HttpUtil.dio.post("/api/v3/object/rename", data: {
    "action": "rename",
    "new_name": newName,
    "src": {
      "dirs": dirs,
      "items": items,
    },
  });
}

Future<Response> search(String keyword) {
  return HttpUtil.dio.get("/api/v3/file/search/keywords/$keyword");
}
