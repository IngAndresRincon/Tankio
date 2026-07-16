import 'package:tankio/models/balance_by_group_model.dart';

class UserAuthentication {
  final AuthInfo info;
  final String token;
  final String refreshToken;

  UserAuthentication({
    required this.info,
    required this.token,
    required this.refreshToken,
  });

  factory UserAuthentication.fromJson(Map<String, dynamic> json) {
    return UserAuthentication(
      info: AuthInfo.fromJson(Map<String, dynamic>.from(json['info'] as Map)),
      token: json['token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'token': token,
      'refresh_token': refreshToken,
    };
  }
}

class AuthInfo {
  final AuthUser user;
  late BalanceByGroupModel? balance;
  final List<dynamic> vehicles;

  AuthInfo({required this.user, required this.balance, required this.vehicles});

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    final dynamic balanceJson = json['balance'];
    return AuthInfo(
      user: AuthUser.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      balance: _parseBalance(balanceJson),
      vehicles: (json['vehicles'] as List<dynamic>?) ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'balance': balance?.toJson(),
      'vehicles': vehicles,
    };
  }

  static BalanceByGroupModel? _parseBalance(dynamic value) {
    if (value is Map<String, dynamic>) {
      return BalanceByGroupModel.fromJson(value);
    }

    if (value is Map) {
      return BalanceByGroupModel.fromJson(Map<String, dynamic>.from(value));
    }

    if (value is List && value.isNotEmpty) {
      final first = value.first;
      if (first is Map<String, dynamic>) {
        return BalanceByGroupModel.fromJson(first);
      }
      if (first is Map) {
        return BalanceByGroupModel.fromJson(Map<String, dynamic>.from(first));
      }
    }

    return null;
  }
}

class AuthUser {
  final int id;
  late String name;
  late String lastName;
  late String email;
  late String keyHash;
  late int documentTypeId;
  late String documentType;
  late String documentNumber;
  late String phoneNumber;
  final bool active;
  final String uuid;
  final DateTime registrationDate;

  AuthUser({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.keyHash,
    required this.documentTypeId,
    required this.documentType,
    required this.documentNumber,
    required this.phoneNumber,
    required this.active,
    required this.uuid,
    required this.registrationDate,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      keyHash: json['key_hash'] as String? ?? '',
      documentTypeId: (json['document_type_id'] as num?)?.toInt() ?? 0,
      documentType: json['document_type'] ?? '',
      documentNumber: json['document_number'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
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
      'name': name,
      'last_name': lastName,
      'email': email,
      'key_hash': keyHash,
      'document_type_id': documentTypeId,
      'document_type': documentType,
      'document_number': documentNumber,
      'phone_number': phoneNumber,
      'active': active,
      'uuid': uuid,
      'registration_date': registrationDate.toIso8601String(),
    };
  }
}
