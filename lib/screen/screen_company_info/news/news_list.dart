import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/screen/screen_company_info/news/models/news_model.dart';
import 'package:stocks/screen/screen_company_info/news/provider/%20news_list_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsList extends ConsumerStatefulWidget {
  const NewsList({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsListState();
}

class _NewsListState extends ConsumerState<NewsList> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<NewsModel>> newsList = ref.watch(newsListProvider);
    return newsList.when(data: (newsList) {
      log('news list items : ${newsList.length}');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Text(
              'News',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: ((context, index) => _newsItem(newsList, index)),
            itemCount: newsList.length,
          ),
        ],
      );
    }, error: (error, stackTrace) {
      log('news error');
      return const SizedBox.shrink();
    }, loading: () {
      log('news loading');
      return const SizedBox.shrink();
    });
  }

  Widget _newsItem(List<NewsModel> newsList, int index) => Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newsList[index].title!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(newsList[index].displayLink!),
                Text(newsList[index].description!),
              ],
            ),
          ),
          onTap: () async {
            var link = newsList[index].link;
            if (!await launchUrl(Uri.parse(link!))) {
              throw 'Could not launch $link';
            }
          },
        ),
      );

  Future<void> _openLink(String link) async {
    if (!await launchUrl(Uri.parse(link))) {
      throw 'Could not launch $link';
    }
  }
}
