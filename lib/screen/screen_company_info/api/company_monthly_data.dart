import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stocks/keys/keys.dart';
import 'package:stocks/screen/screen_company_info/model/chart_data_model.dart';

Future<List<ChartDataModel>> getCompanyMonthlyData(String companySymbol) async {
  if (companySymbol.trim().isEmpty) return [];
  try {
    final tempDir = await getTemporaryDirectory();
    final pathName = "${tempDir.path}/$companySymbol";
    var httpRequest =
        'https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=$companySymbol&apikey=$apiKey&datatype=csv';

    // ignore: unused_local_variable
    var demo =
        'https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=IBM&apikey=demo&datatype=csv';

    await Dio().download(httpRequest, pathName);

    final input = File(pathName).openRead();

    final monthlyFields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    monthlyFields.removeAt(0);

    //extracting monthly closing fields
    List<ChartDataModel> chartDataList = [];

    for (var field in monthlyFields) {
      //closing value
      double monthClose = double.parse(field[4].toString());

      //time value in string in yyyy-mm-dd
      String timeStamp = field[0].toString();
      chartDataList.add(ChartDataModel(
          timeStamp: DateTime.parse(timeStamp), close: monthClose));
    }
    return chartDataList;
  } catch (e) {
    log(e.toString());
    return [];
  }
}
