import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/models/programming_model.dart';
import 'package:tankio/provider/schedule_tankio.dart';

class ProgrammingDetailModal extends ConsumerStatefulWidget {
  final ProgrammingModel programming;
  const ProgrammingDetailModal({super.key, required this.programming});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProgrammingDetailModalState();
}

class _ProgrammingDetailModalState
    extends ConsumerState<ProgrammingDetailModal> {
  String _formatAmount(num value) {
    return NumberFormat.decimalPattern('es_CO').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final programming = widget.programming;
    final tankio = ref.watch(tankioProvider);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Barra de arrastre
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
                    Text(
                      programming.stationName,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
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
                          _buildDetailRow(
                            size,
                            l10n.programmingIdLabel,
                            programming.programmingId.toString(),
                          ),
                          _buildDetailRow(
                            size,
                            l10n.vehicleInfoLabel,
                            '${programming.vehicleBrand} ${programming.vehicleModel}',
                          ),

                          _buildDetailRow(
                            size,
                            l10n.addressLabel,
                            programming.address,
                          ),
                          _buildDetailRow(
                            size,
                            l10n.identifierLabel,
                            programming.identifier,
                          ),

                          _buildDetailRow(
                            size,
                            l10n.moneyLabel,
                            '\$ ${_formatAmount(programming.programmingMoney)}',
                          ),
                          _buildDetailRow(
                            size,
                            l10n.valueLabel,
                            "${programming.programmingValue.toString()} watts",
                          ),
                          _buildDetailRow(
                            size,
                            l10n.productLabel,
                            '${programming.productName} (${programming.productCode})',
                          ),
                          _buildDetailRow(
                            size,
                            l10n.hoseLabel,
                            '${programming.hoseCode} - #${programming.hoseNumber}',
                          ),
                          _buildDetailRow(
                            size,
                            l10n.systemLabel,
                            programming.systemName,
                          ),
                          _buildDetailRow(
                            size,
                            l10n.registrationDateLabel,
                            _formatDate(programming.registrationDate),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    Text(
                      l10n.actionsLabel,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: programming.programmingStatusId == 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            await tankio
                                .changeStatusProgramming(programming.uuid, 1)
                                .then((value) {
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF60AF47),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            l10n.authorizeButton,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          programming.programmingStatusId == 1 ||
                          programming.programmingStatusId == 6,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            await tankio
                                .changeStatusProgramming(programming.uuid, 0)
                                .then((value) {
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2984D1),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            l10n.releaseAuthorizationButton,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: programming.programmingStatusId == 3,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),

                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.popAndPushNamed(
                              context,
                              '/activity-electric-charger',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE1712B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            l10n.viewActivityButton,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ///////
                    Visibility(
                      visible:
                          programming.programmingStatusId == 0 ||
                          programming.programmingStatusId == 1,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),

                        child: OutlinedButton(
                          onPressed: () async {
                            await tankio
                                .changeStatusProgramming(programming.uuid, 4)
                                .then((value) {
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            l10n.cancelAuthorizationButton,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: size.width * 0.035,
                              color: Colors.black,
                            ),
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

  Widget _buildDetailRow(
    Size size,
    String label,
    String value, {
    bool isLast = false,
  }) {
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
            width: size.width * 0.33,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.032,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.035,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) {
      return value.isNotEmpty ? value : '-';
    }

    String twoDigits(int number) => number.toString().padLeft(2, '0');

    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}
