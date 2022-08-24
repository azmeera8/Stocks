import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:stocks/models/Company/company_info.dart';
import 'package:stocks/providers/company/company_info_provider.dart';

import 'package:stocks/screen/screen_company_info/screen/company_info_page.dart';
import 'package:stocks/screen/search/sql/Suggestions/suggestions_model_class.dart';

import 'package:stocks/utils/debouncer.dart';

import 'package:uuid/uuid.dart';

import '../provider/search_history_provider.dart';
import '../provider/suggestions_provider.dart';
import '../sql/Suggestions/suggestions_db_helper.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  List<CompanyInfo> searchHistoryList = [];
  final Debouncer _debouncer = Debouncer();

  @override
  void initState() {
    ref.read(searchHistoryProvider.notifier).updateSearchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<CompanyInfo> suggestionsList = ref.watch(suggestionsProvider);

    searchHistoryList = ref.watch(searchHistoryProvider).reversed.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search stocks"),
        ),
        body: Material(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _searchField(suggestionsList),
                  _suggestionsList(suggestionsList),
                  searchHistoryHeadingText(),
                  _searchHistoryList(searchHistoryList)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //search field widget
  Widget _searchField(List<CompanyInfo> suggestionsList) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(width: 1), borderRadius: BorderRadius.circular(4)),
      child: TextField(
        keyboardType: TextInputType.visiblePassword,
        style:
            const TextStyle(leadingDistribution: TextLeadingDistribution.even),
        autofocus: true,
        decoration: const InputDecoration(
          fillColor: Color.fromARGB(27, 175, 192, 219),
          focusedBorder: InputBorder.none,
        ),
        onChanged: (value) =>
            _searchFieldHandleOnTextChange(value, suggestionsList),
      ),
    );
  }

  //search field on text change
  void _searchFieldHandleOnTextChange(
      String value, List<CompanyInfo> suggestionList) {
    _debouncer.run(() {
      ref.read(suggestionsProvider.notifier).getSuggestionsList(value);
    });
  }

  //suggestions list
  Widget _suggestionsList(List<CompanyInfo> suggestionsList) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) {
        var companyInfo = suggestionsList[index];
        return _suggestionItem(companyInfo);
      }),
    );
  }

  //suggestion item
  Widget _suggestionItem(CompanyInfo companyInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Text(
                  companyInfo.companyName,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      leadingDistribution: TextLeadingDistribution.even),
                ),
              ),
            ),
            onTap: () async {
              ref.read(companyInfoProvider.notifier).update(companyInfo);

              bool isInserted = await SuggestionsDBHelper.instance.insert(
                  SuggestionsModelClass(
                      id: const Uuid().v1(),
                      company_symbol: companyInfo.companySymbol,
                      company_name: companyInfo.companyName));
              if (isInserted) {
                ref.read(searchHistoryProvider.notifier).getSearchHistory();
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComapanyInfoPage(),
                ),
              );
            }),
        Container(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }

  Widget searchHistoryHeadingText() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Search History',
          style: TextStyle(
            leadingDistribution: TextLeadingDistribution.even,
          ),
          textAlign: TextAlign.start,
          textScaleFactor: 1.25,
        ),
      );

  Widget _searchHistoryList(List<CompanyInfo> searchHistoryList) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: searchHistoryList.length,
      itemBuilder: ((context, index) {
        CompanyInfo companyInfo = searchHistoryList[index];
        return _searchHistoryItem(companyInfo);
      }),
    );
  }

  Widget _searchHistoryItem(CompanyInfo companyInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Text(
                companyInfo.companyName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    leadingDistribution: TextLeadingDistribution.even),
              ),
            ),
          ),
          onTap: () {
            ref.read(companyInfoProvider.notifier).update(companyInfo);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ComapanyInfoPage(),
              ),
            );
          },
        ),
        Container(
          height: 1,
          color: Colors.black,
        )
      ],
    );
  }
}
