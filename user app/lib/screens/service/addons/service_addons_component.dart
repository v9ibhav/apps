import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/price_widget.dart';
import '../../../component/view_all_label_component.dart';
import '../../../main.dart';
import '../../../model/service_detail_response.dart';

class AddonComponent extends StatefulWidget {
  final List<Serviceaddon> serviceAddon;
  final Function(List<Serviceaddon>)? onSelectionChange;
  final bool isFromBookingLastStep;
  final bool isFromBookingDetails;
  final bool showDoneBtn;
  final Function(Serviceaddon)? onDoneClick;

  AddonComponent({
    required this.serviceAddon,
    this.isFromBookingLastStep = false,
    this.isFromBookingDetails = false,
    this.onSelectionChange,
    this.showDoneBtn = false,
    this.onDoneClick,
  });

  @override
  _AddonComponentState createState() => _AddonComponentState();
}

class _AddonComponentState extends State<AddonComponent> {
  List<Serviceaddon> selectedServiceAddon = [];
  double imageHeight = 60;

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
    if (widget.serviceAddon.isEmpty) return Offstage();

    bool isSingleAddon = widget.serviceAddon.length == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: language.addOns,
          list: [],
          onTap: () {},
        ),
        isSingleAddon ? buildSingleAddonWidget(widget.serviceAddon[0]) : buildMultipleAddonsWidget(),
      ],
    ).paddingSymmetric(
      horizontal: widget.isFromBookingLastStep || widget.isFromBookingDetails ? 0 : 16,
    );
  }

  Widget buildSingleAddonWidget(Serviceaddon addon) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Marquee(
                  directionMarguee: DirectionMarguee.oneDirection, // Scrolling text
                  child: Text(
                    addon.name.validate(),
                    style: boldTextStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              8.width,
              if (!widget.isFromBookingDetails) buildAddButton(addon),
            ],
          ),
          10.height,
          PriceWidget(
            price: addon.price.validate(),
            hourlyTextColor: Colors.white,
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget buildMultipleAddonsWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.serviceAddon.length,
          (i) {
            Serviceaddon data = widget.serviceAddon[i];
            return Observer(builder: (context) {
              return GestureDetector(
                onTap: () {
                  if (!widget.isFromBookingLastStep && !widget.isFromBookingDetails) {
                    handleAddRemove(data);
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: buildAddonContainer(data),
              );
            });
          },
        ),
      ),
    );
  }

  Widget buildAddonContainer(Serviceaddon data) {
    return Container(
      width: context.isPhone() ? context.width() - 60 : 300,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(
                    data.name.validate(),
                    style: boldTextStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              8.width,
              if (!widget.isFromBookingDetails) buildAddButton(data),
            ],
          ),
          10.height,
          PriceWidget(
            price: data.price.validate(),
            hourlyTextColor: Colors.white,
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget buildAddButton(Serviceaddon data) {
    return Container(
      decoration: BoxDecoration(
        color: appStore.isDarkMode ? Colors.black : Colors.white,
        borderRadius: radius(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Center(
        child: Text(
          data.isSelected ? language.remove : language.add, // Toggle between Add and Remove
          textAlign: TextAlign.center,
          style: boldTextStyle(color: context.primaryColor, size: 12),
        ),
      ),
    ).onTap(() => handleAddRemove(data));
  }

  void handleAddRemove(Serviceaddon data) {
    data.isSelected = !data.isSelected;
    selectedServiceAddon = widget.serviceAddon.where((p0) => p0.isSelected).toList();
    widget.onSelectionChange?.call(selectedServiceAddon);
    setState(() {});
  }
}
