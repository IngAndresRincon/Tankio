class NotificationModel {
  final int id;
  final int userId;
  final int stationId;
  final String title;
  final String description;
  final String type;
  final int notificationTime;
  final bool synchronized;
  final bool active;
  final String registrationDate;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.title,
    required this.description,
    required this.type,
    required this.notificationTime,
    required this.synchronized,
    required this.active,
    required this.registrationDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      stationId: (json['station_id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      notificationTime: (json['notification_time'] as num?)?.toInt() ?? 0,
      synchronized: json['synchronized'] as bool? ?? false,
      active: json['active'] as bool? ?? false,
      registrationDate: json['registration_date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'station_id': stationId,
      'title': title,
      'description': description,
      'type': type,
      'notification_time': notificationTime,
      'synchronized': synchronized,
      'active': active,
      'registration_date': registrationDate,
    };
  }
}
