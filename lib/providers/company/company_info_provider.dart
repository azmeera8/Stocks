//shows company info
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/models/Company/company_info.dart';

class CompanyInfoNotifier extends StateNotifier<CompanyInfo> {
  CompanyInfoNotifier()
      : super(
          const CompanyInfo(companySymbol: '', companyName: ''),
        );

  void update(CompanyInfo companyInfo) {
    state = companyInfo;
  }
}

final companyInfoProvider =
    StateNotifierProvider<CompanyInfoNotifier, CompanyInfo>((ref) {
  return CompanyInfoNotifier();
});
