import 'package:app/@core/models/contact_model.dart';
import 'package:app/@core/models/inlet_model.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/util/http_util.dart';
import 'package:app/env.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class JobService {
  static final _url = env.functionsUrl;
  static final _lg = new Logger();

  static Future<JobModel?> getJob(String id) async {
    var functionName = 'job';
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

  static Future<String?> create({
    required String siteId,
  }) async {
    var functionName = 'job';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = {'siteId': siteId};

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

  static Future<String?> createFromImport(
      {required String siteId,
      required String name,
      required String address,
      required String state,
      required String zip,
      DateTime? date,
      required String? route,
      required ContactModel? contact,
      required String? serviceCode,
      required String? serviceNote}) async {
    var functionName = 'job/import';
    var uri = Uri.parse(_url + '/$functionName');
    final client = http.Client();

    final body = {
      'siteId': siteId,
      'name': name,
      'address': address,
      'state': state,
      'zip': zip,
      'startDate': date?.toIso8601String(),
      'contact': contact?.toJson(),
      'Route': route,
      'serviceNote': serviceNote,
      'serviceCode': serviceCode,
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

  static Future<void> updateStatus(
      {required String id, required String status}) async {
    var functionName = 'job';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = {'id': id, 'status': status};

    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.put(uri, headers: headers, body: json.encode(body));
      if (response.statusCode != 200)
        _lg.e('response not 200!: ${response.statusCode}');
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }

  static Future<String?> delete({required String id}) async {
    var functionName = 'job';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = {'id': id};

    try {
      var headers = await HttpUtil.getHeaders();
      var response =
          await client.delete(uri, headers: headers, body: json.encode(body));
      if (response.statusCode != 204)
        _lg.e('response not 204!: ${response.statusCode}');
    } catch (e) {
      print('caught http exception');
      print(e);
    } finally {
      client.close();
    }
  }

  static Future<List<JobModel>?> getJobs() async {
    var functionName = 'jobs';
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

  static Future<List<JobModel>?> getJobsIncomplete() async {
    var functionName = 'jobs/incomplete';
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

  static Future<List<JobModel>?> getJobsBySite(String id) async {
    var functionName = 'jobs/site';
    var client = http.Client();
    try {
      var headers = await HttpUtil.getHeaders();
      var uri = Uri.parse(_url + '/$functionName?id=$id');
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

  static Future<void> updateInlet(
      {required jobId,
      required InletModel model,
      required int inletIndex}) async {
    var functionName = 'job/inlet';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = model.toJson();
    body['jobId'] = jobId;
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

  static Future<void> updateInletsOrder(
      {required String id, required List<InletModel> inlets}) async {
    var functionName = 'job/inlets';
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
      {required jobId, required InletModel model}) async {
    _lg.d(jobId);
    var functionName = 'job/inlet';
    var uri = Uri.parse(_url + '/$functionName');
    var client = http.Client();

    var body = model.toJson();
    body['jobId'] = jobId;

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
}
