import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/view_all_label_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_model.dart';
import 'package:handyman_provider_flutter/provider/components/service_widget.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListComponent extends StatelessWidget {
  final List<ServiceData> list;
  bool changeList = false;

  ServiceListComponent({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: languages.lblMyService,
          list: list,
          onTap: () {
            ServiceListScreen().launch(context);
          },
        ),
        16.height,
        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: List.generate(
            list.take(4).length,
            (index) {
              return ServiceComponent(data: list[index], width: context.width() * 0.5 - 24,changeList: changeList).onTap(() async {
                await ServiceDetailScreen(serviceId: list[index].id.validate()).launch(context);
              }, borderRadius: radius());
            },
          ),
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}
