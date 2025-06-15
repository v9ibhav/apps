import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/provider/withdraw/withdraw_request/withdraw_request.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../components/price_widget.dart';

class WalletCard extends StatefulWidget {
  num availableBalance = 0;
  final FutureOr<dynamic> Function(dynamic)? callback;
  WalletCard({super.key, required this.availableBalance, this.callback});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: context.width(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: primaryColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: context.width(),
            child: Card(
              color: context.scaffoldBackgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(languages.availableBalance,
                      style: secondaryTextStyle(size: 12)),
                  FittedBox(
                    child: PriceWidget(
                        price: widget.availableBalance.validate(),
                        size: 26,
                        color: context.primaryColor,
                        isBoldText: true),
                  )
                ],
              ),
            ),
          ),
          TextIcon(
            onTap: (){
                WithdrawRequest(
                  availableBalance: widget.availableBalance,
                ).launch(context).then(widget.callback?? (val){});
              },
              suffix:CachedImageWidget(
              url: ic_plus,
              height: 16,
              width: 16,
              color: white,
            ),
            textStyle: secondaryTextStyle(color: white),
              text: languages.withdraw,
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 16);
  }
}