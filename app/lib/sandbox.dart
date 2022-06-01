import 'package:app/@core/ui-components/progress_indicator.dart';
import 'package:app/screens/account/account.dart';
import 'package:app/screens/account/logout.dart';
import 'package:app/screens/loading.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(_buildApp());
}

Widget _buildApp() {
  return MaterialApp(
    title: 'Sandbox',
    home: Sandbox(),
  );
}

class Sandbox extends StatefulWidget {
  Sandbox({Key? key}) : super(key: key);

  @override
  _SandboxState createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Account(),
    );
  }
}
