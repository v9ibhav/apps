// region Blog API

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/network_utils.dart';
import 'package:booking_system_flutter/screens/blog/model/blog_detail_response.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import 'model/blog_response_model.dart';

Future<List<BlogData>> getBlogListAPI({int? page, required List<BlogData> blogData, Function(bool)? lastPageCallback}) async {
  try {
    BlogResponse res = BlogResponse.fromJson(await handleResponse(await buildHttpResponse('blog-list?status=1&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)));

    if (page == 1) blogData.clear();

    blogData.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    cachedBlogList = blogData;

    return blogData;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

//endregion

// region Get Blog Detail API
Future<BlogDetailResponse> getBlogDetailAPI(Map request) async {
  try {
    BlogDetailResponse res = BlogDetailResponse.fromJson(await handleResponse(await buildHttpResponse('blog-detail', request: request, method: HttpMethodType.POST)));

    appStore.setLoading(false);
    if (!cachedBlogDetail.any((element) => element?.$1 == request[BlogKey.blogId])) {
      cachedBlogDetail.add((request[BlogKey.blogId], res));
    } else {
      int index = cachedBlogDetail.indexWhere((element) => element?.$1 == request[BlogKey.blogId]);
      cachedBlogDetail[index] = (request[BlogKey.blogId], res);
    }
    return res;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion
