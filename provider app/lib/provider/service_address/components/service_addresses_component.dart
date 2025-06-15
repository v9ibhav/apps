import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/service_address_response.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common.dart';

class ServiceAddressesComponent extends StatefulWidget {
  final AddressResponse data;
  final Function(bool? value)? onStatusUpdate;
  final Function() onDelete;
  final Function() onEdit;

  ServiceAddressesComponent(this.data, {this.onStatusUpdate, required this.onDelete, required this.onEdit, Key? key}) : super(key: key);

  @override
  ServiceAddressesComponentState createState() => ServiceAddressesComponentState();
}

class ServiceAddressesComponentState extends State<ServiceAddressesComponent> {
  bool isStatusUpdate = false;

/*
  Future<void> changeStatus(AddressResponse data, int status) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: data.id,
      UserKeys.status: status,
      "address": data.address,
      "latitude": data.latitude,
      "longitude": data.longitude,
      'provider_id': data.providerId,
    };

    await addAddresses(request).then((value) {
      appStore.setLoading(false);

      appStore.setLoading(false);
      toast(value.message);

      finish(context, true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
      if (data.status.validate() == 1) {
        data.status = 0;
      } else {
        data.status = 1;
      }
      setState(() {});
    });
  }*/

  @override
  void initState() {
    isStatusUpdate = widget.data.status == 1 ? true : false;
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 0),
      margin: EdgeInsets.only(bottom: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.data.address.validate(), style: boldTextStyle(), overflow: TextOverflow.ellipsis, maxLines: 4).expand(),
              /*Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                    value: widget.data.status == 1,
                    activeColor: greenColor,
                    onChanged: (_) {
                      ifNotTester(context, () {
                        if (widget.data.status.validate() == 1) {
                          widget.data.status = 0;
                          changeStatus(widget.data, 0);
                        } else {
                          widget.data.status = 1;
                          changeStatus(widget.data, 1);
                        }
                      });
                      setState(() {});
                    }).withHeight(24),
              ),*/

              Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: isStatusUpdate,
                  onChanged: (value) {
                    ifNotTester(context, () {
                      isStatusUpdate = value;
                      setState(() {});
                      widget.onStatusUpdate!.call(value);
                    });
                  },
                ).paddingLeft(16),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: widget.onEdit,
                style: ButtonStyle(visualDensity: VisualDensity.compact),
                child: Text(languages.lblEdit, style: secondaryTextStyle()),
              ),
              16.width,
              TextButton(
                onPressed: widget.onDelete,
                style: ButtonStyle(visualDensity: VisualDensity.compact),
                child: Text(languages.lblDelete, style: secondaryTextStyle()),
              ),
            ],
          )
        ],
      ),
    );
  }
}
