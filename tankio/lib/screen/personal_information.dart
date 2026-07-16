import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';

class PersonalInformation extends ConsumerStatefulWidget {
  const PersonalInformation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEnableEdit = false;

  @override
  void initState() {
    loadProfileData();
    super.initState();
  }

  void loadProfileData() async {
    await Future.microtask(() {
      ref.read(userProvider).loadProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: size.width * 0.06,
          ),
        ),
        title: Text(
          l10n.personalInfoTitle,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE9EAEB)),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isEnableEdit = !isEnableEdit;
                });
              },
              icon: Icon(
                !isEnableEdit ? Icons.edit_square : Icons.check_rounded,
                size: size.width * 0.08,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  !isEnableEdit ? l10n.editModeDisabled : l10n.editModeEnabled,
                  style: TextStyle(
                    color: !isEnableEdit ? Colors.amber : Colors.green,
                    fontSize: size.width * 0.031,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: !isEnableEdit,
                  controller: profile.controllerProfileName,
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
                    counterText: "",
                    prefixIcon: Icon(Icons.person_outline),
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
                  readOnly: !isEnableEdit,
                  controller: profile.controllerProfileLastName,
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
                    counterText: "",
                    prefixIcon: Icon(Icons.person_outline),
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
                  initialValue: profile.selectedDocumentType,
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
                    prefixIcon: Icon(Icons.badge_outlined),
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
                  items: profile.documentTypeList,
                  onChanged: !isEnableEdit
                      ? null
                      : (value) {
                          setState(() {
                            profile.selectedDocumentType = value;
                            profile.controllerProfileDocumentType.text =
                                value ?? '';
                          });
                        },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  readOnly: !isEnableEdit,
                  controller: profile.controllerProfileDocumentNumber,
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
                    return null;
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    prefixIcon: Icon(Icons.numbers),
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
                  readOnly: !isEnableEdit,
                  controller: profile.controllerProfileEmail,
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
                    counterText: "",
                    prefixIcon: Icon(Icons.email_outlined),
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
                  readOnly: !isEnableEdit,
                  controller: profile.controllerProfilePhoneNumber,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 12,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.requiredFieldMessage;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    prefixIcon: Icon(Icons.phone),
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

                ElevatedButton(
                  onPressed: !isEnableEdit
                      ? null
                      : () async {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) {
                            return;
                          }

                          await profile.userEdit().then((bool value) {
                            if (!context.mounted) return;
                            if (value) {
                              setState(() {
                                isEnableEdit = false;
                              });
                            }
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
                    l10n.saveChangesButton,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.035,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
