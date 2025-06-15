import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class DaysComponent extends StatefulWidget {
  final List<String> daysList;
  final Function(String)? onDayChanged;

  DaysComponent({required this.daysList, this.onDayChanged, super.key});

  @override
  DaysComponentState createState() => DaysComponentState();
}

class DaysComponentState extends State<DaysComponent> {
  int selectedDayIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return HorizontalList(
      itemCount: widget.daysList.length,
      crossAxisAlignment: WrapCrossAlignment.start,
      wrapAlignment: WrapAlignment.start,
      runSpacing: 8,
      spacing: 8,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      itemBuilder: (BuildContext context, int index) {
        String data = widget.daysList[index];
        return Container(
          height: 45,
          width: 65,
          alignment: Alignment.center,
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: selectedDayIndex == index
                ? primaryColor
                : appStore.isDarkMode
                    ? scaffoldDarkColor
                    : Colors.white,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          child: Text(
            data.validate().toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: boldTextStyle(
              color: selectedDayIndex == index
                  ? white
                  : appStore.isDarkMode
                      ? white
                      : appTextPrimaryColor,
            ),
          ),
        ).onTap(
          () {
            selectedDayIndex = index;
            setState(() {});
            widget.onDayChanged?.call(data);
          },
        );
      },
    );
  }
}
