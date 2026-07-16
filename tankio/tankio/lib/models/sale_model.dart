class SaleModel {
  final int saleId;
  final int systemId;
  final String systemName;
  final String stationName;
  final int positionId;
  final int hoseId;
  final String productName;
  final num price;
  final num money;
  final num volume;
  final num power;
  final num totalPower;
  final String initialDateSale;
  final String finalDateSale;
  final bool zeroSale;
  final String saleUuid;
  final int programmingId;
  final int groupId;
  final String groupName;
  final String companyName;
  final int stationId;
  final String stationAddress;
  final String identifier;
  final int userId;
  final int controllerId;
  final String programmingType;
  final num programmingMoney;
  final int programmingStatusId;
  final num balance;
  final bool booking;
  final String registrationDate;

  SaleModel({
    required this.saleId,
    required this.systemId,
    required this.systemName,
    required this.stationName,
    required this.positionId,
    required this.hoseId,
    required this.productName,
    required this.price,
    required this.money,
    required this.volume,
    required this.power,
    required this.totalPower,
    required this.initialDateSale,
    required this.finalDateSale,
    required this.zeroSale,
    required this.saleUuid,
    required this.programmingId,
    required this.groupId,
    required this.groupName,
    required this.companyName,
    required this.stationId,
    required this.stationAddress,
    required this.identifier,
    required this.userId,
    required this.controllerId,
    required this.programmingType,
    required this.programmingMoney,
    required this.programmingStatusId,
    required this.balance,
    required this.booking,
    required this.registrationDate,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      saleId: (json['sale_id'] as num?)?.toInt() ?? 0,
      systemId: (json['system_id'] as num?)?.toInt() ?? 0,
      systemName: json['system_name'] as String? ?? '',
      stationName: json['station_name'] as String? ?? '',
      positionId: (json['position_id'] as num?)?.toInt() ?? 0,
      hoseId: (json['hose_id'] as num?)?.toInt() ?? 0,
      productName: json['product_name'] as String? ?? '',
      price: _toNum(json['price']),
      money: _toNum(json['money']),
      volume: _toNum(json['volume']),
      power: _toNum(json['power']),
      totalPower: _toNum(json['total_power']),
      initialDateSale: json['initial_date_sale'] as String? ?? '',
      finalDateSale: json['final_date_sale'] as String? ?? '',
      zeroSale: json['zero_sale'] as bool? ?? false,
      saleUuid: json['sale_uuid'] as String? ?? '',
      programmingId: (json['programming_id'] as num?)?.toInt() ?? 0,
      groupId: (json['group_id'] as num?)?.toInt() ?? 0,
      groupName: json['group_name'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      stationId: (json['station_id'] as num?)?.toInt() ?? 0,
      stationAddress: json['station_address'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      controllerId: (json['controller_id'] as num?)?.toInt() ?? 0,
      programmingType: json['programming_type'] as String? ?? '',
      programmingMoney: _toNum(json['programming_money']),
      programmingStatusId:
          (json['programming_status_id'] as num?)?.toInt() ?? 0,
      balance: _toNum(json['balance']),
      booking: json['booking'] as bool? ?? false,
      registrationDate: json['registration_date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sale_id': saleId,
      'system_id': systemId,
      'system_name': systemName,
      'station_name': stationName,
      'position_id': positionId,
      'hose_id': hoseId,
      'product_name': productName,
      'price': price,
      'money': money,
      'volume': volume,
      'power': power,
      'total_power': totalPower,
      'initial_date_sale': initialDateSale,
      'final_date_sale': finalDateSale,
      'zero_sale': zeroSale,
      'sale_uuid': saleUuid,
      'programming_id': programmingId,
      'group_id': groupId,
      'group_name': groupName,
      'company_name': companyName,
      'station_id': stationId,
      'station_address': stationAddress,
      'identifier': identifier,
      'user_id': userId,
      'controller_id': controllerId,
      'programming_type': programmingType,
      'programming_money': programmingMoney,
      'programming_status_id': programmingStatusId,
      'balance': balance,
      'booking': booking,
      'registration_date': registrationDate,
    };
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
