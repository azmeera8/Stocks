import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/providers/company/company_info_provider.dart';
import 'package:stocks/screen/screen_company_info/quote/api/quote_api.dart';
import 'package:stocks/screen/screen_company_info/quote/model/quote_model.dart';

final quoteProvider = FutureProvider<QuoteModel>((ref) async {
  var companyInfo = ref.watch(companyInfoProvider);
  return getQuote(companyInfo);
});
