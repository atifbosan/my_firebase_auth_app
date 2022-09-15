import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app/my_app.dart';

progressIndicatorWidget(BuildContext context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.5)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15, left: 13, right: 13),
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 25,
                ),
              )),
        ));

dismissIndicator() =>
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
