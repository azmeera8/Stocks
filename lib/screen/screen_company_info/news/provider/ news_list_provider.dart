import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/providers/company/company_info_provider.dart';

import 'package:stocks/screen/screen_company_info/news/api/get_news_list.dart';
import 'package:stocks/screen/screen_company_info/news/models/news_model.dart';

final newsListProvider = FutureProvider<List<NewsModel>>((ref) async {
  var companyInfo = ref.watch(companyInfoProvider);
  log(companyInfo.toString());
  List<NewsModel> newsList = await getNewsList(companyInfo);
  return newsList;
});
