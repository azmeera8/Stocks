import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/models/Company/company_info.dart';
import 'package:stocks/screen/search/api/get_search_suggestions.dart';

class SuggestionsNotifier extends StateNotifier<List<CompanyInfo>> {
  SuggestionsNotifier() : super([]);

  void getSuggestionsList(String query) async {
    state = await getSuggestions(query);
  }
}

final suggestionsProvider =
    StateNotifierProvider<SuggestionsNotifier, List<CompanyInfo>>((ref) {
  return SuggestionsNotifier();
});
