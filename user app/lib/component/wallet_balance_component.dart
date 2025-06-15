import 'package:booking_system_flutter/utils/extensions/num_extenstions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../network/rest_apis.dart';

class WalletBalanceComponent extends StatefulWidget {
  const WalletBalanceComponent({Key? key}) : super(key: key);

  @override
  State<WalletBalanceComponent> createState() => _WalletBalanceComponentState();
}

class _WalletBalanceComponentState extends State<WalletBalanceComponent> {
  Future<num>? futureWalletBalance;

  @override
  void initState() {
    super.initState();
    loadBalance();
  }

  void loadBalance() {
    futureWalletBalance = getUserWalletBalance();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${language.walletBalance}: ', style: secondaryTextStyle(size: 14)),
        SnapHelperWidget(
          future: futureWalletBalance,
          onSuccess: (balance) => Text(
            balance.toPriceFormat(),
            style: boldTextStyle(color: Colors.green, size: 16),
          ),
          useConnectionStateForLoader: true,
          errorBuilder: (p0) {
            return IconButton(
              onPressed: () {
                loadBalance();
                setState(() {});
              },
              icon: Icon(Icons.refresh_rounded),
            );
          },
        ),
      ],
    );
  }
}
