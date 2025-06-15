import 'package:booking_system_flutter/screens/newDashboard/dashboard_1/component/service_dashboard_component_1.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../component/empty_error_state_widget.dart';
import '../../../../component/view_all_label_component.dart';
import '../../../../main.dart';
import '../../../../model/service_data_model.dart';
import '../../../../utils/colors.dart';
import '../../../service/view_all_service_screen.dart';

class FeatureServicesDashboardComponent1 extends StatelessWidget {
  final List<ServiceData> serviceList;

  FeatureServicesDashboardComponent1({required this.serviceList});

  @override
  Widget build(BuildContext context) {
    if (serviceList.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: language.featuredServices,
          list: serviceList,
          trailingTextStyle: boldTextStyle(color: primaryColor, size: 12),
          onTap: () {
            ViewAllServiceScreen(isFeatured: "1").launch(context);
          },
        ).paddingSymmetric(horizontal: 16),
        if (serviceList.isNotEmpty)
          HorizontalList(
            itemCount: serviceList.length,
            spacing: 16,
            padding: EdgeInsets.only(left: 16, right: 16),
            itemBuilder: (context, index) => ServiceDashboardComponent1(serviceData: serviceList[index], width: context.width() - 120),
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
