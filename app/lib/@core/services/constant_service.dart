import 'package:app/@core/util/http_util.dart';
import 'package:app/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class ConstantService {
  static final _url = env.functionsUrl;
  static final _lg = new Logger();

  static Future<List<String>?> inletTypes() async {
    var constants = await _get();
    if (constants == null) return null;

    List<dynamic> j = constants['inletTypes'];
    List<String> ret = [];

    for (var i = 0; i < j.length; i++) {
      ret.add(j[i]);
    }

    return ret;
  }

  static Future<Map<String, dynamic>?> _get() async {
    var functionName = 'constants';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var uri = Uri.parse(_url + '/$functionName');
      var response = await client.get(uri, headers: headers);

      if (response.body.isEmpty) {
        _lg.d('no response get: $functionName');
        return null;
      }

      return json.decode(response.body);
    } catch (e) {
      _lg.d('caught http exception');
      _lg.d(e);
      return null;
    } finally {
      client.close();
    }
  }
}
