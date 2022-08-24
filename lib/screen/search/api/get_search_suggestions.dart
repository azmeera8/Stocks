import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stocks/keys/keys.dart';
import 'package:stocks/models/Company/company_info.dart';

Future<List<CompanyInfo>> getSuggestions(String query) async {
  if (query.trim().isEmpty) return [];
  try {
    var httpQuery =
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$query&apikey=$apiKey';
    // ignore: unused_local_variable
    var demo =
        'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=tesco&apikey=demo';
    Response<dynamic> response = await Dio().get(httpQuery);
    Map<String, dynamic> data = json.decode(response.toString());
    log(data.toString());
    List<dynamic> companies = data["bestMatches"];
    List<CompanyInfo> companyInfoList = [];
    for (var companyInfo in companies) {
      String comanySymbol = companyInfo["1. symbol"];
      String companyName = companyInfo["2. name"];
      companyInfoList.add(
        CompanyInfo(companySymbol: comanySymbol, companyName: companyName),
      );
    }
    companyInfoList = companyInfoList.toSet().toList();
    return companyInfoList;
  } catch (e) {
    log(e.toString());
    return [];
  } finally {}
}
