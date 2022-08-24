import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/providers/company/company_data_provider.dart';
import 'package:stocks/providers/company/company_info_provider.dart';
import 'package:stocks/screen/screen_company_info/model/chart_data_model.dart';
import 'package:stocks/screen/screen_company_info/news/news_list.dart';
import 'package:stocks/screen/screen_company_info/quote/screen/quote_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ComapanyInfoPage extends ConsumerStatefulWidget {
  const ComapanyInfoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ComapanyInfoPageState();
}

class _ComapanyInfoPageState extends ConsumerState<ComapanyInfoPage> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<ChartDataModel>> companyMonthlyData =
        ref.watch(companyDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(companyInfoProvider).companySymbol),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _chart(companyMonthlyData),
            QuoteWidget(),
            const NewsList(),
          ],
        ),
      ),
    );
  }

  Widget _chart(AsyncValue<List<ChartDataModel>> companyMonthlyData) {
    return companyMonthlyData.when(
      data: (data) {
        log('chartData recieved');
        return _chartWidget(data);
      },
      error: ((error, stackTrace) {
        log('chartData error');
        return _chartWidget([]);
      }),
      loading: (() {
        log('chartData loading');
        return _chartWidget([]);
      }),
    );
  }

  SfCartesianChart _chartWidget(List<ChartDataModel> companyMonthlyData) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
      series: <ChartSeries<ChartDataModel, DateTime>>[
        FastLineSeries<ChartDataModel, DateTime>(
          dataSource: companyMonthlyData,
          xValueMapper: (datum, index) => datum.timeStamp,
          yValueMapper: (datum, index) => datum.close,
        )
      ],
    );
  }
}
