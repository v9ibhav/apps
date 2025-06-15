import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';

const FONT_SIZE = "FONT_SIZE";

class HtmlWidget extends StatelessWidget {
  final String? postContent;
  final Color? color;
  final String? title;

  HtmlWidget({this.postContent, this.color, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        title.validate(),
        elevation: 0,
        backWidget: BackWidget(),
        color: context.primaryColor,
        textColor: Colors.white,
        textSize: APP_BAR_TEXT_SIZE,
      ),
      backgroundColor: context.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Html(
          data: postContent!,
          style: {
            "body": Style(
              fontSize: FontSize(16.0),
              color: context.iconColor,
            ),
            "p": Style(backgroundColor: Colors.transparent),
          },
        ),
      ),
    );
  }
}
