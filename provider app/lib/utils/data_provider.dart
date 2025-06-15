import 'package:flutter/cupertino.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/about_model.dart';
import 'package:handyman_provider_flutter/utils/extensions/context_ext.dart';
import 'package:handyman_provider_flutter/utils/images.dart';

List<AboutModel> getAboutDataModel({BuildContext? context}) {
  List<AboutModel> aboutList = [];

  if(rolesAndPermissionStore.termCondition)
  aboutList.add(AboutModel(title: context!.translate.lblTermsAndConditions, image: termCondition));
  if(rolesAndPermissionStore.privacyPolicy)
  aboutList.add(AboutModel(title: languages.lblPrivacyPolicy, image: privacy_policy));
  if(rolesAndPermissionStore.helpAndSupport)
  aboutList.add(AboutModel(title: languages.lblHelpAndSupport, image: termCondition));
  aboutList.add(AboutModel(title: languages.lblHelpLineNum, image: calling));
  aboutList.add(AboutModel(title: languages.lblRateUs, image: rateUs));

  return aboutList;
}
