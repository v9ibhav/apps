import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../components/image_border_component.dart';
import '../../components/selected_item_widget.dart';
import '../../models/service_model.dart';
import '../../networks/rest_apis.dart';
import '../../utils/constant.dart';

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
    future = getSearchList(
      page,
      providerId: appStore.userType == USER_TYPE_HANDYMAN ? appStore.providerId : appStore.userId,
      services: servicesList,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    ).then((list) {
      servicesList = list.validate();
      servicesList.forEach((element) {
        if (filterStore.serviceId.contains(element.id)) {
          element.isSelected = true;
        }
      });
      return servicesList;
    });
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
              retryText: languages.reload,
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
                title: languages.noServiceFound,
                subTitle: languages.noServiceSubTitle,
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
                        src: data.imageAttachments!.isNotEmpty ? data.imageAttachments!.first.validate() : "",
                        height: 45,
                      ),
                      16.width,
                      Text(data.name.validate(), style: boldTextStyle()).expand(),
                      4.width,
                      SelectedItemWidget(isSelected: data.isSelected.validate()),
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
