class PaymentRequestModel {
  final int paymentRequestId;
  final String groupName;
  final String stationName;
  final String userName;
  final String paymentGateway;
  final String paymentReference;
  final String invoice;
  final num amount;
  final String currency;
  final String paymentStatus;
  final Map<String, dynamic> gatewayResponsePayload;
  final String uuid;
  final DateTime receivedAt;
  final DateTime updatedAt;

  const PaymentRequestModel({
    required this.paymentRequestId,
    required this.groupName,
    required this.stationName,
    required this.userName,
    required this.paymentGateway,
    required this.paymentReference,
    required this.invoice,
    required this.amount,
    required this.currency,
    required this.paymentStatus,
    required this.gatewayResponsePayload,
    required this.uuid,
    required this.receivedAt,
    required this.updatedAt,
  });

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      paymentRequestId: json['payment_request_id'] as int,
      groupName: json['group_name'] as String,
      stationName: json['station_name'] as String,
      userName: json['user_name'] as String,
      paymentGateway: json['payment_gateway'] as String,
      paymentReference: json['payment_reference'] as String,
      invoice: json['invoice'] as String,
      amount: json['amount'] as num,
      currency: json['currency'] as String,
      paymentStatus: json['payment_status'] as String,
      gatewayResponsePayload: Map<String, dynamic>.from(
        json['gateway_response_payload'] as Map,
      ),
      uuid: json['uuid'] as String,
      receivedAt: DateTime.parse(json['received_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_request_id': paymentRequestId,
      'group_name': groupName,
      'station_name': stationName,
      'user_name': userName,
      'payment_gateway': paymentGateway,
      'payment_reference': paymentReference,
      'invoice': invoice,
      'amount': amount,
      'currency': currency,
      'payment_status': paymentStatus,
      'gateway_response_payload': gatewayResponsePayload,
      'uuid': uuid,
      'received_at': receivedAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  PaymentRequestModel copyWith({
    int? paymentRequestId,
    String? groupName,
    String? stationName,
    String? userName,
    String? paymentGateway,
    String? paymentReference,
    String? invoice,
    num? amount,
    String? currency,
    String? paymentStatus,
    Map<String, dynamic>? gatewayResponsePayload,
    String? uuid,
    DateTime? receivedAt,
    DateTime? updatedAt,
  }) {
    return PaymentRequestModel(
      paymentRequestId: paymentRequestId ?? this.paymentRequestId,
      groupName: groupName ?? this.groupName,
      stationName: stationName ?? this.stationName,
      userName: userName ?? this.userName,
      paymentGateway: paymentGateway ?? this.paymentGateway,
      paymentReference: paymentReference ?? this.paymentReference,
      invoice: invoice ?? this.invoice,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      gatewayResponsePayload:
          gatewayResponsePayload ?? this.gatewayResponsePayload,
      uuid: uuid ?? this.uuid,
      receivedAt: receivedAt ?? this.receivedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
