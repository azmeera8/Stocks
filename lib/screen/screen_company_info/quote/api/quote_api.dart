import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:stocks/models/Company/company_info.dart';
import 'package:stocks/screen/screen_company_info/quote/model/quote_model.dart';
import 'package:stocks/keys/keys.dart';

Future<QuoteModel> getQuote(CompanyInfo companyInfo) async {
  try {
    String httpQuery =
        'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${companyInfo.companySymbol}&apikey=$apiKey';
    var response = await Dio().get(httpQuery);
    Map<String, dynamic> data = json.decode(response.toString());
    log(data.toString());
    double price = double.parse(data['Global Quote']?['05. price']);
    double change = double.parse(data['Global Quote']?['09. change']);
    return QuoteModel(price: price, change: change);
  } catch (e) {
    log(e.toString());
    return QuoteModel(price: 0, change: 0);
  }
}
