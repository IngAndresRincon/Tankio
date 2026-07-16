String normalizeMoneyInput(String value) {
  final trimmed = value.trim().replaceAll(' ', '');
  if (trimmed.isEmpty) {
    return '0';
  }

  final normalized = trimmed.replaceAll(',', '.');
  final parts = normalized.split('.');
  if (parts.length <= 2) {
    return normalized.startsWith('.') ? '0$normalized' : normalized;
  }

  final collapsed = '${parts.first}.${parts.sublist(1).join()}';
  return collapsed.startsWith('.') ? '0$collapsed' : collapsed;
}

double parseMoney(String value) {
  return double.tryParse(normalizeMoneyInput(value)) ?? 0;
}

String formatMoney(num value, {int fractionDigits = 2}) {
  return value.toDouble().toStringAsFixed(fractionDigits);
}
