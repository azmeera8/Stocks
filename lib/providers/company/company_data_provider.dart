import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/providers/company/company_info_provider.dart';
import 'package:stocks/screen/screen_company_info/model/chart_data_model.dart';
import 'package:stocks/screen/screen_company_info/api/company_monthly_data.dart';

final companyDataProvider = FutureProvider<List<ChartDataModel>>((ref) async {
  var companySymbol = ref.watch(companyInfoProvider).companySymbol;
  log(companySymbol);
  List<ChartDataModel> monthlyData = await getCompanyMonthlyData(companySymbol);
  return monthlyData;
});
