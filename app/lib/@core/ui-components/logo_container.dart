import 'package:flutter/material.dart';
import 'package:app/@core/util/ui_util.dart';

class LogoContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(UIUtil.defaultBorderRadius),
          ),
          child: Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Text(
        //       'Drain Big',
        //       style: UIUtil.getTxtStyleTitle2(),
        //     ),
        //     SizedBox(
        //       width: 8,
        //     ),
        //     Text(
        //       'Drain BIGGER',
        //       style: UIUtil.getTxtStyleTitle1(),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
