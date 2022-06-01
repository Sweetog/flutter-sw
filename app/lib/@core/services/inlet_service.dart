import 'package:app/@core/models/inlet_model.dart';
import 'package:app/@core/util/http_util.dart';
import 'package:app/env.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class InletService {
  static final _url = env.functionsUrl;
  static final _lg = Logger();
}
