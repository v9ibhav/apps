import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/app_widgets.dart';
import '../components/cached_image_widget.dart';
import '../components/empty_error_state_widget.dart';
import '../main.dart';
import '../models/user_data.dart';
import '../networks/rest_apis.dart';
import '../utils/configs.dart';

class ProviderListScreen extends StatefulWidget {
  final String? status;

  ProviderListScreen({this.status});

  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  ScrollController scrollController = ScrollController();

  TextEditingController searchCont = TextEditingController();

  Future<List<UserData>>? future;

  List<UserData> providerList = [];

  int currentPage = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getProviderList(
      page: currentPage,
      keyword: searchCont.text,
      status: widget.status.validate(),
      lastPageCallback: (res) {
        appStore.setLoading(false);
        isLastPage = res;
        setState(() {});
      },
      list: providerList,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.providerList,
      scaffoldBackgroundColor: appStore.isDarkMode ? blackColor : context.cardColor,
      body: Column(
        children: [
          AppTextField(
            suffix: searchCont.text.isNotEmpty
                ? CloseButton(
                    color: primaryColor,
                    onPressed: () {
                      searchCont.clear();
                      hideKeyboard(context);

                      appStore.setLoading(true);
                      currentPage = 1;
                      init();
                    },
                  )
                : null,
            textFieldType: TextFieldType.OTHER,
            controller: searchCont,
            onChanged: (s) async {
              if (s.isEmpty) {
                hideKeyboard(context);
                currentPage = 1;

                appStore.setLoading(true);
                init();
                setState(() {});
                return await 2.seconds.delay;
              }
            },
            onFieldSubmitted: (s) async {
              currentPage = 1;

              appStore.setLoading(true);
              init();
              setState(() {});
              return await 2.seconds.delay;
            },
            decoration: InputDecoration(
              hintText: languages.lblSearchHere,
              prefixIcon: Icon(Icons.search, color: context.iconColor, size: 20),
              hintStyle: secondaryTextStyle(),
              border: OutlineInputBorder(
                borderRadius: radius(8),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
              filled: true,
              contentPadding: EdgeInsets.all(16),
              fillColor: appStore.isDarkMode ? cardDarkColor : Colors.white,
            ),
          ).paddingOnly(left: 16, right: 16, top: 24, bottom: 8),
          SnapHelperWidget(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (res) {
              if (res.isEmpty && !appStore.isLoading) {
                return NoDataWidget(
                  title: languages.noDataFound,
                  imageWidget: EmptyStateWidget(),
                );
              }

              return AnimatedScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                onNextPage: () {
                  if (!isLastPage) {
                    currentPage++;

                    appStore.setLoading(true);
                    init();

                    setState(() {});
                  }
                },
                onSwipeRefresh: () async {
                  currentPage = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                children: [
                  AnimatedWrap(
                    spacing: 16,
                    runSpacing: 16,
                    itemCount: providerList.length,
                    scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                    listAnimationType: ListAnimationType.Scale,
                    itemBuilder: (context, index) {
                      UserData selectedProviderData = providerList[index];

                      return SettingItemWidget(
                        title: selectedProviderData.displayName.validate(),
                        titleTextStyle: primaryTextStyle(),
                        padding: EdgeInsets.symmetric(vertical: 6),
                        leading: CachedImageWidget(
                          url: selectedProviderData.profileImage.validate(),
                          height: 30,
                          circle: true,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          finish(context, selectedProviderData);
                        },
                      );
                    },
                  ).paddingAll(16),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: languages.reload,
                onRetry: () {
                  currentPage = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
          ).expand(),
        ],
      ),
    );
  }
}
