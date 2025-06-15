import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:nb_utils/nb_utils.dart';

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
      ),
      backgroundColor: context.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Html(
          data: postContent!,
          style: {
            "body": Style(
              fontSize: FontSize(16.0),
              color: context.iconColor,
            ),
            "p": Style(backgroundColor: context.scaffoldBackgroundColor),
          },
        ),
      ),
    );
  }
}
