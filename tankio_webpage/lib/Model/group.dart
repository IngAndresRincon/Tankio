class GroupModel {
  final int id;
  final int ownerId;
  final String name;
  final String companyName;
  final String documentNumber;
  final String address;
  final int cityCode;
  final String phoneNumber;
  final String webPage;
  final bool invoice;
  final bool active;
  final int environment;
  final String uuid;
  final DateTime registrationDate;
  final String prefixCode;

  const GroupModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.companyName,
    required this.documentNumber,
    required this.address,
    required this.cityCode,
    required this.phoneNumber,
    required this.webPage,
    required this.invoice,
    required this.active,
    required this.environment,
    required this.uuid,
    required this.registrationDate,
    required this.prefixCode,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as int,
      ownerId: json['owner_id'] as int,
      name: json['name'] as String,
      companyName: json['company_name'] as String,
      documentNumber: json['document_number'] as String,
      address: json['address'] as String,
      cityCode: json['city_code'] as int,
      phoneNumber: json['phone_number'] as String,
      webPage: json['web_page'] as String,
      invoice: json['invoice'] as bool,
      active: json['active'] as bool,
      environment: json['environment'] as int,
      uuid: json['uuid'] as String,
      registrationDate: DateTime.parse(json['registration_date'] as String),
      prefixCode: json['prefix_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'company_name': companyName,
      'document_number': documentNumber,
      'address': address,
      'city_code': cityCode,
      'phone_number': phoneNumber,
      'web_page': webPage,
      'invoice': invoice,
      'active': active,
      'environment': environment,
      'uuid': uuid,
      'registration_date': registrationDate.toUtc().toIso8601String(),
      'prefix_code': prefixCode,
    };
  }

  GroupModel copyWith({
    int? id,
    int? ownerId,
    String? name,
    String? companyName,
    String? documentNumber,
    String? address,
    int? cityCode,
    String? phoneNumber,
    String? webPage,
    bool? invoice,
    bool? active,
    int? environment,
    String? uuid,
    DateTime? registrationDate,
    String? prefixCode,
  }) {
    return GroupModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      companyName: companyName ?? this.companyName,
      documentNumber: documentNumber ?? this.documentNumber,
      address: address ?? this.address,
      cityCode: cityCode ?? this.cityCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      webPage: webPage ?? this.webPage,
      invoice: invoice ?? this.invoice,
      active: active ?? this.active,
      environment: environment ?? this.environment,
      uuid: uuid ?? this.uuid,
      registrationDate: registrationDate ?? this.registrationDate,
      prefixCode: prefixCode ?? this.prefixCode,
    );
  }
}
