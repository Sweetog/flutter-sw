import 'package:app/@core/models/contact_model.dart';
import 'package:app/@core/models/inlet_model.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/util/http_util.dart';
import 'package:app/env.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class SiteService {
  static final _url = env.functionsUrl;
  static final _lg = Logger();

  static Future<String?> create(
      {required String name,
      required String address,
      required String state,
      required String zip,
      required ContactModel contact}) async {
    var functionName = 'site';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = {
      'name': name,
      'address': address,
      'state': state,
      'zip': zip,
      'contact': contact.toJson()
    };

    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.post(uri, headers: headers, body: json.encode(body));
      var jsonResp = json.decode(response.body);

      return jsonResp['id'];
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }

  static Future<void> update(
      {required String id,
      required String name,
      required String address,
      required String state,
      required String zip,
      required ContactModel contact}) async {
    var functionName = 'site';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = {
      'id': id,
      'name': name,
      'address': address,
      'state': state,
      'zip': zip,
      'contact': contact.toJson()
    };

    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode != 204)
        _lg.e('response not 204!: ${response.statusCode}');
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }

  static Future<void> updateInletsOrder(
      {required String id, required List<InletModel> inlets}) async {
    var functionName = 'site/inlets';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = {'id': id, 'inlets': inlets};

    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode != 204)
        _lg.e('response not 204!: ${response.statusCode}');
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }

  static Future<void> createInlet(
      {required siteId, required InletModel model}) async {
    _lg.d(siteId);
    var functionName = 'site/inlet';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = model.toJson();
    body['siteId'] = siteId;

    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.post(uri, headers: headers, body: json.encode(body));
      if (response.statusCode != 204)
        _lg.e('response not 204!: ${response.statusCode}');
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }

  static Future<void> updateInlet(
      {required siteId,
      required InletModel model,
      required int inletIndex}) async {
    var functionName = 'site/inlet';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = model.toJson();
    body['siteId'] = siteId;
    body['inletIndex'] = inletIndex;

    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode != 204)
        _lg.e('response not 204!: ${response.statusCode}');
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }

  static Future<List<JobModel>?> getAll() async {
    var functionName = 'sites';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var uri = Uri.parse(_url + '/$functionName');
      var response = await client.get(uri, headers: headers);

      List<dynamic> j = json.decode(response.body);
      List<JobModel> ret = [];

      for (var i = 0; i < j.length; i++) {
        var m = JobModel.fromJson(j[i]);
        ret.add(m);
      }

      return ret;
    } catch (e) {
      _lg.d('jobs get caught http exception');
      _lg.d(e);
    } finally {
      client.close();
    }
  }

  static Future<JobModel?> getSite(String id) async {
    var functionName = 'site';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var uri = Uri.parse(_url + '/$functionName?id=$id');
      var response = await client.get(uri, headers: headers);

      var jsonRes = json.decode(response.body);
      return JobModel.fromJson(jsonRes);
    } catch (e) {
      _lg.d('jobs get caught http exception');
      _lg.d(e);
    } finally {
      client.close();
    }
  }
}
