// ignore_for_file: constant_identifier_names

import 'dart:core';

import 'package:stocks/models/Company/company_info.dart';

const COMPANY_NAME = 'company_name';
const COMPANY_SYMBOL = 'company_symbol';
const ID = 'id';

class SuggestionHistoryItem {
  CompanyInfo companyInfo =
      const CompanyInfo(companySymbol: '', companyName: '');
  int id = 0;

  SuggestionHistoryItem();

  SuggestionHistoryItem.fromMap(Map<String, dynamic> map) {
    id = int.parse(map[ID]!);
    String companyName = map[COMPANY_NAME]!;
    String companySymbol = map[COMPANY_SYMBOL]!;
    companyInfo =
        CompanyInfo(companySymbol: companySymbol, companyName: companyName);
  }

  Map<String, String> toMap() {
    var map = <String, String>{
      ID: id.toString(),
      COMPANY_NAME: companyInfo.companyName,
      COMPANY_SYMBOL: companyInfo.companySymbol
    };
    return map;
  }
}
