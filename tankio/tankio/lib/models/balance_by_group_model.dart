class BalanceByGroupModel {
  final int balanceId;
  final int userId;
  final num balance;
  final String balanceUuid;
  final String lastMoveDate;
  final int groupId;
  final String groupName;
  final String companyName;
  final String address;
  final String prefixCode;

  BalanceByGroupModel({
    required this.balanceId,
    required this.userId,
    required this.balance,
    required this.balanceUuid,
    required this.lastMoveDate,
    required this.groupId,
    required this.groupName,
    required this.companyName,
    required this.address,
    required this.prefixCode,
  });

  factory BalanceByGroupModel.fromJson(Map<String, dynamic> json) {
    return BalanceByGroupModel(
      balanceId: (json['balance_id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      balance: _toNum(json['balance']),
      balanceUuid: json['balance_uuid'] as String? ?? '',
      lastMoveDate: json['last_move_date'] as String? ?? '',
      groupId: (json['group_id'] as num?)?.toInt() ?? 0,
      groupName: json['group_name'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      prefixCode: json['prefix_code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance_id': balanceId,
      'user_id': userId,
      'balance': balance,
      'balance_uuid': balanceUuid,
      'last_move_date': lastMoveDate,
      'group_id': groupId,
      'group_name': groupName,
      'company_name': companyName,
      'address': address,
      'prefix_code': prefixCode,
    };
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
