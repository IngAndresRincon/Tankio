import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/balance.dart';

class BalanceGroupModal extends ConsumerWidget {
  const BalanceGroupModal({super.key});

  String _formatBalance(num value) {
    return NumberFormat.decimalPattern('es_CO').format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final balance = ref.watch(balanceProvider);
    final selectedGroup = balance.selectedBalanceGroup;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.82,
      builder: (context, scrollController) {
        return Container(
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
                  color: Colors.grey,
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
                      l10n.selectBalanceGroupTitle,
                      style: TextStyle(
                        color: const Color(0xFF60AF47),
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.036,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.chooseBalanceGroupSubtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: size.width * 0.031,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    DropdownButtonFormField<int>(
                      initialValue: selectedGroup?.balanceId,
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.grey.shade800,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.groups_rounded),
                        labelText: l10n.selectGroupLabel,
                        labelStyle: TextStyle(
                          fontFamily: 'Nunito',
                          color: Colors.grey.shade700,
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w300,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: balance.balanceGroup
                          .map(
                            (group) => DropdownMenuItem<int>(
                              value: group.balanceId,
                              child: Text(
                                '${group.groupName} - \$ ${_formatBalance(group.balance)}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        ref.read(balanceProvider).selectBalanceGroupById(value);
                      },
                    ),
                    const SizedBox(height: 18),
                    if (selectedGroup != null) ...[
                      _InfoCard(
                        title: l10n.selectedBalanceTitle,
                        children: [
                          _DetailRow(
                            label: l10n.groupLabel,
                            value: selectedGroup.groupName,
                          ),
                          _DetailRow(
                            label: l10n.companyLabel,
                            value: selectedGroup.companyName,
                          ),
                          _DetailRow(
                            label: l10n.addressLabel,
                            value: selectedGroup.address,
                          ),
                          _DetailRow(
                            label: l10n.prefixLabel,
                            value: selectedGroup.prefixCode,
                          ),
                          _DetailRow(
                            label: l10n.lastMoveLabel,
                            value: selectedGroup.lastMoveDate,
                            isLast: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F9F3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5E8E2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.availableBalanceLabel,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.031,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$ ${_formatBalance(selectedGroup.balance)}',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: size.width * 0.075,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: selectedGroup == null
                          ? null
                          : () {
                              balance.setUserBalance();
                              Navigator.of(context).pop();
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
                        l10n.useThisBalanceButton,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.035,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          l10n.cancel,
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

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

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
            width: 90,
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
