import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:stocks/keys/keys.dart';
import 'package:stocks/models/Company/company_info.dart';

import '../models/cse_thumbnail.dart';
import '../models/news_model.dart';

Future<List<NewsModel>> getNewsList(CompanyInfo companyInfo) async {
  try {
    String httpStarter =
        'https://www.googleapis.com/customsearch/v1/siterestrict?';
    String params =
        'key=$googleNewsApiKey&cx=$searchEngineID&q=${companyInfo.companyName}&sort=date';
    String httpQuery = httpStarter + params;
    Response<dynamic> response = await Dio().get(httpQuery);
    Map<String, dynamic> data = json.decode(response.toString());
    List<dynamic> newsArticles = data['items'];

    List<NewsModel> newsModelList = [];
    for (var articleJson in newsArticles) {
      String title = articleJson['title'] ?? '';
      String link = articleJson['link'] ?? '';
      String displayLink = articleJson['displayLink'] ?? '';
      String snippet = articleJson['snippet'] ?? '';
      String description =
          articleJson['pagemap']?['metatags']?[0]?['og:description'] ?? '';
      String imageSrc =
          articleJson['pagemap']?['cse_thumbnail']?[0]?['src'] ?? '';
      int width = int.tryParse(
              articleJson['pagemap']?['cse_thumbnail']?[0]?['width'] ?? '') ??
          200;
      int height = int.tryParse(
              articleJson['pagemap']?['cse_thumbnail']?[0]?['height'] ?? '') ??
          100;

      var newsModel = NewsModel(
          title: title,
          link: link,
          displayLink: displayLink,
          snippet: snippet,
          description: description,
          cseThumbnail:
              CSEThumbnail(src: imageSrc, width: width, height: height));
      newsModelList.add(newsModel);
    }
    return newsModelList;
  } catch (e) {
    log(e.toString());
    return [];
  }
}
