import 'dart:async';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../component/price_widget.dart';
import '../../withdraw/wallet_request.dart';
import '../user_wallet_balance_screen.dart';

class WalletCard extends StatefulWidget {
  final num availableBalance;
  final FutureOr<dynamic> Function(dynamic)? callback;
  const WalletCard({super.key, required this.availableBalance, this.callback});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: context.width(),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primaryColor),
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
                  Text(language.availableBalance, style: secondaryTextStyle(size: 12)),
                  FittedBox(
                    child: PriceWidget(price: widget.availableBalance.validate(), size: 26, color: context.primaryColor, isBoldText: true),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextIcon(
                onTap: () {
                  WithdrawRequest(
                    availableBalance: widget.availableBalance,
                  ).launch(context).then(widget.callback!);
                },
                suffix: CachedImageWidget(
                  url: ic_plus,
                  height: 16,
                  width: 16,
                  color: white,
                ),
                textStyle: secondaryTextStyle(color: white),
                text: language.withdraw,
              ),
              TextIcon(
                onTap: () {
                  UserWalletBalanceScreen(isBackScreen: true).launch(context).then(widget.callback!);
                },
                suffix: CachedImageWidget(
                  url: ic_plus,
                  height: 16,
                  width: 16,
                  color: white,
                ),
                textStyle: secondaryTextStyle(color: white),
                text: language.topUp,
              ),
            ],
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 16);
  }
}
