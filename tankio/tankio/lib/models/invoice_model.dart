class InvoiceModel {
  final int id;
  final int stationId;
  final int invoiceSequenceNumber;
  final String invoiceNumber;
  final int saleId;
  final InvoiceUserPayloadModel userPayload;
  final InvoiceSalePayloadModel salePayload;
  final InvoiceRequestPayloadModel? requestInvoicePayload;
  final dynamic responseInvoicePayload;
  final int statusCodeInvoice;
  final String uuid;
  final String? qr;
  final String createdAt;
  final String modifiedAt;

  InvoiceModel({
    required this.id,
    required this.stationId,
    required this.invoiceSequenceNumber,
    required this.invoiceNumber,
    required this.saleId,
    required this.userPayload,
    required this.salePayload,
    required this.requestInvoicePayload,
    required this.responseInvoicePayload,
    required this.statusCodeInvoice,
    required this.qr,
    required this.uuid,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: _toInt(json['id']),
      stationId: _toInt(json['station_id']),
      invoiceSequenceNumber: _toInt(json['invoice_sequence_number']),
      invoiceNumber: json['invoice_number'] as String? ?? '',
      saleId: _toInt(json['sale_id']),
      userPayload: InvoiceUserPayloadModel.fromJson(
        _toMap(json['user_payload']),
      ),
      salePayload: InvoiceSalePayloadModel.fromJson(
        _toMap(json['sale_payload']),
      ),
      requestInvoicePayload: _toNullableRequestPayload(
        json['request_invoice_payload'],
      ),
      responseInvoicePayload: _toDynamic(json['response_invoice_payload']),
      qr: json['qr'],
      statusCodeInvoice: _toInt(json['status_code_invoice']),
      uuid: json['uuid'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      modifiedAt: json['modified_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'invoice_sequence_number': invoiceSequenceNumber,
      'invoice_number': invoiceNumber,
      'sale_id': saleId,
      'user_payload': userPayload.toJson(),
      'sale_payload': salePayload.toJson(),
      'request_invoice_payload': requestInvoicePayload?.toJson(),
      'response_invoice_payload': responseInvoicePayload,
      'status_code_invoice': statusCodeInvoice,
      'qrcode': qr,
      'uuid': uuid,
      'created_at': createdAt,
      'modified_at': modifiedAt,
    };
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
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

  static dynamic _toDynamic(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    if (value is List) {
      return List<dynamic>.from(value);
    }
    return value;
  }

  static InvoiceRequestPayloadModel? _toNullableRequestPayload(dynamic value) {
    if (value is Map<String, dynamic>) {
      return InvoiceRequestPayloadModel.fromJson(value);
    }
    if (value is Map) {
      return InvoiceRequestPayloadModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    return null;
  }
}

class InvoiceUserPayloadModel {
  final String name;
  final String email;
  final int userId;
  final String document;
  final String lastName;
  final String phoneNumber;
  final String documentNumber;
  final int documentTypeId;
  final String documentTypeCode;

  InvoiceUserPayloadModel({
    required this.name,
    required this.email,
    required this.userId,
    required this.document,
    required this.lastName,
    required this.phoneNumber,
    required this.documentNumber,
    required this.documentTypeId,
    required this.documentTypeCode,
  });

  factory InvoiceUserPayloadModel.fromJson(Map<String, dynamic> json) {
    return InvoiceUserPayloadModel(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      userId: InvoiceModel._toInt(json['user_id']),
      document: json['document'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      documentNumber: json['document_number'] as String? ?? '',
      documentTypeId: InvoiceModel._toInt(json['document_type_id']),
      documentTypeCode: json['document_type_code'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'user_id': userId,
      'document': document,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'document_number': documentNumber,
      'document_type_id': documentTypeId,
      'document_type_code': documentTypeCode,
    };
  }
}

class InvoiceSalePayloadModel {
  final int id;
  final String uuid;
  final num money;
  final num power;
  final num price;
  final num volume;
  final int hoseId;
  final int userId;
  final num duration;
  final bool invoiced;
  final bool notified;
  final String hoseCode;
  final bool zeroSale;
  final String identifier;
  final int productId;
  final int stationId;
  final int hoseNumber;
  final String? notifiedAt;
  final int positionId;
  final num totalPower;
  final String productCode;
  final String productName;
  final bool synchronized;
  final int controllerId;
  final int programmingId;
  final String finalDateSale;
  final String programmingType;
  final String programmingUuid;
  final String initialDateSale;
  final num programmingMoney;
  final num programmingValue;
  final String registrationDate;
  final num totalFinalMoney;
  final int productStationId;
  final num totalFinalVolume;
  final num totalInitialMoney;
  final num totalInitialVolume;

  InvoiceSalePayloadModel({
    required this.id,
    required this.uuid,
    required this.money,
    required this.power,
    required this.price,
    required this.volume,
    required this.hoseId,
    required this.userId,
    required this.duration,
    required this.invoiced,
    required this.notified,
    required this.hoseCode,
    required this.zeroSale,
    required this.identifier,
    required this.productId,
    required this.stationId,
    required this.hoseNumber,
    required this.notifiedAt,
    required this.positionId,
    required this.totalPower,
    required this.productCode,
    required this.productName,
    required this.synchronized,
    required this.controllerId,
    required this.programmingId,
    required this.finalDateSale,
    required this.programmingType,
    required this.programmingUuid,
    required this.initialDateSale,
    required this.programmingMoney,
    required this.programmingValue,
    required this.registrationDate,
    required this.totalFinalMoney,
    required this.productStationId,
    required this.totalFinalVolume,
    required this.totalInitialMoney,
    required this.totalInitialVolume,
  });

  factory InvoiceSalePayloadModel.fromJson(Map<String, dynamic> json) {
    return InvoiceSalePayloadModel(
      id: InvoiceModel._toInt(json['id']),
      uuid: json['uuid'] as String? ?? '',
      money: _toNum(json['money']),
      power: _toNum(json['power']),
      price: _toNum(json['price']),
      volume: _toNum(json['volume']),
      hoseId: InvoiceModel._toInt(json['hose_id']),
      userId: InvoiceModel._toInt(json['user_id']),
      duration: _toNum(json['duration']),
      invoiced: json['invoiced'] as bool? ?? false,
      notified: json['notified'] as bool? ?? false,
      hoseCode: json['hose_code'] as String? ?? '',
      zeroSale: json['zero_sale'] as bool? ?? false,
      identifier: json['identifier'] as String? ?? '',
      productId: InvoiceModel._toInt(json['product_id']),
      stationId: InvoiceModel._toInt(json['station_id']),
      hoseNumber: InvoiceModel._toInt(json['hose_number']),
      notifiedAt: json['notified_at'] as String?,
      positionId: InvoiceModel._toInt(json['position_id']),
      totalPower: _toNum(json['total_power']),
      productCode: json['product_code'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      synchronized: json['synchronized'] as bool? ?? false,
      controllerId: InvoiceModel._toInt(json['controller_id']),
      programmingId: InvoiceModel._toInt(json['programming_id']),
      finalDateSale: json['final_date_sale'] as String? ?? '',
      programmingType: json['programming_type'] as String? ?? '',
      programmingUuid: json['programming_uuid'] as String? ?? '',
      initialDateSale: json['initial_date_sale'] as String? ?? '',
      programmingMoney: _toNum(json['programming_money']),
      programmingValue: _toNum(json['programming_value']),
      registrationDate: json['registration_date'] as String? ?? '',
      totalFinalMoney: _toNum(json['total_final_money']),
      productStationId: InvoiceModel._toInt(json['product_station_id']),
      totalFinalVolume: _toNum(json['total_final_volume']),
      totalInitialMoney: _toNum(json['total_initial_money']),
      totalInitialVolume: _toNum(json['total_initial_volume']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'money': money,
      'power': power,
      'price': price,
      'volume': volume,
      'hose_id': hoseId,
      'user_id': userId,
      'duration': duration,
      'invoiced': invoiced,
      'notified': notified,
      'hose_code': hoseCode,
      'zero_sale': zeroSale,
      'identifier': identifier,
      'product_id': productId,
      'station_id': stationId,
      'hose_number': hoseNumber,
      'notified_at': notifiedAt,
      'position_id': positionId,
      'total_power': totalPower,
      'product_code': productCode,
      'product_name': productName,
      'synchronized': synchronized,
      'controller_id': controllerId,
      'programming_id': programmingId,
      'final_date_sale': finalDateSale,
      'programming_type': programmingType,
      'programming_uuid': programmingUuid,
      'initial_date_sale': initialDateSale,
      'programming_money': programmingMoney,
      'programming_value': programmingValue,
      'registration_date': registrationDate,
      'total_final_money': totalFinalMoney,
      'product_station_id': productStationId,
      'total_final_volume': totalFinalVolume,
      'total_initial_money': totalInitialMoney,
      'total_initial_volume': totalInitialVolume,
    };
  }

  static num _toNum(dynamic value) {
    if (value is num) {
      return value;
    }
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class InvoiceRequestPayloadModel {
  final String note;
  final List<InvoiceRequestItemModel> items;
  final String currency;
  final InvoiceCustomerModel customer;
  final List<InvoicePaymentModel> payments;
  final InvoiceSupplierModel supplier;
  final String issueDate;
  final String issueTime;
  final String posTransactionId;

  InvoiceRequestPayloadModel({
    required this.note,
    required this.items,
    required this.currency,
    required this.customer,
    required this.payments,
    required this.supplier,
    required this.issueDate,
    required this.issueTime,
    required this.posTransactionId,
  });

  factory InvoiceRequestPayloadModel.fromJson(Map<String, dynamic> json) {
    return InvoiceRequestPayloadModel(
      note: json['note'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (item) =>
                    InvoiceRequestItemModel.fromJson(InvoiceModel._toMap(item)),
              )
              .toList() ??
          const [],
      currency: json['currency'] as String? ?? '',
      customer: InvoiceCustomerModel.fromJson(
        InvoiceModel._toMap(json['customer']),
      ),
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map(
                (item) =>
                    InvoicePaymentModel.fromJson(InvoiceModel._toMap(item)),
              )
              .toList() ??
          const [],
      supplier: InvoiceSupplierModel.fromJson(
        InvoiceModel._toMap(json['supplier']),
      ),
      issueDate: json['issueDate'] as String? ?? '',
      issueTime: json['issueTime'] as String? ?? '',
      posTransactionId: json['posTransactionId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'items': items.map((e) => e.toJson()).toList(),
      'currency': currency,
      'customer': customer.toJson(),
      'payments': payments.map((e) => e.toJson()).toList(),
      'supplier': supplier.toJson(),
      'issueDate': issueDate,
      'issueTime': issueTime,
      'posTransactionId': posTransactionId,
    };
  }
}

class InvoiceRequestItemModel {
  final int id;
  final num qty;
  final String sku;
  final List<InvoiceTaxModel> taxes;
  final String unitCode;
  final num unitPrice;
  final String description;
  final num lineTotalAmount;
  final num lineSubtotalAmount;

  InvoiceRequestItemModel({
    required this.id,
    required this.qty,
    required this.sku,
    required this.taxes,
    required this.unitCode,
    required this.unitPrice,
    required this.description,
    required this.lineTotalAmount,
    required this.lineSubtotalAmount,
  });

  factory InvoiceRequestItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceRequestItemModel(
      id: InvoiceModel._toInt(json['id']),
      qty: InvoiceSalePayloadModel._toNum(json['qty']),
      sku: json['sku'] as String? ?? '',
      taxes:
          (json['taxes'] as List<dynamic>?)
              ?.map(
                (item) => InvoiceTaxModel.fromJson(InvoiceModel._toMap(item)),
              )
              .toList() ??
          const [],
      unitCode: json['unitCode'] as String? ?? '',
      unitPrice: InvoiceSalePayloadModel._toNum(json['unitPrice']),
      description: json['description'] as String? ?? '',
      lineTotalAmount: InvoiceSalePayloadModel._toNum(json['lineTotalAmount']),
      lineSubtotalAmount: InvoiceSalePayloadModel._toNum(
        json['lineSubtotalAmount'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qty': qty,
      'sku': sku,
      'taxes': taxes.map((e) => e.toJson()).toList(),
      'unitCode': unitCode,
      'unitPrice': unitPrice,
      'description': description,
      'lineTotalAmount': lineTotalAmount,
      'lineSubtotalAmount': lineSubtotalAmount,
    };
  }
}

class InvoiceTaxModel {
  final num percent;
  final String schemeId;
  final String taxTreatment;

  InvoiceTaxModel({
    required this.percent,
    required this.schemeId,
    required this.taxTreatment,
  });

  factory InvoiceTaxModel.fromJson(Map<String, dynamic> json) {
    return InvoiceTaxModel(
      percent: InvoiceSalePayloadModel._toNum(json['percent']),
      schemeId: json['schemeId'] as String? ?? '',
      taxTreatment: json['taxTreatment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percent': percent,
      'schemeId': schemeId,
      'taxTreatment': taxTreatment,
    };
  }
}

class InvoiceCustomerModel {
  final String nit;
  final String name;
  final String email;
  final String cityCode;
  final String cityName;
  final String departmentCode;
  final String documentTypeCode;

  InvoiceCustomerModel({
    required this.nit,
    required this.name,
    required this.email,
    required this.cityCode,
    required this.cityName,
    required this.departmentCode,
    required this.documentTypeCode,
  });

  factory InvoiceCustomerModel.fromJson(Map<String, dynamic> json) {
    return InvoiceCustomerModel(
      nit: json['nit'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      cityCode: json['cityCode'] as String? ?? '',
      cityName: json['cityName'] as String? ?? '',
      departmentCode: json['departmentCode'] as String? ?? '',
      documentTypeCode: json['documentTypeCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nit': nit,
      'name': name,
      'email': email,
      'cityCode': cityCode,
      'cityName': cityName,
      'departmentCode': departmentCode,
      'documentTypeCode': documentTypeCode,
    };
  }
}

class InvoicePaymentModel {
  final num amount;
  final String paymentForm;
  final String paymentMethod;

  InvoicePaymentModel({
    required this.amount,
    required this.paymentForm,
    required this.paymentMethod,
  });

  factory InvoicePaymentModel.fromJson(Map<String, dynamic> json) {
    return InvoicePaymentModel(
      amount: InvoiceSalePayloadModel._toNum(json['amount']),
      paymentForm: json['paymentForm'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'paymentForm': paymentForm,
      'paymentMethod': paymentMethod,
    };
  }
}

class InvoiceSupplierModel {
  final String dv;
  final String nit;
  final String name;

  InvoiceSupplierModel({
    required this.dv,
    required this.nit,
    required this.name,
  });

  factory InvoiceSupplierModel.fromJson(Map<String, dynamic> json) {
    return InvoiceSupplierModel(
      dv: json['dv'] as String? ?? '',
      nit: json['nit'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'dv': dv, 'nit': nit, 'name': name};
  }
}
