// ignore_for_file: non_constant_identifier_names
class SuggestionsModelClass{
  String id;
  String company_symbol="";
  String company_name="";
  
  SuggestionsModelClass({
    required this.id,
     required this.company_symbol,
     required this.company_name});


  @override
  String toString() {
    return 'SuggestionModel{id:$id,stCol1: $company_symbol, stCol2: $company_name}';
  }

  Map<String,dynamic> toMap() {
    return {
      'id':id,
      'company_symbol': company_symbol,
      'company_name': company_name
    };
  }

}