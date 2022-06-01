import 'package:app/@core/models/user_model.dart';
import 'package:app/@core/util/http_util.dart';
import 'package:app/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

enum UserStatus {
  UserCreated,
  UserCreationError,
  UserClaimCreated,
  UserClaimCreationErrorS
}

class UserService {
  static final _url = env.functionsUrl;
  static final _lg = new Logger();

  static Future<UserStatus> createUser(
      String name, String email, String password, String role) async {
    var functionName = 'user';
    var client = http.Client();
    var body = {
      'name': name,
      'email': email,
      'password': password,
      'role': role
    };
    try {
      _lg.d('user post request body: $body');
      var headers = await HttpUtil.getHeaders();
      var uri = Uri.parse(_url + '/$functionName');
      var response =
          await client.post(uri, headers: headers, body: json.encode(body));
      _lg.d('user post response: ${response.body}');
      return UserStatus.UserCreated;
    } catch (e) {
      _lg.d('caught http exception');
      _lg.d(e);
      return UserStatus.UserCreationError;
    } finally {
      client.close();
    }
  }

  static Future<UserModel?> getUser(String uid) async {
    var functionName = 'user';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var uri = Uri.parse(_url + '/$functionName?uid=$uid');
      var response = await client.get(uri, headers: headers);

      if (response.body.isEmpty) {
        _lg.d('no response get user');
        return null;
      }

      var jsonRes = json.decode(response.body);
      return UserModel.fromJson(jsonRes);
    } catch (e) {
      _lg.d('caught http exception');
      _lg.d(e);
      return null;
    } finally {
      client.close();
    }
  }
}
