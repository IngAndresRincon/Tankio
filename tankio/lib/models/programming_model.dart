class ProgrammingResponseModel {
  final int id;
  final int stationId;
  final int userId;
  final String identifier;
  final int dispenserId;
  final int positionId;
  final int hoseId;
  final int price;
  final String programmingType;
  final double programmingValue;
  final int programmingMoney;
  final int programmingStatusId;
  final int balance;
  final int systemId;
  final int sourceId;
  final bool localPayment;
  final bool booking;
  final bool active;
  final String uuid;
  final DateTime registrationDate;

  ProgrammingResponseModel({
    required this.id,
    required this.stationId,
    required this.userId,
    required this.identifier,
    required this.dispenserId,
    required this.positionId,
    required this.hoseId,
    required this.price,
    required this.programmingType,
    required this.programmingValue,
    required this.programmingMoney,
    required this.programmingStatusId,
    required this.balance,
    required this.systemId,
    required this.sourceId,
    required this.localPayment,
    required this.booking,
    required this.active,
    required this.uuid,
    required this.registrationDate,
  });

  factory ProgrammingResponseModel.fromJson(Map<String, dynamic> json) {
    return ProgrammingResponseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      stationId: (json['station_id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      identifier: json['identifier'] as String? ?? '',
      dispenserId: (json['dispenser_id'] as num?)?.toInt() ?? 0,
      positionId: (json['position_id'] as num?)?.toInt() ?? 0,
      hoseId: (json['hose_id'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toInt() ?? 0,
      programmingType: json['programming_type'] as String? ?? '',
      programmingValue: (json['programming_value'] as num?)?.toDouble() ?? 0.0,
      programmingMoney: (json['programming_money'] as num?)?.toInt() ?? 0,
      programmingStatusId:
          (json['programming_status_id'] as num?)?.toInt() ?? 0,
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      systemId: (json['system_id'] as num?)?.toInt() ?? 0,
      sourceId: (json['source_id'] as num?)?.toInt() ?? 0,
      localPayment: json['local_payment'] as bool? ?? false,
      booking: json['booking'] as bool? ?? false,
      active: json['active'] as bool? ?? false,
      uuid: json['uuid'] as String? ?? '',
      registrationDate:
          DateTime.tryParse(json['registration_date'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'user_id': userId,
      'identifier': identifier,
      'dispenser_id': dispenserId,
      'position_id': positionId,
      'hose_id': hoseId,
      'price': price,
      'programming_type': programmingType,
      'programming_value': programmingValue,
      'programming_money': programmingMoney,
      'programming_status_id': programmingStatusId,
      'balance': balance,
      'system_id': systemId,
      'source_id': sourceId,
      'local_payment': localPayment,
      'booking': booking,
      'active': active,
      'uuid': uuid,
      'registration_date': registrationDate.toIso8601String(),
    };
  }
}

class ProgrammingModel {
  final int programmingId;
  final int stationId;
  final String stationName;
  final double latitude;
  final double longitude;
  final int stationTypeId;
  final String address;
  final int userId;
  final String identifier;
  final String vehicleModel;
  final String vehicleBrand;
  final int controllerId;
  final int positionId;
  final int hoseId;
  final int hoseNumber;
  final String hoseCode;
  final int productId;
  final String productName;
  final String productCode;
  final String color;
  final int price;
  final String programmingType;
  final double programmingValue;
  final int programmingMoney;
  late int programmingStatusId;
  final String status;
  final String description;
  final int balance;
  final int systemId;
  final String systemName;
  final int sourceId;
  final bool booking;
  final String uuid;
  final String registrationDate;

  ProgrammingModel({
    required this.programmingId,
    required this.stationId,
    required this.stationName,
    required this.latitude,
    required this.longitude,
    required this.stationTypeId,
    required this.address,
    required this.userId,
    required this.identifier,
    required this.vehicleModel,
    required this.vehicleBrand,
    required this.controllerId,
    required this.positionId,
    required this.hoseId,
    required this.hoseNumber,
    required this.hoseCode,
    required this.productId,
    required this.productName,
    required this.productCode,
    required this.color,
    required this.price,
    required this.programmingType,
    required this.programmingValue,
    required this.programmingMoney,
    required this.programmingStatusId,
    required this.status,
    required this.description,
    required this.balance,
    required this.systemId,
    required this.systemName,
    required this.sourceId,
    required this.booking,
    required this.uuid,
    required this.registrationDate,
  });

  factory ProgrammingModel.fromJson(Map<String, dynamic> json) {
    return ProgrammingModel(
      programmingId: (json['programming_id'] as num?)?.toInt() ?? 0,
      stationId: (json['station_id'] as num?)?.toInt() ?? 0,
      stationName: json['station_name'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      stationTypeId: (json['station_type_id'] as num?)?.toInt() ?? 0,
      address: json['address'] as String? ?? '',
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      identifier: json['identifier'] as String? ?? '',
      vehicleModel: json['vehicle_model'] as String? ?? '',
      vehicleBrand: json['vehicle_brand'] as String? ?? '',
      controllerId: (json['controller_id'] as num?)?.toInt() ?? 0,
      positionId: (json['position_id'] as num?)?.toInt() ?? 0,
      hoseId: (json['hose_id'] as num?)?.toInt() ?? 0,
      hoseNumber: (json['hose_number'] as num?)?.toInt() ?? 0,
      hoseCode: json['hose_code'] as String? ?? '',
      productId: (json['product_id'] as num?)?.toInt() ?? 0,
      productName: json['product_name'] as String? ?? '',
      productCode: json['product_code'] as String? ?? '',
      color: json['color'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      programmingType: json['programming_type'] as String? ?? '',
      programmingValue: (json['programming_value'] as num?)?.toDouble() ?? 0.0,
      programmingMoney: (json['programming_money'] as num?)?.toInt() ?? 0,
      programmingStatusId:
          (json['programming_status_id'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String? ?? '').trim(),
      description: json['description'] as String? ?? '',
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      systemId: (json['system_id'] as num?)?.toInt() ?? 0,
      systemName: json['system_name'] as String? ?? '',
      sourceId: (json['source_id'] as num?)?.toInt() ?? 0,
      booking: json['booking'] as bool? ?? false,
      uuid: json['uuid'] as String? ?? '',
      registrationDate: json['registration_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'programming_id': programmingId,
      'station_id': stationId,
      'station_name': stationName,
      'latitude': latitude,
      'longitude': longitude,
      'station_type_id': stationTypeId,
      'address': address,
      'user_id': userId,
      'identifier': identifier,
      'vehicle_model': vehicleModel,
      'vehicle_brand': vehicleBrand,
      'controller_id': controllerId,
      'position_id': positionId,
      'hose_id': hoseId,
      'hose_number': hoseNumber,
      'hose_code': hoseCode,
      'product_id': productId,
      'product_name': productName,
      'product_code': productCode,
      'color': color,
      'price': price,
      'programming_type': programmingType,
      'programming_value': programmingValue,
      'programming_money': programmingMoney,
      'programming_status_id': programmingStatusId,
      'status': status,
      'description': description,
      'balance': balance,
      'system_id': systemId,
      'system_name': systemName,
      'source_id': sourceId,
      'booking': booking,
      'uuid': uuid,
      'registration_date': registrationDate,
    };
  }
}
