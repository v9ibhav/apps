import 'package:booking_system_flutter/screens/newDashboard/dashboard_3/component/service_dashboard_component_3.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/empty_error_state_widget.dart';
import '../../../../component/view_all_label_component.dart';
import '../../../../main.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../service/view_all_service_screen.dart';

class ServiceListDashboardComponent3 extends StatelessWidget {
  final List<ServiceData> serviceList;
  final String serviceListTitle;
  final bool isFeatured;

  ServiceListDashboardComponent3({required this.serviceList, this.serviceListTitle = '', this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    if (serviceList.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: serviceListTitle,
          list: serviceList,
          trailingTextStyle: boldTextStyle(color: primaryColor, size: 12),
          onTap: () {
            ViewAllServiceScreen(isFeatured: isFeatured ? '1' : '').launch(context).then((value) {
              setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
            });
          },
        ).paddingSymmetric(horizontal: 16),
        if (serviceList.isNotEmpty)
          HorizontalList(
            itemCount: serviceList.length,
            spacing: 16,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            itemBuilder: (context, index) {
              return ServiceDashboardComponent3(
                serviceData: serviceList[index],
                width: 280,
                isBorderEnabled: true,
              );
            },
          )
        else
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: NoDataWidget(
              title: language.lblNoServicesFound,
              imageWidget: EmptyStateWidget(),
            ),
          ).center(),
      ],
    );
  }
}
