class AppUserGroupBalanceModel {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String keyHash;
  final int documentTypeId;
  final String documentNumber;
  final String phoneNumber;
  final bool active;
  final String uuid;
  final DateTime registrationDate;
  final String documentType;
  final UserGroupBalanceContainer balance;

  const AppUserGroupBalanceModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.email,
    required this.keyHash,
    required this.documentTypeId,
    required this.documentNumber,
    required this.phoneNumber,
    required this.active,
    required this.uuid,
    required this.registrationDate,
    required this.documentType,
    required this.balance,
  });

  factory AppUserGroupBalanceModel.fromJson(Map<String, dynamic> json) {
    return AppUserGroupBalanceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      keyHash: json['key_hash'] as String,
      documentTypeId: json['document_type_id'] as int,
      documentNumber: json['document_number'] as String,
      phoneNumber: json['phone_number'] as String,
      active: json['active'] as bool,
      uuid: json['uuid'] as String,
      registrationDate: DateTime.parse(json['registration_date'] as String),
      documentType: json['document_type'] as String,
      balance: UserGroupBalanceContainer.fromJson(
        json['balance'] as Map<String, dynamic>,
      ),
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
      'document_number': documentNumber,
      'phone_number': phoneNumber,
      'active': active,
      'uuid': uuid,
      'registration_date': registrationDate.toUtc().toIso8601String(),
      'document_type': documentType,
      'balance': balance.toJson(),
    };
  }

  AppUserGroupBalanceModel copyWith({
    int? id,
    String? name,
    String? lastName,
    String? email,
    String? keyHash,
    int? documentTypeId,
    String? documentNumber,
    String? phoneNumber,
    bool? active,
    String? uuid,
    DateTime? registrationDate,
    String? documentType,
    UserGroupBalanceContainer? balance,
  }) {
    return AppUserGroupBalanceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      keyHash: keyHash ?? this.keyHash,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      documentNumber: documentNumber ?? this.documentNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      active: active ?? this.active,
      uuid: uuid ?? this.uuid,
      registrationDate: registrationDate ?? this.registrationDate,
      documentType: documentType ?? this.documentType,
      balance: balance ?? this.balance,
    );
  }
}

class UserGroupBalanceContainer {
  final List<UserGroupBalanceItem> balance;

  const UserGroupBalanceContainer({required this.balance});

  factory UserGroupBalanceContainer.fromJson(Map<String, dynamic> json) {
    final rawList = json['balance'];
    return UserGroupBalanceContainer(
      balance: rawList is List
          ? rawList
                .map(
                  (item) => UserGroupBalanceItem.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : <UserGroupBalanceItem>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance.map((item) => item.toJson()).toList()};
  }

  UserGroupBalanceContainer copyWith({List<UserGroupBalanceItem>? balance}) {
    return UserGroupBalanceContainer(balance: balance ?? this.balance);
  }
}

class UserGroupBalanceItem {
  final UserGroupBalanceGroup group;
  final int balance;
  final int balanceId;
  final String balanceUuid;
  final DateTime lastMoveDate;

  const UserGroupBalanceItem({
    required this.group,
    required this.balance,
    required this.balanceId,
    required this.balanceUuid,
    required this.lastMoveDate,
  });

  factory UserGroupBalanceItem.fromJson(Map<String, dynamic> json) {
    return UserGroupBalanceItem(
      group: UserGroupBalanceGroup.fromJson(
        json['group'] as Map<String, dynamic>,
      ),
      balance: json['balance'] as int,
      balanceId: json['balance_id'] as int,
      balanceUuid: json['balance_uuid'] as String,
      lastMoveDate: DateTime.parse(json['last_move_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group': group.toJson(),
      'balance': balance,
      'balance_id': balanceId,
      'balance_uuid': balanceUuid,
      'last_move_date': lastMoveDate.toIso8601String(),
    };
  }

  UserGroupBalanceItem copyWith({
    UserGroupBalanceGroup? group,
    int? balance,
    int? balanceId,
    String? balanceUuid,
    DateTime? lastMoveDate,
  }) {
    return UserGroupBalanceItem(
      group: group ?? this.group,
      balance: balance ?? this.balance,
      balanceId: balanceId ?? this.balanceId,
      balanceUuid: balanceUuid ?? this.balanceUuid,
      lastMoveDate: lastMoveDate ?? this.lastMoveDate,
    );
  }
}

class UserGroupBalanceGroup {
  final String address;
  final int groupId;
  final String groupName;
  final String prefixCode;
  final String companyName;

  const UserGroupBalanceGroup({
    required this.address,
    required this.groupId,
    required this.groupName,
    required this.prefixCode,
    required this.companyName,
  });

  factory UserGroupBalanceGroup.fromJson(Map<String, dynamic> json) {
    return UserGroupBalanceGroup(
      address: json['address'] as String,
      groupId: json['group_id'] as int,
      groupName: json['group_name'] as String,
      prefixCode: json['prefix_code'] as String,
      companyName: json['company_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'group_id': groupId,
      'group_name': groupName,
      'prefix_code': prefixCode,
      'company_name': companyName,
    };
  }

  UserGroupBalanceGroup copyWith({
    String? address,
    int? groupId,
    String? groupName,
    String? prefixCode,
    String? companyName,
  }) {
    return UserGroupBalanceGroup(
      address: address ?? this.address,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      prefixCode: prefixCode ?? this.prefixCode,
      companyName: companyName ?? this.companyName,
    );
  }
}
