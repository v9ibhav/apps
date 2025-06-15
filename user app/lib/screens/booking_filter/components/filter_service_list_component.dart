import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/image_border_component.dart';
import '../../../component/loader_widget.dart';
import '../../../component/selected_item_widget.dart';
import '../../../main.dart';
import '../../../model/service_data_model.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/constant.dart';

class FilterServiceListComponent extends StatefulWidget {
  @override
  State<FilterServiceListComponent> createState() => _FilterServiceListComponentState();
}

class _FilterServiceListComponentState extends State<FilterServiceListComponent> {
  Future<List<ServiceData>>? future;

  List<ServiceData> servicesList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = searchServiceAPI(
      page: page,
      list: servicesList,
      lastPageCallBack: (b) {
        isLastPage = b;
      },
    );
  }

  void setPageToOne() {
    page = 1;
    appStore.setLoading(true);

    init();
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SnapHelperWidget<List<ServiceData>>(
          future: future,
          loadingWidget: LoaderWidget(),
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: language.reload,
              onRetry: () {
                setPageToOne();
              },
            );
          },
          onSuccess: (list) {
            return AnimatedListView(
              slideConfiguration: sliderConfigurationGlobal,
              itemCount: list.length,
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
              emptyWidget: NoDataWidget(
                title: language.lblNoServicesFound,
                imageWidget: EmptyStateWidget(),
              ),
              onSwipeRefresh: () async {
                page = 1;

                init();
                setState(() {});

                return await 2.seconds.delay;
              },
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                  appStore.setLoading(true);
                  init();
                  setState(() {});
                }
              },
              itemBuilder: (context, index) {
                ServiceData data = list[index];

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                  child: Row(
                    children: [
                      ImageBorder(
                        src: data.attachments!.isNotEmpty ? data.attachments!.first.validate() : "",
                        height: 45,
                      ),
                      16.width,
                      Text(data.name.validate(), style: boldTextStyle()).expand(),
                      4.width,
                      SelectedItemWidget(isSelected: filterStore.serviceId.contains(data.id)),
                    ],
                  ),
                ).onTap(() {
                  if (data.isSelected.validate()) {
                    data.isSelected = false;
                  } else {
                    data.isSelected = true;
                  }

                  filterStore.serviceId = [];

                  servicesList.forEach((element) {
                    if (element.isSelected.validate()) {
                      filterStore.addToServiceList(serId: element.id.validate());
                    }
                  });

                  setState(() {});
                }, hoverColor: Colors.transparent, highlightColor: Colors.transparent, splashColor: Colors.transparent);
              },
            );
          },
        ),
        Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading && page != 1)),
      ],
    );
  }
}
