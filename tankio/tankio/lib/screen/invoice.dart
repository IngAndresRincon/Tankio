import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/loading.dart';
import 'package:tankio/provider/sale.dart';
import 'package:tankio/screen/view_invoice.dart';
import 'package:tankio/widget/modal/edit_customer_modal.dart';

class Invoice extends ConsumerStatefulWidget {
  final int saleId;

  const Invoice({super.key, required this.saleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InvoiceState();
}

class _InvoiceState extends ConsumerState<Invoice> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(saleProvider).getInvoiceInformationBySale(saleid: widget.saleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(loadingProvider);
    final saleState = ref.watch(saleProvider);
    final invoice = saleState.invoice;

    Map<String, dynamic>? responsePayload;
    if (invoice?.responseInvoicePayload is Map<String, dynamic>) {
      responsePayload = Map<String, dynamic>.from(
        invoice!.responseInvoicePayload as Map<String, dynamic>,
      );
    } else if (invoice?.responseInvoicePayload is Map) {
      responsePayload = Map<String, dynamic>.from(
        invoice!.responseInvoicePayload as Map,
      );
    }

    String statusTitle;
    Color statusColor;
    Color statusBackground;
    IconData statusIcon;
    String statusMessage;
    if (invoice?.statusCodeInvoice == 0 || invoice?.statusCodeInvoice == 4) {
      statusTitle = l10n.invoicePendingStatus;
      statusColor = const Color(0xFFB45309);
      statusBackground = const Color(0xFFFFF7ED);
      statusIcon = Icons.hourglass_bottom_rounded;
      statusMessage = l10n.invoicePendingStatusMessage;
    } else if (invoice?.statusCodeInvoice == 2) {
      statusTitle = l10n.invoiceGeneratedStatus;
      statusColor = const Color(0xFF166534);
      statusBackground = const Color(0xFFEAF6E5);
      statusIcon = Icons.verified_rounded;
      statusMessage = l10n.invoiceGeneratedStatusMessage;
    } else {
      statusTitle = l10n.invoiceErrorStatus;
      statusColor = const Color(0xFFB42318);
      statusBackground = const Color(0xFFFEE4E2);
      statusIcon = Icons.error_outline_rounded;
      statusMessage = l10n.invoiceErrorStatusMessage;
    }

    final qrcode = invoice?.qr ?? "";

    final pending =
        invoice?.statusCodeInvoice == 0 || invoice?.statusCodeInvoice == 4;

    final customerName = invoice == null
        ? '-'
        : invoice.userPayload.name.trim().isEmpty
        ? '-'
        : '${invoice.userPayload.name} ${invoice.userPayload.lastName}'.trim();
    final customerDocument = invoice?.userPayload.documentNumber ?? '-';
    final customerEmail = invoice?.userPayload.email ?? '-';
    final customerPhone = invoice?.userPayload.phoneNumber ?? '-';
    final productName = invoice?.salePayload.productName ?? '-';
    final priceText = NumberFormat.decimalPattern(
      'es_CO',
    ).format(invoice?.salePayload.price ?? 0);
    final totalText = NumberFormat.decimalPattern(
      'es_CO',
    ).format(invoice?.salePayload.money ?? 0);

    final saleDateRaw = invoice?.salePayload.registrationDate ?? '';
    String saleDate = '-';
    if (saleDateRaw.isNotEmpty) {
      final parsedSaleDate = DateTime.tryParse(saleDateRaw);
      if (parsedSaleDate != null) {
        saleDate = DateFormat('dd/MM/yyyy HH:mm').format(parsedSaleDate);
      } else {
        saleDate = saleDateRaw;
      }
    }

    String dianMessage = '';
    if (responsePayload != null) {
      final dianStatusMessageValue = responsePayload['dianStatusMessage'];
      if (dianStatusMessageValue != null &&
          dianStatusMessageValue.toString().trim().isNotEmpty) {
        dianMessage = dianStatusMessageValue.toString();
      } else {
        final statusValue = responsePayload['status'];
        if (statusValue != null && statusValue.toString().trim().isNotEmpty) {
          dianMessage = statusValue.toString();
        } else {
          final publicStatusValue = responsePayload['publicStatus'];
          if (publicStatusValue != null &&
              publicStatusValue.toString().trim().isNotEmpty) {
            dianMessage = publicStatusValue.toString();
          } else {
            final errorMessageValue = responsePayload['errorMessage'];
            if (errorMessageValue != null &&
                errorMessageValue.toString().trim().isNotEmpty) {
              dianMessage = errorMessageValue.toString();
            }
          }
        }
      }
    }

    String cufe = '';
    if (responsePayload != null) {
      final cufeValue = responsePayload['cufe'];
      if (cufeValue != null && cufeValue.toString().trim().isNotEmpty) {
        cufe = cufeValue.toString();
      }
    }

    if (responsePayload != null) {
      final invoiceNumberValue = responsePayload['invoiceNumber'];
      if (invoiceNumberValue != null &&
          invoiceNumberValue.toString().trim().isNotEmpty) {}
    }

    if (responsePayload != null) {
      final errorMessageValue = responsePayload['errorMessage'];
      if (errorMessageValue != null &&
          errorMessageValue.toString().trim().isNotEmpty) {}
    }

    if (responsePayload != null) {
      final environmentValue = responsePayload['environment'];
      if (environmentValue != null &&
          environmentValue.toString().trim().isNotEmpty) {}
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: size.width * 0.06,
          ),
        ),
        title: Text(
          l10n.invoiceTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF4F7FB), Color(0xFFFFFFFF)],
          ),
        ),
        child: isLoading && invoice == null
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: invoice == null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.receipt_long_rounded,
                                    size: 36,
                                    color: Color(0xFF1D4ED8),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noInvoiceDataTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.noInvoiceDataMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF60AF47),
                                    Color(0xFFDBF9D1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF0F172A,
                                    ).withValues(alpha: 0.18),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.14,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Icon(
                                          statusIcon,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              l10n.invoiceDetailsTitle,
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              l10n.invoiceDetailsSubtitle,
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 13,
                                                height: 1.3,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusBackground,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          statusTitle,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: statusColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.16,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          l10n.saleChipLabel,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.10,
                                      ),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.14,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${l10n.invoiceNumberHeading}${invoice.invoiceNumber.isNotEmpty ? invoice.invoiceNumber : '-'}',
                                          style: const TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${l10n.invoiceSequenceLabel} ${invoice.invoiceSequenceNumber}',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white.withValues(
                                              alpha: 0.82,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFEAECF0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l10n.invoiceStatusTitle,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        statusTitle,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: statusColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoiceStatusLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            statusTitle,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: statusColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoiceNumberLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            invoice.invoiceNumber.isNotEmpty
                                                ? invoice.invoiceNumber
                                                : '-',
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoiceSequenceLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            invoice.invoiceSequenceNumber
                                                .toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.saleIdLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            invoice.saleId.toString(),
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFEAECF0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l10n.invoiceCustomerTitle,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: pending
                                            ? () async {
                                                final result =
                                                    await showModalBottomSheet<
                                                      bool
                                                    >(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (modalContext) {
                                                        return const EditCustomerModal();
                                                      },
                                                    );
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                if (result == true) {
                                                  await ref
                                                      .read(saleProvider)
                                                      .getInvoiceInformationBySale(
                                                        saleid: widget.saleId,
                                                      );
                                                }
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          size: 18,
                                        ),
                                        label: Text(
                                          l10n.editButton,
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            fontSize: size.width * 0.034,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: pending
                                              ? const Color(0xFF0F766E)
                                              : Colors.grey,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.customerNameLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            customerName,
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.customerDocumentLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            customerDocument,
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.customerEmailLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            customerEmail,
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.customerPhoneLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            customerPhone,
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFEAECF0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.invoiceSaleSummaryTitle,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoiceProductLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            productName,
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoicePriceLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '\$ $priceText',
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoiceTotalLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            '\$ $totalText',
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoiceDateLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            saleDate,
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFEAECF0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.invoiceDianResultTitle,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            l10n.invoiceMessageLabel,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            dianMessage.isNotEmpty
                                                ? dianMessage
                                                : statusMessage,
                                            style: const TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (cufe.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 110,
                                            child: Text(
                                              l10n.invoiceCufeLabel,
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              cufe,
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: size.width * 0.031,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  if (qrcode.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 12,
                                        bottom: 12,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 110,
                                            child: Text(
                                              l10n.invoiceQrCodeLabel,
                                              style: TextStyle(
                                                fontFamily: 'Nunito',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: QrImageView(
                                                data: qrcode,
                                                version: QrVersions.auto,
                                                size: size.width * 0.7,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  TextButton(
                                    onPressed: cufe.isNotEmpty
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ViewInvoice(url: qrcode),
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      l10n.viewOnlineButtonLabel,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: size.width * 0.036,
                                        color: Colors.blueGrey.shade900,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  // if (invoiceNumber.isNotEmpty)
                                  //   Container(
                                  //     padding: const EdgeInsets.only(
                                  //       top: 12,
                                  //       bottom: 12,
                                  //     ),
                                  //     decoration: BoxDecoration(
                                  //       border: Border(
                                  //         bottom: BorderSide(
                                  //           color: Colors.grey.shade300,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     child: Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         SizedBox(
                                  //           width: 110,
                                  //           child: Text(
                                  //             l10n.invoiceNumberLabel,
                                  //             style: TextStyle(
                                  //               fontFamily: 'Nunito',
                                  //               fontSize: 13,
                                  //               fontWeight: FontWeight.w700,
                                  //               color: Colors.grey.shade600,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           child: Text(
                                  //             invoiceNumber,
                                  //             style: const TextStyle(
                                  //               fontFamily: 'Nunito',
                                  //               fontSize: 14,
                                  //               fontWeight: FontWeight.w600,
                                  //               color: Colors.black87,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // if (errorMessage.isNotEmpty)
                                  //   Container(
                                  //     padding: const EdgeInsets.only(
                                  //       top: 12,
                                  //       bottom: 12,
                                  //     ),
                                  //     decoration: BoxDecoration(
                                  //       border: Border(
                                  //         bottom: BorderSide(
                                  //           color: Colors.grey.shade300,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     child: Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         SizedBox(
                                  //           width: 110,
                                  //           child: Text(
                                  //             l10n.invoiceErrorLabel,
                                  //             style: TextStyle(
                                  //               fontFamily: 'Nunito',
                                  //               fontSize: 13,
                                  //               fontWeight: FontWeight.w700,
                                  //               color: Colors.grey.shade600,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           child: Text(
                                  //             errorMessage,
                                  //             style: const TextStyle(
                                  //               fontFamily: 'Nunito',
                                  //               fontSize: 14,
                                  //               fontWeight: FontWeight.w600,
                                  //               color: Color(0xFFB42318),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   )

                                  // else
                                  //   Container(
                                  //     padding: const EdgeInsets.only(top: 12),
                                  //     child: Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //         SizedBox(
                                  //           width: 110,
                                  //           child: Text(
                                  //             l10n.invoiceEnvironmentLabel,
                                  //             style: TextStyle(
                                  //               fontFamily: 'Nunito',
                                  //               fontSize: 13,
                                  //               fontWeight: FontWeight.w700,
                                  //               color: Colors.grey.shade600,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           child: Text(
                                  //             environment.isNotEmpty
                                  //                 ? environment
                                  //                 : '-',
                                  //             style: const TextStyle(
                                  //               fontFamily: 'Nunito',
                                  //               fontSize: 14,
                                  //               fontWeight: FontWeight.w600,
                                  //               color: Colors.black87,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (pending)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7ED),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFF6C177),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.edit_note_rounded,
                                      color: Color(0xFFB45309),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        l10n.invoicePendingBannerMessage,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: size.width * 0.036,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.brown.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
