import 'package:app/@core/ui-components/progress_indicator.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Center(
      child: SdProgressIndicator(),
    );
  }
}
