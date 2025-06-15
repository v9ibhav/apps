import 'package:booking_system_flutter/screens/booking/handyman_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../model/user_data_model.dart';
import '../../../utils/constant.dart';

class HandymanStaffMembersComponent extends StatelessWidget {
  final List<UserData> handymanList;

  HandymanStaffMembersComponent({required this.handymanList});

  @override
  Widget build(BuildContext context) {
    if (handymanList.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${language.team} (${ handymanList.length})" , style: boldTextStyle(size: LABEL_TEXT_SIZE)).paddingSymmetric(horizontal: 16),
        10.height,
        HorizontalList(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: handymanList.length,
          itemBuilder: (context, index) {
            final handyman = handymanList[index];

            return Padding(
              padding: const EdgeInsets.only(
                right: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(color: context.cardColor, borderRadius: radius()),
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
                child: Row(
                  children: [
                    Container(
                      child: ClipOval(
                        child: Image.network(
                          handyman.profileImage.validate(),
                          fit: BoxFit.cover,
                          height: 35,
                          width: 35,
                        ),
                      ),
                    ),
                    10.width,
                    Text(
                      handyman.firstName.validate(),
                      style: boldTextStyle(size: 12),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ).onTap(() {
              HandymanInfoScreen(handymanId: handyman.id).launch(context);
            }, splashColor: Colors.transparent, highlightColor: Colors.transparent);
          },
        )
      ],
    );
  }
}
