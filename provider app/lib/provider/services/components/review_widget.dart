import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/image_border_component.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_detail_response.dart';
import 'package:handyman_provider_flutter/provider/services/service_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewWidget extends StatelessWidget {
  final RatingData data;
  final bool isCustomer;
  final bool showServiceName;

  ReviewWidget({required this.data, this.isCustomer = false, this.showServiceName = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showServiceName) {
          ServiceDetailScreen(serviceId: data.serviceId.validate().toInt()).launch(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 8),
        width: context.width(),
        decoration: boxDecorationDefault(color: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageBorder(src: data.profileImage.validate().isNotEmpty ? data.profileImage.validate() : (isCustomer ? data.customerProfileImage.validate() : data.handymanProfileImage.validate()), height: 45),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${data.customerName.validate()}', style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                        Container(
                          decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                          padding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
                          child: Row(
                            children: [
                              Image.asset(ic_star_fill, height: 16, color: rattingColor),
                              4.width,
                              Text('${data.rating.validate().toStringAsFixed(1).toString()}', style: primaryTextStyle()),
                            ],
                          ),
                        ),
                      ],
                    ),
                    data.createdAt.validate().isNotEmpty ? Text(formatDate('${DateTime.parse(data.createdAt.validate())}', format: DATE_FORMAT_4), style: secondaryTextStyle()) : SizedBox(),
                    if (showServiceName) Text('${languages.lblService}: ${data.serviceName.validate()}', style: primaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis).paddingTop(8),
                  ],
                ).flexible(),
              ],
            ),
            if (data.review != null) ...[
              8.height,
              ReadMoreText(
                data.review.validate(),
                style: secondaryTextStyle(),
                trimLength: 100,
                colorClickableText: context.primaryColor,
              ).paddingLeft(isRTL ? 0 : 4).paddingRight(isRTL ? 4 : 0),
            ]
          ],
        ),
      ),
    );
  }
}
