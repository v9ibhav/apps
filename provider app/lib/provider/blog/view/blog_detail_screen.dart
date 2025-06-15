import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:handyman_provider_flutter/provider/blog/blog_repository.dart';
import 'package:handyman_provider_flutter/provider/blog/component/blog_detail_header_component.dart';
import 'package:handyman_provider_flutter/provider/blog/model/blog_detail_response.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/back_widget.dart';
import '../../../components/cached_image_widget.dart';
import '../../../components/empty_error_state_widget.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../services/shimmer/service_detail_shimmer.dart';

class BlogDetailScreen extends StatefulWidget {
  final int blogId;

  BlogDetailScreen({required this.blogId});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
  }

  Widget buildBodyWidget(AsyncSnapshot<BlogDetailResponse> snap) {
    if (snap.hasData) {
      return Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        body: AnimatedScrollView(
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlogDetailHeaderComponent(blogData: snap.data!.blogDetail!),
            16.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snap.data!.blogDetail!.title.validate(),
                    style: boldTextStyle(size: 20)),
                12.height,
                Row(
                  children: [
                    CachedImageWidget(
                      url: snap.data!.blogDetail!.authorImage.validate(),
                      height: 32,
                      circle: true,
                      fit: BoxFit.cover,
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snap.data!.blogDetail!.authorName.validate(),
                            style: boldTextStyle(size: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        if (snap.data!.blogDetail!.publishDate
                            .validate()
                            .isNotEmpty)
                          2.height,
                        if (snap.data!.blogDetail!.publishDate
                            .validate()
                            .isNotEmpty)
                          Text(
                            "${snap.data!.blogDetail!.publishDate.validate()}",
                            style:
                                secondaryTextStyle(color: textSecondaryColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                      ],
                    ).expand(flex: 2),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 14,
                          color: context.iconColor,
                        ),
                        Text(
                          '${parseHtmlString(snap.data!.blogDetail!.description.validate()).getEstimatedTimeInMin()} ${languages.minRead}',
                          style: secondaryTextStyle(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                16.height,
                // HTMLFormatComponent(postContent: snap.data!.blogDetail!.description.validate()),
                Html(
                  data: snap.data!.blogDetail!.description.validate(),
                  style: {
                    "span": Style(
                      color: appStore.isDarkMode ? Colors.white : Colors.black,
                    ),
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: snap.connectionState == ConnectionState.waiting
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: transparentColor,
              leading: Container(
                  margin: EdgeInsets.only(left: 6),
                  padding: EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: BackWidget(color: context.iconColor)),
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness:
                      appStore.isDarkMode ? Brightness.light : Brightness.dark,
                  statusBarColor: context.scaffoldBackgroundColor),
            ),
      body: snapWidgetHelper(
        snap,
        loadingWidget: ServiceDetailShimmer(),
        errorWidget: NoDataWidget(
          title: snap.error.toString(),
          imageWidget: ErrorStateWidget(),
          retryText: languages.reload,
          onRetry: () {
            getBlogDetailAPI({AddBlogKey.blogId: widget.blogId.validate()});
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BlogDetailResponse>(
      future: getBlogDetailAPI({AddBlogKey.blogId: widget.blogId.validate()}),
      builder: (context, snap) {
        return buildBodyWidget(snap);
      },
    );
  }
}
