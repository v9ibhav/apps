import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/back_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class LanguagesScreen extends StatefulWidget {
  @override
  LanguagesScreenState createState() => LanguagesScreenState();
}

class LanguagesScreenState extends State<LanguagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> refreshList() async {
    dayListMap = {
      languages.mon: "mon",
      languages.tue: "tue",
      languages.wed: "wed",
      languages.thu: "thu",
      languages.fri: "fri",
      languages.sat: "sat",
      languages.sun: "sun",
    };
    daysList = [
      languages.mon,
      languages.tue,
      languages.wed,
      languages.thu,
      languages.fri,
      languages.sat,
      languages.sun,
    ];
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.language,
        textColor: white,
        elevation: 0.0,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: LanguageListWidget(
        widgetType: WidgetType.LIST,
        onLanguageChange: (v) async {
          appStore.setLanguage(v.languageCode!).then((v) {
            refreshList();
          });
          setState(() {});
          finish(context);
        },
      ),
    );
  }
}
