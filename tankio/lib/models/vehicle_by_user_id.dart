class VehicleModel {
  final int id;
  final int userId;
  final String plate;
  final String uuid;
  final String connector;
  final String type;
  final String brand;
  final String model;
  final String description;
  late bool active;
  late bool enable;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.plate,
    required this.uuid,
    required this.connector,
    required this.type,
    required this.brand,
    required this.model,
    required this.description,
    required this.active,
    required this.enable,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      plate: json['plate'] as String? ?? '',
      uuid: json['uuid'] as String? ?? '',
      connector: json['connector'] as String? ?? '',
      type: json['type'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      model: json['model'] as String? ?? '',
      description: json['description'] as String? ?? '',
      active: json['active'],
      enable: json['enable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plate': plate,
      'uuid': uuid,
      'connector': connector,
      'type': type,
      'brand': brand,
      'model': model,
      'description': description,
      'active': active,
      'enable': enable,
    };
  }
}
