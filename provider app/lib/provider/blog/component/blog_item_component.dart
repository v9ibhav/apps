import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/cached_image_widget.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/provider/blog/blog_repository.dart';
import 'package:handyman_provider_flutter/provider/blog/model/blog_response_model.dart';
import 'package:handyman_provider_flutter/provider/blog/view/add_blog_screen.dart';
import 'package:handyman_provider_flutter/provider/blog/view/blog_detail_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class BlogItemComponent extends StatefulWidget {
  final BlogData? blogData;
  final VoidCallback? callBack;

  BlogItemComponent({this.blogData, this.callBack});

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

  Future<void> deleteBlog(int? id) async {
    appStore.setLoading(true);

    await deleteBlogAPI(id).then((value) {
      appStore.setLoading(false);

      widget.callBack?.call();
      toast(value.message);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            height: 85,
            width: 85,
            radius: defaultRadius,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.blogData!.title.validate(),
                style: boldTextStyle(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              2.height,
              Text(parseHtmlString(widget.blogData!.description.validate()), style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
              4.height,
               if (rolesAndPermissionStore.blogEdit || rolesAndPermissionStore.blogDelete)
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (rolesAndPermissionStore.blogEdit)
                    Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationDefault(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent.withValues(alpha:0.5),
                    ),
                    child: Icon(Icons.edit, size: 12, color: white),
                  ).onTap(() {
                    ifNotTester(context, () async {
                      bool? res = await AddBlogScreen(data: widget.blogData).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                      if (res ?? false) {
                        widget.callBack!.call();
                      }
                    });
                  }, hoverColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  12.width,
                  if (rolesAndPermissionStore.blogDelete)
                    Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationDefault(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withValues(alpha:0.5),
                    ),
                    child: Icon(Icons.delete, size: 12, color: white)
                  ).onTap(() {
                    ifNotTester(context, () async {
                      showConfirmDialogCustom(
                        context,
                        dialogType: DialogType.DELETE,
                        title: languages.deleteBlogTitle,
                        positiveText: languages.lblDelete,
                        negativeText: languages.lblCancel,
                        onAccept: (v) async {
                          await deleteBlog(widget.blogData!.id.validate());
                        },
                      );
                    });
                  }, hoverColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                  4.width,
                ],
              ),
            ],
          ).expand(),
        ],
      ).onTap(() {
        BlogDetailScreen(blogId: widget.blogData!.id.validate()).launch(context);
      }, hoverColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent),
    );
  }
}
