import 'package:flutter/material.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/models/sale_model.dart';
import 'package:tankio/utils/money_utils.dart';

class SaleDetailModal extends StatelessWidget {
  final SaleModel sale;

  const SaleDetailModal({super.key, required this.sale});

  String _formatAmount(num value) {
    return formatMoney(value);
  }

  (String, Color, IconData) _statusData(
    AppLocalizations l10n,
    bool zeroSale,
  ) {
    if (zeroSale) {
      return (
        l10n.reservationLabel,
        const Color(0xFFB45309),
        Icons.lock_clock_rounded,
      );
    }
    return (l10n.saleLabel, const Color(0xFF166534), Icons.payments_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final status = _statusData(l10n, sale.zeroSale);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 74,
                          height: 74,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            sale.systemId == 2
                                ? Icons.ev_station
                                : Icons.local_gas_station,
                            color: Colors.black,
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sale.stationName,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: size.width * 0.055,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _StatusChip(
                                    label: status.$1,
                                    color: status.$2,
                                    backgroundColor: status.$2.withValues(
                                      alpha: 0.12,
                                    ),
                                  ),
                                  _StatusChip(
                                    label: sale.programmingType,
                                    color: const Color(0xFF60AF47),
                                    backgroundColor: const Color(0xFFEAF6E5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: l10n.purchaseInformationTitle,
                      children: [
                        _DetailRow(
                          label: l10n.saleIdLabel,
                          value: sale.saleId.toString(),
                        ),
                        _DetailRow(label: l10n.systemLabel, value: sale.systemName),
                        _DetailRow(label: l10n.groupLabel, value: sale.groupName),
                        _DetailRow(label: l10n.companyLabel, value: sale.stationName),
                        _DetailRow(
                          label: l10n.stationAddressLabel,
                          value: sale.stationAddress,
                        ),
                        _DetailRow(label: l10n.productLabel, value: sale.productName),
                        _DetailRow(label: l10n.identifierLabel, value: sale.identifier),
                        _DetailRow(
                          label: l10n.programmingMoneyLabel,
                          value: '\$ ${_formatAmount(sale.programmingMoney)}',
                        ),
                        _DetailRow(label: l10n.balanceLabel, value: '\$ ${_formatAmount(sale.balance)}'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: l10n.saleValuesTitle,
                      children: [
                        _DetailRow(
                          label: l10n.priceLabel,
                          value: '\$ ${_formatAmount(sale.price)}',
                        ),
                        _DetailRow(
                          label: l10n.moneyLabel,
                          value: '\$ ${_formatAmount(sale.money)}',
                        ),

                        _DetailRow(
                          label: l10n.powerLabel,
                          value: _formatAmount(sale.power),
                        ),
                        _DetailRow(
                          label: l10n.totalPowerLabel,
                          value: _formatAmount(sale.totalPower),
                        ),
                        _DetailRow(
                          label: l10n.initialDateLabel,
                          value: sale.initialDateSale,
                        ),
                        _DetailRow(
                          label: l10n.finalDateLabel,
                          value: sale.finalDateSale,
                        ),
                        _DetailRow(
                          label: l10n.zeroSaleLabel,
                          value: sale.zeroSale ? l10n.yesLabel : l10n.noLabel,
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // _SectionCard(
                    //   title: 'Programming status',
                    //   children: [
                    //     _DetailRow(
                    //       label: 'Controller ID',
                    //       value: sale.controllerId.toString(),
                    //     ),
                    //     _DetailRow(
                    //       label: 'Hose ID',
                    //       value: sale.hoseId.toString(),
                    //     ),
                    //     _DetailRow(
                    //       label: 'Position ID',
                    //       value: sale.positionId.toString(),
                    //     ),
                    //     _DetailRow(
                    //       label: 'Station ID',
                    //       value: sale.stationId.toString(),
                    //     ),
                    //     _DetailRow(
                    //       label: 'User ID',
                    //       value: sale.userId.toString(),
                    //     ),
                    //     _DetailRow(
                    //       label: 'Booking',
                    //       value: sale.booking ? 'Yes' : 'No',
                    //       isLast: true,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 18),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          l10n.closeButton,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAECF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
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
              value.isNotEmpty ? value : '-',
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
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
