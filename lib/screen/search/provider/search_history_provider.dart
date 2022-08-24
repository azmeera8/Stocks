import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/models/Company/company_info.dart';

import '../sql/Suggestions/suggestions_db_helper.dart';

class SearchHistoryNotifier extends StateNotifier<List<CompanyInfo>> {
  SearchHistoryNotifier() : super([]);

  Future getSearchHistory() async {
    var searchHistoryList = await SuggestionsDBHelper.instance.queryAllRows();
    List<CompanyInfo> companyInfoList = [];
    for (var searchHistoryItem in searchHistoryList) {
      var companyName = searchHistoryItem['company_name'];
      var companySymbol = searchHistoryItem['company_symbol'];
      companyInfoList.add(
          CompanyInfo(companySymbol: companySymbol, companyName: companyName));
    }
    state = companyInfoList;
  }

  Future updateSearchHistory() async {
    await getSearchHistory();
  }
}

final searchHistoryProvider =
    StateNotifierProvider<SearchHistoryNotifier, List<CompanyInfo>>((ref) {
  return SearchHistoryNotifier();
});

// final searchHistoryProvider = FutureProvider<List<CompanyInfo>>((ref) async {
  
// });