import 'package:flutter/material.dart';

@immutable
class CompanyInfo {
  final String companySymbol;
  final String companyName;
  const CompanyInfo({required this.companySymbol, required this.companyName});

  @override
  String toString() {
    return 'CompanyInfo(companySymbol:$companySymbol,companyName : $companyName)';
  }
}
