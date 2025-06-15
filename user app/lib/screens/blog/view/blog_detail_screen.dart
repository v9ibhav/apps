import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/blog/blog_repository.dart';
import 'package:booking_system_flutter/screens/blog/component/blog_detail_header_component.dart';
import 'package:booking_system_flutter/screens/blog/model/blog_detail_response.dart';
import 'package:booking_system_flutter/utils/extensions/string_extentions.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/image_border_component.dart';
import '../../../utils/common.dart';
import '../shimmer/blog_detail_shimmer.dart';

class BlogDetailScreen extends StatefulWidget {
  final int blogId;

  BlogDetailScreen({required this.blogId});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  Future<BlogDetailResponse>? future;
  int page = 1;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
    init();
  }

  void init() async {
    future = getBlogDetailAPI({BlogKey.blogId: widget.blogId.validate()});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SnapHelperWidget<BlogDetailResponse>(
        future: future,
        initialData: cachedBlogDetail.firstWhere((element) => element?.$1 == widget.blogId.validate(), orElse: () => null)?.$2,
        loadingWidget: BlogDetailShimmer(),
        onSuccess: (data) {
          return AnimatedScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            padding: EdgeInsets.only(bottom: 120),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlogDetailHeaderComponent(blogData: data.blogDetail!),
              16.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.blogDetail!.title.validate(), style: boldTextStyle(size: 20)),
                  8.height,
                  Row(
                    children: [
                      ImageBorder(
                        src: data.blogDetail!.authorImage.validate(),
                        height: 30,
                      ),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.blogDetail!.authorName.validate(), style: primaryTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (data.blogDetail!.publishDate.validate().isNotEmpty) 2.height,
                          if (data.blogDetail!.publishDate.validate().isNotEmpty)
                            Text(
                              "${data.blogDetail!.publishDate.validate()}",
                              style: secondaryTextStyle(size: 10),
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
                            '${parseHtmlString(data.blogDetail!.description.validate()).getEstimatedTimeInMin()} ${language.minRead}',
                            style: secondaryTextStyle(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  Html(
                    data: data.blogDetail!.description.validate(),
                    style: {
                      "span": Style(
                        color: appStore.isDarkMode ? Colors.white : Colors.black,
                      ),
                    },
                  )
                ],
              ).paddingSymmetric(horizontal: 16),
            ],
          );
        },
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            imageWidget: ErrorStateWidget(),
            retryText: language.reload,
            onRetry: () {
              page = 1;
              appStore.setLoading(true);

              init();
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
