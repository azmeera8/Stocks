import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/screen/screen_company_info/news/news_list.dart';

class TestSceen extends ConsumerStatefulWidget {
  const TestSceen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestSceenState();
}

class _TestSceenState extends ConsumerState<TestSceen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test Screen'),
        ),
        body: const NewsList(),
      ),
    );
  }
}
