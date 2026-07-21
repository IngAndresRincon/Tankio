import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/sale.dart';

class EditCustomerModal extends ConsumerStatefulWidget {
  const EditCustomerModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCustomerModalState();
}

class _EditCustomerModalState extends ConsumerState<EditCustomerModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadInvoiceCustomerData();
    super.initState();
  }

  void loadInvoiceCustomerData() async {
    await Future.microtask(() {
      ref.read(saleProvider).loadInvoiceCustomerData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final sale = ref.watch(saleProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.editCustomerTitle,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE9EAEB)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.editModeEnabled,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: size.width * 0.031,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: sale.controllerInvoiceName,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredFieldMessage;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.red,
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: "",
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: l10n.nameLabel,
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
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: sale.controllerInvoiceLastName,
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 20,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredFieldMessage;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.red,
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: "",
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: l10n.lastNameLabel,
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
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: sale.selectedDocumentType,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredFieldMessage;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.red,
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: const Icon(Icons.badge_outlined),
                      labelText: l10n.documentTypeLabel,
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
                    items: sale.documentTypeList,
                    onChanged: (value) {
                      setState(() {
                        sale.selectedDocumentType = value;
                        sale.controllerInvoiceDocumentType.text = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: sale.controllerInvoiceDocumentNumber,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredFieldMessage;
                      }
                      if (value.length < 6) {
                        return l10n.minCharactersMessage;
                      }
                      final numberRegex = RegExp(r'^[0-9]+$');
                      if (!numberRegex.hasMatch(value.trim())) {
                        return l10n.invalidNumericMessage;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.red,
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: "",
                      prefixIcon: const Icon(Icons.numbers),
                      labelText: l10n.documentNumberLabel,
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
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: sale.controllerInvoiceEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 60,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredFieldMessage;
                      }
                      final email = value.trim();
                      final emailRegex = RegExp(
                        r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$',
                      );
                      if (!emailRegex.hasMatch(email)) {
                        return l10n.invalidEmailMessage;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.red,
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: "",
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: l10n.registerEmailLabel,
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
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: sale.controllerInvoicePhoneNumber,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.grey.shade800,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredFieldMessage;
                      }
                      if (value.length < 10) {
                        return l10n.minCharactersMessage;
                      }

                      final numberRegex = RegExp(r'^[0-9]+$');
                      if (!numberRegex.hasMatch(value.trim())) {
                        return l10n.invalidNumericMessage;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.red,
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: "",
                      prefixIcon: const Icon(Icons.phone),
                      labelText: l10n.phoneNumberLabel,
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
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) {
                          return;
                        }

                        bool saved = await sale.updateInvoiceCustomerData();

                        if (!context.mounted) return;
                        if (saved) {
                          Navigator.of(context).pop(true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.editCustomerErrorMessage),
                            ),
                          );
                        }
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
                        l10n.saveChangesButton,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: size.width * 0.035,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
