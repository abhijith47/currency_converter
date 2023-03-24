class CurrencyModel {
  final String name;
  final String rate;
  final String symbol;

  CurrencyModel({
    required this.name,
    required this.rate,
    required this.symbol,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rate': rate,
      'symbol': symbol,
    };
  }
}
