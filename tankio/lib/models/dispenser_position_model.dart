class DispenserPositionModel {
  final String groupName;
  final String companyName;
  final String webPage;
  final int stationId;
  final String stationName;
  final String stationType;
  final double latitude;
  final double longitude;
  final String address;
  final int dispenserId;
  final String dispenserType;
  final int positionId;
  final int controllerId;
  final String status;
  final int positionNumber;
  final String positionCode;
  final int hoseId;
  final int hoseNumber;
  final String hoseCode;
  final int productId;
  final String product;
  final String productCode;
  final String color;
  final int priceId;
  final double price;
  final String currency;
  final String symbol;

  DispenserPositionModel({
    required this.groupName,
    required this.companyName,
    required this.webPage,
    required this.stationId,
    required this.stationName,
    required this.stationType,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.dispenserId,
    required this.dispenserType,
    required this.positionId,
    required this.controllerId,
    required this.status,
    required this.positionNumber,
    required this.positionCode,
    required this.hoseId,
    required this.hoseNumber,
    required this.hoseCode,
    required this.productId,
    required this.product,
    required this.productCode,
    required this.color,
    required this.priceId,
    required this.price,
    required this.currency,
    required this.symbol,
  });

  factory DispenserPositionModel.fromJson(Map<String, dynamic> json) {
    return DispenserPositionModel(
      groupName: json['group_name'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      webPage: json['web_page'] as String? ?? '',
      stationId: json['station_id'],
      stationName: json['station_name'] as String? ?? '',
      stationType: json['station_type'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      dispenserId: (json['dispenser_id'] as num?)?.toInt() ?? 0,
      dispenserType: json['dispenser_type'] as String? ?? '',
      positionId: (json['position_id'] as num?)?.toInt() ?? 0,
      controllerId: (json['controller_id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      positionNumber: (json['position_number'] as num?)?.toInt() ?? 0,
      positionCode: json['position_code'] as String? ?? '',
      hoseId: (json['hose_id'] as num?)?.toInt() ?? 0,
      hoseNumber: (json['hose_number'] as num?)?.toInt() ?? 0,
      hoseCode: json['hose_code'] as String? ?? '',
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      product: json['product'] as String? ?? '',
      productCode: json['product_code'] as String? ?? '',
      color: json['color'] as String? ?? '',
      priceId: (json['price_id'] as num?)?.toInt() ?? 0,
      price: double.parse(json['price'].toString()),
      currency: json['currency'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_name': groupName,
      'company_name': companyName,
      'web_page': webPage,
      'station_name': stationName,
      'station_type': stationType,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'dispenser_id': dispenserId,
      'dispenser_type': dispenserType,
      'position_id': positionId,
      'controller_id': controllerId,
      'status': status,
      'position_number': positionNumber,
      'position_code': positionCode,
      'hose_id': hoseId,
      'hose_number': hoseNumber,
      'hose_code': hoseCode,
      'product_id': productId,
      'product': product,
      'product_code': productCode,
      'color': color,
      'price_id': priceId,
      'price': price,
      'currency': currency,
      'symbol': symbol,
    };
  }
}
