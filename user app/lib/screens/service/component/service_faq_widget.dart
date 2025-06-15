import 'package:booking_system_flutter/model/service_detail_response.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class ServiceFaqWidget extends StatelessWidget {
  const ServiceFaqWidget({Key? key, required this.serviceFaq}) : super(key: key);

  final ServiceFaq serviceFaq;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(color: context.cardColor,
        borderRadius: radius(),
        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
      ),
      child: ExpansionTile(
        title: Text(serviceFaq.title.validate(), style: primaryTextStyle(weight:FontWeight.bold,size: 12),),
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          ListTile(
            title: Text(serviceFaq.description.validate(), style: secondaryTextStyle(),),
            contentPadding: EdgeInsets.only(left: 32),
          ),
        ],
      ),
    );
  }
}
