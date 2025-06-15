import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class DisclaimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(languages.notes, style: secondaryTextStyle()),
          16.height,
          UL(
            spacing: 16,
            symbolColor: textSecondaryColorGlobal,
            symbolType: SymbolType.Numbered,
            children: [
              Text(languages.timeSlotsNotes1, style: secondaryTextStyle()),
              Text(languages.timeSlotsNotes2, style: secondaryTextStyle()),
              Text(languages.timeSlotsNotes3, style: secondaryTextStyle()),
            ],
          )
        ],
      ),
    );
  }
}
