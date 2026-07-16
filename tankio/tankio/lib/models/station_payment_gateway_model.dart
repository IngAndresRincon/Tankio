class StationPaymentGatewayModel {
  final int groupId;
  final String groupName;
  final String companyName;
  final String webPage;
  final int stationId;
  final String stationName;
  final int stationTypeId;
  final bool active;
  final String uuid;
  final List<StationGatewayModel> paymentGateways;

  StationPaymentGatewayModel({
    required this.groupId,
    required this.groupName,
    required this.companyName,
    required this.webPage,
    required this.stationId,
    required this.stationName,
    required this.stationTypeId,
    required this.active,
    required this.uuid,
    required this.paymentGateways,
  });

  factory StationPaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    return StationPaymentGatewayModel(
      groupId: (json['group_id'] as num?)?.toInt() ?? 0,
      groupName: json['group_name'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      webPage: json['web_page'] as String? ?? '',
      stationId: (json['station_id'] as num?)?.toInt() ?? 0,
      stationName: json['station_name'] as String? ?? '',
      stationTypeId: (json['station_type_id'] as num?)?.toInt() ?? 0,
      active: json['active'] as bool? ?? false,
      uuid: json['uuid'] as String? ?? '',
      paymentGateways:
          (json['payment_gateways'] as List<dynamic>?)
              ?.map(
                (item) => StationGatewayModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'company_name': companyName,
      'web_page': webPage,
      'station_id': stationId,
      'station_name': stationName,
      'station_type_id': stationTypeId,
      'active': active,
      'uuid': uuid,
      'payment_gateways': paymentGateways.map((e) => e.toJson()).toList(),
    };
  }
}

class StationGatewayModel {
  final int id;
  final String code;
  final String name;
  final bool test;
  final bool enabled;
  final Map<String, dynamic>? settings;
  final bool isDefault;
  final Map<String, dynamic>? credentials;
  final int environment;
  final int transactionFee;

  StationGatewayModel({
    required this.id,
    required this.code,
    required this.name,
    required this.test,
    required this.enabled,
    required this.settings,
    required this.isDefault,
    required this.credentials,
    required this.environment,
    required this.transactionFee,
  });

  factory StationGatewayModel.fromJson(Map<String, dynamic> json) {
    return StationGatewayModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      test: json['test'] as bool? ?? false,
      enabled: json['enabled'] as bool? ?? false,
      settings: json['settings'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['settings'] as Map)
          : null,
      isDefault: json['is_default'] as bool? ?? false,
      credentials: json['credentials'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['credentials'] as Map)
          : null,
      environment: (json['environment'] as num?)?.toInt() ?? 0,
      transactionFee: (json['transaction_fee'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'test': test,
      'enabled': enabled,
      'settings': settings,
      'is_default': isDefault,
      'credentials': credentials,
      'environment': environment,
      'transaction_fee': transactionFee,
    };
  }
}
