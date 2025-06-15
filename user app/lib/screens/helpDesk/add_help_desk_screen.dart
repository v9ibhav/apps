import 'dart:io';

import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/chat_gpt_loder.dart';
import '../../component/custom_image_picker.dart';
import '../../component/loader_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import '../../utils/model_keys.dart';
import 'help_desk_repository.dart';

class AddHelpDeskScreen extends StatefulWidget {
  final Function(bool) callback;

  AddHelpDeskScreen({required this.callback});

  @override
  _AddHelpDeskScreenState createState() => _AddHelpDeskScreenState();
}

class _AddHelpDeskScreenState extends State<AddHelpDeskScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();

  List<File> imageFiles = [];

  TextEditingController subjectCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode subjectFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //region Add Blog
  Future<void> checkValidation() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      Map<String, dynamic> req = {
        HelpDeskKey.subject: subjectCont.text,
        HelpDeskKey.description: descriptionCont.text,
      };

      log("Save Help Desk Query Request: $req");
      saveHelpDeskMultiPart(value: req, imageFile: imageFiles.where((element) => !element.path.contains('http')).toList()).then((value) {
        widget.callback.call(true);
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
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language.subject, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        8.height,
                        AppTextField(
                          controller: subjectCont,
                          focus: subjectFocus,
                          nextFocus: descriptionFocus,
                          textFieldType: TextFieldType.MULTILINE,
                          minLines: 1,
                          decoration: inputDecoration(
                            context,
                            hintText: language.eGDamagedFurniture,
                          ),
                          maxLength: 120,
                          suffix: ic_document.iconImage(size: 10).paddingAll(14),
                        ),
                        16.height,
                        Text(language.hintDescription, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                        8.height,
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
                        CustomImagePicker(
                          key: uniqueKey,
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
                      ],
                    ),
                  ),
                ),
              ),
              Observer(
                builder: (_) => AppButton(
                  margin: EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  text: language.btnSubmit,
                  height: 40,
                  color: appStore.isLoading ? primaryColor.withValues(alpha:0.5) : primaryColor,
                  textStyle: boldTextStyle(color: white),
                  width: context.width() - context.navigationBarHeight,
                  onTap: appStore.isLoading
                      ? () {}
                      : () {
                          checkValidation();
                        },
                ),
              ),
            ],
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
