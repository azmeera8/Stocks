import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/providers/company/company_info_provider.dart';
import 'package:stocks/screen/screen_company_info/quote/model/quote_model.dart';
import 'package:stocks/screen/screen_company_info/quote/provider/quote_provider.dart';

class QuoteWidget extends ConsumerStatefulWidget {
  const QuoteWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends ConsumerState<QuoteWidget> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<QuoteModel> quoteModel = ref.watch(quoteProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: quoteModel.when(
        data: ((data) {
          return [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 4, 0),
              child: Text(
                ref.watch(companyInfoProvider).companySymbol.endsWith('BSE')
                    ? '₹'
                    : '\$',
                textScaleFactor: 1.25,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                data.price.toString(),
                textScaleFactor: 1.25,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: Text(
                data.change.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: data.change < 0 ? Colors.red : Colors.green),
              ),
            ),
          ];
        }),
        error: (error, stackTrace) {
          log('error loading quote');
          return [const SizedBox.shrink()];
        },
        loading: () => [const SizedBox.shrink()],
      ),
    );
  }
}
