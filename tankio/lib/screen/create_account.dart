import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';
import 'package:tankio/utils/enum.dart';
import 'package:tankio/widget/modal/status_modal.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  bool showPassword = false;
  bool showConfirmPassword = false;
  String? selectedDocumentType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(userProvider).clearField();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context)!;
    final user = ref.read(userProvider);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height * 0.9,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.createAccountTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.051,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.createAccountSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.036,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: user.controllerRegisterName,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 20,
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
                  controller: user.controllerRegisterLastName,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 20,
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
                  initialValue: selectedDocumentType,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
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
                  items: user.documentTypeList,
                  onChanged: (value) {
                    setState(() {
                      selectedDocumentType = value;
                      user.controllerRegisterDocumentType.text = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: user.controllerRegisterDocumentNumber,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 10,
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
                  controller: user.controllerRegisterEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 60,
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
                  controller: user.controllerRegisterPhoneNumber,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 12,
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

                TextFormField(
                  controller: user.controllerRegisterPassword,
                  obscureText: !showPassword,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 20,
                  decoration: InputDecoration(
                    counterText: "",
                    suffixIcon: IconButton(
                      onPressed: () {
                        showPassword = !showPassword;
                        setState(() {});
                      },
                      icon: Icon(
                        !showPassword
                            ? Icons.key_off_rounded
                            : Icons.key_rounded,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_outlined),
                    labelText: l10n.passwordLabel,
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
                  controller: user.controllerRegisterConfirmPassword,
                  obscureText: !showConfirmPassword,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.grey.shade800,
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 20,
                  decoration: InputDecoration(
                    counterText: "",
                    suffixIcon: IconButton(
                      onPressed: () {
                        showConfirmPassword = !showConfirmPassword;
                        setState(() {});
                      },
                      icon: Icon(
                        !showConfirmPassword
                            ? Icons.key_off_rounded
                            : Icons.key_rounded,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_outlined),
                    labelText: l10n.confirmPasswordLabel,
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

                TextButton(
                  onPressed: () async {
                    AppStatusModal.show(
                      context: context,
                      type: AppModalType.loading,
                      title: l10n.registerActionTitle,
                      message: l10n.registerActionMessage,
                      dismissible: false,
                    );

                    await user.userRegister().then((bool value) {
                      if (value) {
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    });
                  },
                  child: Text(
                    l10n.termsAgreement,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.black87,
                      fontSize: size.width * 0.031,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    await user.userRegister().then((bool value) {
                      if (!context.mounted) return;
                      if (value) {
                        AppStatusModal.show(
                          context: context,
                          dismissible: false,
                          onPrimaryPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          primaryText: l10n.registerSuccessButton,
                          type: AppModalType.success,
                          title: l10n.registerSuccessTitle,
                          message: l10n.registerSuccessMessage,
                        );
                      } else {
                        AppStatusModal.show(
                          context: context,
                          dismissible: false,
                          onPrimaryPressed: () {
                            Navigator.of(context).pop();
                          },
                          primaryText: l10n.registerErrorButton,
                          type: AppModalType.error,
                          title: l10n.registerErrorTitle,
                          message: l10n.registerErrorMessage,
                        );
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
                    l10n.createAccountButton,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: size.width * 0.035,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: size.height * 0.1,
            child: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: RichText(
                  text: TextSpan(
                    text: l10n.alreadyHaveAccountPrompt,
                    style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: l10n.signIn,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF60AF47),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
