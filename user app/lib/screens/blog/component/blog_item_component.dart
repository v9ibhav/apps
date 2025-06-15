import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/blog/model/blog_response_model.dart';
import 'package:booking_system_flutter/screens/blog/view/blog_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/image_border_component.dart';

class BlogItemComponent extends StatefulWidget {
  final BlogData? blogData;

  BlogItemComponent({this.blogData});

  @override
  State<BlogItemComponent> createState() => _BlogItemComponentState();
}

class _BlogItemComponentState extends State<BlogItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlogDetailScreen(blogId: widget.blogData!.id.validate()).launch(context);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: context.cardColor,
          border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              url: widget.blogData!.imageAttachments.validate().isNotEmpty ? widget.blogData!.imageAttachments!.first.validate() : '',
              fit: BoxFit.cover,
              height: 80,
              width: 80,
              radius: defaultRadius,
            ),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.blogData!.title.validate(),
                  style: boldTextStyle(size: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                6.height,
                Row(
                  children: [
                    Row(
                      children: [
                        ImageBorder(
                          src: widget.blogData!.authorImage.validate(),
                          height: 30,
                        ),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.blogData!.authorName.validate(), style: primaryTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                            2.height,
                            Text(widget.blogData!.publishDate.validate(), style: secondaryTextStyle(size: 10)),
                          ],
                        ).expand(),
                      ],
                    ).expand(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.remove_red_eye, size: 14, color: context.iconColor),
                        4.width,
                        Text('${widget.blogData!.totalViews.validate()} ', style: secondaryTextStyle()),
                        Text(language.views, style: secondaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    )
                  ],
                ),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}
