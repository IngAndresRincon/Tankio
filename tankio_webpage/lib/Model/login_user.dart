class LoginUser {
  final LoginUserData user;
  final List<LoginUserGroup> groups;

  const LoginUser({
    required this.user,
    required this.groups,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    final groupsJson = json['groups'];

    return LoginUser(
      user: LoginUserData.fromJson(userJson),
      groups: groupsJson is List
          ? groupsJson
              .map(
                (item) => LoginUserGroup.fromJson(item as Map<String, dynamic>),
              )
              .toList()
          : <LoginUserGroup>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'groups': groups.map((group) => group.toJson()).toList(),
    };
  }

  LoginUser copyWith({
    LoginUserData? user,
    List<LoginUserGroup>? groups,
  }) {
    return LoginUser(
      user: user ?? this.user,
      groups: groups ?? this.groups,
    );
  }

  int get id => user.id;
  int get rolId => user.rolId;
  String get name => user.name;
  String get lastName => user.lastName;
  String get phoneNumber => user.phoneNumber;
  String get email => user.email;
  String get password => user.password;
  bool get active => user.active;
  DateTime get createAt => user.createAt;
  String get fullName => user.fullName;
}

class LoginUserData {
  final int id;
  final int rolId;
  final String name;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String password;
  final bool active;
  final DateTime createAt;

  const LoginUserData({
    required this.id,
    required this.rolId,
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.active,
    required this.createAt,
  });

  factory LoginUserData.fromJson(Map<String, dynamic> json) {
    return LoginUserData(
      id: json['id'] as int,
      rolId: json['rol_id'] as int,
      name: json['name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String? ?? '',
      email: json['email'] as String,
      password: json['password'] as String,
      active: json['active'] as bool,
      createAt: DateTime.parse(json['create_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rol_id': rolId,
      'name': name,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
      'active': active,
      'create_at': createAt.toUtc().toIso8601String(),
    };
  }

  LoginUserData copyWith({
    int? id,
    int? rolId,
    String? name,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? password,
    bool? active,
    DateTime? createAt,
  }) {
    return LoginUserData(
      id: id ?? this.id,
      rolId: rolId ?? this.rolId,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      active: active ?? this.active,
      createAt: createAt ?? this.createAt,
    );
  }

  String get fullName => '$name $lastName';
}

class LoginUserGroup {
  final int groupId;
  final String groupName;
  final String companyName;
  final bool active;
  final DateTime createAt;

  const LoginUserGroup({
    required this.groupId,
    required this.groupName,
    required this.companyName,
    required this.active,
    required this.createAt,
  });

  factory LoginUserGroup.fromJson(Map<String, dynamic> json) {
    return LoginUserGroup(
      groupId: json['group_id'] as int,
      groupName: json['group_name'] as String,
      companyName: json['company_name'] as String,
      active: json['active'] as bool,
      createAt: DateTime.parse(json['create_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'group_name': groupName,
      'company_name': companyName,
      'active': active,
      'create_at': createAt.toUtc().toIso8601String(),
    };
  }

  LoginUserGroup copyWith({
    int? groupId,
    String? groupName,
    String? companyName,
    bool? active,
    DateTime? createAt,
  }) {
    return LoginUserGroup(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      companyName: companyName ?? this.companyName,
      active: active ?? this.active,
      createAt: createAt ?? this.createAt,
    );
  }
}
