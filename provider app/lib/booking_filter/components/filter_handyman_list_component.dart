import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';
import '../../components/image_border_component.dart';
import '../../components/selected_item_widget.dart';
import '../../main.dart';
import '../../models/user_data.dart';
import '../../networks/rest_apis.dart';
import '../../utils/constant.dart';

class FilterHandymanListComponent extends StatefulWidget {
  @override
  State<FilterHandymanListComponent> createState() => _FilterHandymanListComponentState();
}

class _FilterHandymanListComponentState extends State<FilterHandymanListComponent> {
  Future<List<UserData>>? future;

  List<UserData> handymanList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getHandyman(
      page: page,
      list: handymanList,
      providerId: appStore.userId.toString(),
      userTypeHandyman: USER_TYPE_HANDYMAN,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    ).then((list) {
      handymanList = list.validate();
      handymanList.forEach((element) {
        if (filterStore.handymanId.contains(element.id)) {
          element.isSelected = true;
        }
      });
      return handymanList;
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
        SnapHelperWidget<List<UserData>>(
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
                title: languages.handymanNotFound,
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
                UserData data = list[index];

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
                        src: data.profileImage.validate(),
                        height: 45,
                      ),
                      16.width,
                      Text(data.displayName.validate(), style: boldTextStyle()).expand(),
                      4.width,
                      SelectedItemWidget(isSelected: data.isSelected),
                    ],
                  ),
                ).onTap(() {
                  if (data.isSelected) {
                    data.isSelected = false;
                  } else {
                    data.isSelected = true;
                  }

                  filterStore.handymanId = [];

                  handymanList.forEach((element) {
                    if (element.isSelected) {
                      filterStore.addToHandymanList(handyId: element.id.validate());
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
