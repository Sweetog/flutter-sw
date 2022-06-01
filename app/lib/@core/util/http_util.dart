import 'dart:io';
import 'package:app/@core/util/auth_util.dart';

class HttpUtil {
  static Future<Map<String, String>> getHeaders() async {
    var token = await AuthUtil.getBearerToken();
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
  }
}
