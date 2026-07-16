class BalanceMovementModel {
  final int balanceMovementId;
  final int groupId;
  final int stationId;
  final int userId;
  final num amount;
  final int balanceMovementTypeId;
  final String movement;
  final bool synchronized;
  final String balanceMovementUui;
  final String groupName;
  final String companyName;
  final String stationName;
  final String address;
  final String registrationDate;

  BalanceMovementModel({
    required this.balanceMovementId,
    required this.groupId,
    required this.stationId,
    required this.userId,
    required this.amount,
    required this.balanceMovementTypeId,
    required this.movement,
    required this.synchronized,
    required this.balanceMovementUui,
    required this.groupName,
    required this.companyName,
    required this.stationName,
    required this.address,
    required this.registrationDate,
  });

  factory BalanceMovementModel.fromJson(Map<String, dynamic> json) {
    return BalanceMovementModel(
      balanceMovementId: (json['balance_movement_id'] as num?)?.toInt() ?? 0,
      groupId: (json['group_id'] as num?)?.toInt() ?? 0,
      stationId: (json['station_id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      amount: _toNum(json['amount']),
      balanceMovementTypeId:
          (json['balance_movement_type_id'] as num?)?.toInt() ?? 0,
      movement: json['movement'] as String? ?? '',
      synchronized: json['synchronized'] as bool? ?? false,
      balanceMovementUui: json['balance_movement_uui'] as String? ?? '',
      groupName: json['group_name'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      stationName: json['station_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      registrationDate: json['registration_date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance_movement_id': balanceMovementId,
      'group_id': groupId,
      'station_id': stationId,
      'user_id': userId,
      'amount': amount,
      'balance_movement_type_id': balanceMovementTypeId,
      'movement': movement,
      'synchronized': synchronized,
      'balance_movement_uui': balanceMovementUui,
      'group_name': groupName,
      'company_name': companyName,
      'station_name': stationName,
      'address': address,
    };
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
