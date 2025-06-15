import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';
import 'back_widget.dart';
import 'base_scaffold_body.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? actions;

  final Widget body;
  final Color? scaffoldBackgroundColor;
  final Widget? bottomNavigationBar;
  final bool showLoader;

  AppScaffold({
    this.appBarTitle,
    required this.body,
    this.actions,
    this.scaffoldBackgroundColor,
    this.bottomNavigationBar,
    this.showLoader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarTitle != null
          ? AppBar(
              title: Text(appBarTitle.validate(),
                  style: boldTextStyle(
                      color: Colors.white, size: APP_BAR_TEXT_SIZE)),
              elevation: 0.0,
              backgroundColor: context.primaryColor,
              leading: context.canPop ? BackWidget() : null,
              actions: actions,
            )
          : null,
      backgroundColor: scaffoldBackgroundColor,
      body: Body(child: body, showLoader: showLoader),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
