import 'dart:io';

import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/chat_gpt_loder.dart';
import '../../component/custom_image_picker.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../../utils/model_keys.dart';
import 'components/help_desk_activity_component.dart';
import 'help_desk_repository.dart';
import 'model/help_desk_detail_response.dart';
import 'model/help_desk_response.dart';

class HelpDeskDetailScreen extends StatefulWidget {
  final HelpDeskListData helpDeskData;

  HelpDeskDetailScreen({required this.helpDeskData});

  @override
  _HelpDeskDetailScreenState createState() => _HelpDeskDetailScreenState();
}

class _HelpDeskDetailScreenState extends State<HelpDeskDetailScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();

  Future<List<HelpDeskActivityData>>? future;

  List<HelpDeskActivityData> helpDeskActivityListData = [];

  TextEditingController descriptionCont = TextEditingController();

  FocusNode descriptionFocus = FocusNode();

  List<File> imageFiles = [];

  int page = 1;

  bool isLastPage = false;
  bool isReplyBtnClick = false;

  String showBtnOption = OPEN;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getHelpDeskDetailAPI(
      helpDeskId: widget.helpDeskData.id.validate(),
      helpDeskActivityListData: helpDeskActivityListData,
      page: page,
      lastPageCallback: (b, status) {
        isLastPage = b;
        showBtnOption = status;
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void helpDeskClosed({required num id, required String status}) {
    helpDeskClosedAPI(helpDeskId: id.validate()).then((value) {
      appStore.setLoading(false);
      toast(value.message.validate());
      LiveStream().emit(LIVESTREAM_UPDATE_HELP_DESK_LIST, OPEN);
      showBtnOption = CLOSED;
      init();
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  //region Add Blog
  Future<void> checkValidation() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      Map<String, dynamic> req = {
        HelpDeskKey.description: descriptionCont.text,
      };

      log("Reply Query Request: $req");
      saveHelpDeskActivityMultiPart(helpDeskId: widget.helpDeskData.id.validate(), value: req, imageFile: imageFiles.where((element) => !element.path.contains('http')).toList()).then((value) {
        isReplyBtnClick = false;
        init();
        setState(() {});
      }).catchError((e) {
        toast(e.toString());
      });
    }
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.helpDesk,
      child: Stack(
        children: [
          AnimatedScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
            crossAxisAlignment: CrossAxisAlignment.start,
            onSwipeRefresh: () async {
              appStore.setLoading(true);

              init();
              setState(() {});

              return await 2.seconds.delay;
            },
            children: [
              Text('#${widget.helpDeskData.id}', style: boldTextStyle(color: primaryColor)),
              8.height,
              Text(
                formatBookingDate(widget.helpDeskData.createdAt.validate(), format: DATE_FORMAT_10),
                style: secondaryTextStyle(),
              ),
              16.height,
              Text(widget.helpDeskData.subject.validate(), style: boldTextStyle()),
              8.height,
              Text(
                widget.helpDeskData.description.validate(),
                style: secondaryTextStyle(),
              ),
              16.height,
              SnapHelperWidget<List<HelpDeskActivityData>>(
                future: future,
                loadingWidget: LoaderWidget(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    imageWidget: ErrorStateWidget(),
                    retryText: language.reload,
                    onRetry: () {
                      page = 1;
                      appStore.setLoading(true);

                      init();
                      setState(() {});
                    },
                  );
                },
                onSuccess: (helpDeskActivityList) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                    ),
                    child: Column(
                      children: [
                        AnimatedListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: helpDeskActivityList.length,
                          listAnimationType: ListAnimationType.FadeIn,
                          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                          emptyWidget: NoDataWidget(
                            title: language.noActivityYet,
                            titleTextStyle: boldTextStyle(),
                            subTitle: language.noRecordsFound,
                            imageWidget: EmptyStateWidget(),
                          ),
                          onNextPage: () {
                            if (!isLastPage) {
                              page++;
                              appStore.setLoading(true);

                              init();
                              setState(() {});
                            }
                          },
                          onSwipeRefresh: () async {
                            page = 1;

                            init();
                            setState(() {});

                            return await 2.seconds.delay;
                          },
                          itemBuilder: (BuildContext context, index) {
                            HelpDeskActivityData helpDeskActivityData = helpDeskActivityList[index];

                            return HelpDeskActivityComponent(
                              helpDeskIndex: index,
                              showBtnOption: showBtnOption,
                              helpDeskActivityCount: helpDeskActivityList.length,
                              helpDeskActivityData: helpDeskActivityData,
                            );
                          },
                        ),
                        Column(
                          children: [
                            if (isReplyBtnClick)
                              Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(language.reply, style: boldTextStyle(size: 12)),
                                    8.height,
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: boxDecorationWithRoundedCorners(
                                        borderRadius: radius(),
                                        backgroundColor: appStore.isDarkMode ? appButtonColorDark : Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomImagePicker(
                                            key: uniqueKey,
                                            iconSize: 26,
                                            textSize: 10,
                                            imageSize: 50,
                                            onRemoveClick: (value) {
                                              showConfirmDialogCustom(
                                                context,
                                                dialogType: DialogType.DELETE,
                                                positiveText: language.lblDelete,
                                                negativeText: language.lblCancel,
                                                onAccept: (p0) {
                                                  imageFiles.removeWhere((element) => element.path == value);
                                                  setState(() {});
                                                },
                                              );
                                            },
                                            onFileSelected: (List<File> files) async {
                                              imageFiles = files;
                                              setState(() {});
                                            },
                                          ),
                                          4.height,
                                          Text(language.hintDescription, style: boldTextStyle(size: 12)),
                                          4.height,
                                          AppTextField(
                                            textFieldType: TextFieldType.MULTILINE,
                                            controller: descriptionCont,
                                            focus: descriptionFocus,
                                            maxLines: 10,
                                            minLines: 3,
                                            enableChatGPT: appConfigurationStore.chatGPTStatus,
                                            promptFieldInputDecorationChatGPT: inputDecoration(context).copyWith(
                                              hintText: language.writeHere,
                                              fillColor: context.scaffoldBackgroundColor,
                                              filled: true,
                                              hintStyle: primaryTextStyle(),
                                            ),
                                            testWithoutKeyChatGPT: appConfigurationStore.testWithoutKey,
                                            loaderWidgetForChatGPT: const ChatGPTLoadingWidget(),
                                            decoration: inputDecoration(
                                              context,
                                              hintText: language.eGDuringTheService,
                                            ),
                                          ),
                                          16.height,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              AppButton(
                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                color: context.cardColor,
                                                onTap: () {
                                                  isReplyBtnClick = false;
                                                  imageFiles.clear();
                                                  descriptionCont.clear();
                                                  setState(() {});
                                                },
                                                text: language.close,
                                                textStyle: boldTextStyle(),
                                              ),
                                              16.width,
                                              AppButton(
                                                text: language.btnSubmit,
                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                color: appStore.isLoading ? primaryColor.withValues(alpha:0.5) : primaryColor,
                                                textStyle: boldTextStyle(color: white),
                                                onTap: appStore.isLoading
                                                    ? () {}
                                                    : () {
                                                        checkValidation();
                                                      },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (showBtnOption != CLOSED)
                              Row(
                                children: [
                                  AppButton(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    onTap: () {
                                      showConfirmDialogCustom(
                                        context,
                                        title: language.doYouWantClosedThisQuery,
                                        positiveText: language.closed.capitalizeFirstLetter(),
                                        negativeText: language.lblNo,
                                        dialogType: DialogType.CONFIRMATION,
                                        primaryColor: primaryColor,
                                        onAccept: (p0) async {
                                          appStore.setLoading(true);
                                          helpDeskClosed(id: widget.helpDeskData.id.validate(), status: widget.helpDeskData.status.validate());
                                        },
                                      );
                                    },
                                    text: language.markAsClosed,
                                    textStyle: boldTextStyle(),
                                  ).expand(),
                                  16.width,
                                  AppButton(
                                    text: language.reply,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    color: appStore.isLoading ? primaryColor.withValues(alpha:0.5) : primaryColor,
                                    textStyle: boldTextStyle(color: white),
                                    onTap: () {
                                      isReplyBtnClick = true;
                                      imageFiles.clear();
                                      descriptionCont.clear();
                                      setState(() {});
                                    },
                                  ).expand(),
                                ],
                              ).paddingOnly(top: 25),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (showBtnOption != CLOSED && widget.helpDeskData.status != CLOSED)
                Text(
                  '*${language.youCanMarkThis}',
                  style: secondaryTextStyle(size: 12, fontStyle: FontStyle.italic),
                ).paddingTop(20),
            ],
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
