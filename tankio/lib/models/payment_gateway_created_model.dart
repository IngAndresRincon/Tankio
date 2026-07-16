class PaymentGatewayCreatedModel {
  final int id;
  final int groupId;
  final int stationId;
  final int userId;
  final int paymentGatewayId;
  final String requestReference;
  final String invoice;
  final String requestType;
  final String amount;
  final String currency;
  final String description;
  final String? paymentMethodType;
  final String appSource;
  final int requestStatusId;
  final Map<String, dynamic> gatewayRequestPayload;
  final Map<String, dynamic> gatewayResponsePayload;
  final Map<String, dynamic> metadata;
  final String receivedAt;
  final String? processedAt;
  final String updatedAt;
  final String uuid;

  PaymentGatewayCreatedModel({
    required this.id,
    required this.groupId,
    required this.stationId,
    required this.userId,
    required this.paymentGatewayId,
    required this.requestReference,
    required this.invoice,
    required this.requestType,
    required this.amount,
    required this.currency,
    required this.description,
    required this.paymentMethodType,
    required this.appSource,
    required this.requestStatusId,
    required this.gatewayRequestPayload,
    required this.gatewayResponsePayload,
    required this.metadata,
    required this.receivedAt,
    required this.processedAt,
    required this.updatedAt,
    required this.uuid,
  });

  factory PaymentGatewayCreatedModel.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayCreatedModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      groupId: (json['group_id'] as num?)?.toInt() ?? 0,
      stationId: (json['station_id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      paymentGatewayId: (json['payment_gateway_id'] as num?)?.toInt() ?? 0,
      requestReference: json['request_reference'] as String? ?? '',
      invoice: json['invoice'],
      requestType: json['request_type'] as String? ?? '',
      amount: json['amount']?.toString() ?? '0',
      currency: json['currency'] as String? ?? '',
      description: json['description'] as String? ?? '',
      paymentMethodType: json['payment_method_type'] as String?,
      appSource: json['app_source'] as String? ?? '',
      requestStatusId: (json['request_status_id'] as num?)?.toInt() ?? 0,
      gatewayRequestPayload: _toMap(json['gateway_request_payload']),
      gatewayResponsePayload: _toMap(json['gateway_response_payload']),
      metadata: _toMap(json['metadata']),
      receivedAt: json['received_at'] as String? ?? '',
      processedAt: json['processed_at'] as String?,
      updatedAt: json['updated_at'] as String? ?? '',
      uuid: json['uuid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'station_id': stationId,
      'user_id': userId,
      'payment_gateway_id': paymentGatewayId,
      'request_reference': requestReference,
      'invoice': invoice,
      'request_type': requestType,
      'amount': amount,
      'currency': currency,
      'description': description,
      'payment_method_type': paymentMethodType,
      'app_source': appSource,
      'request_status_id': requestStatusId,
      'gateway_request_payload': gatewayRequestPayload,
      'gateway_response_payload': gatewayResponsePayload,
      'metadata': metadata,
      'received_at': receivedAt,
      'processed_at': processedAt,
      'updated_at': updatedAt,
      'uuid': uuid,
    };
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }
}
