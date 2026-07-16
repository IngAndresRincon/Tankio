import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tankio/l10n/app_localizations.dart';
import 'package:tankio/provider/user.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  bool showCurrentPassword = false;
  bool showCurrentConfirmPassword = false;
  bool showNewPassword = false;
  bool isValidCurrentPassword = false;
  bool isValidConfirmPassword = false;

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
    final user = ref.watch(userProvider);
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
          l10n.changePasswordTitleScreen,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        children: [
          const SizedBox(height: 10),
          Text(
            l10n.currentPasswordSectionTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: size.width * 0.036,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: user.controllerPasswordLogin,
            keyboardType: TextInputType.text,
            obscureText: !showCurrentPassword,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.grey.shade800,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              setState(() {
                final response = user.validCurrentPassword(value);
                isValidCurrentPassword = response;
              });
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  showCurrentPassword = !showCurrentPassword;
                  setState(() {});
                },
                icon: Icon(
                  !showCurrentPassword
                      ? Icons.key_off_rounded
                      : Icons.key_rounded,
                ),
              ),
              prefixIcon: Icon(Icons.lock_outlined),
              labelText: l10n.currentPasswordLabel,
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

          Align(
            alignment: AlignmentGeometry.centerLeft,
            child: TextButton.icon(
              onPressed: null,
              icon: Icon(
                !isValidCurrentPassword
                    ? Icons.info_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: !isValidCurrentPassword
                    ? const Color(0xFFD92D20)
                    : const Color(0xFF60AF47),
                size: size.width * 0.041,
              ),
                label: Text(
                  !isValidCurrentPassword
                    ? l10n.currentPasswordInvalid
                    : l10n.currentPasswordValid,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  color: !isValidCurrentPassword
                      ? const Color(0xFFD92D20)
                      : const Color(0xFF60AF47),
                  fontSize: size.width * 0.031,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            l10n.newPasswordSectionTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: size.width * 0.036,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            obscureText: !showNewPassword,
            controller: user.controllerNewPassword,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.grey.shade800,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              user.validNewPassword(value);
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showNewPassword = !showNewPassword;
                  });
                },
                icon: Icon(
                  !showNewPassword ? Icons.key_off_rounded : Icons.key_rounded,
                ),
              ),
              labelText: l10n.newPasswordLabel,
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
          Row(
            children: [
              Icon(
                !user.atLeast8Characters
                    ? Icons.circle_outlined
                    : Icons.check_circle_outline_rounded,
                color: !user.atLeast8Characters
                    ? const Color(0xFFD92D20)
                    : const Color(0xFF60AF47),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.atLeast8Characters,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.031,
                  color: const Color(0xFF535862),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                !user.atLeastOneUppercaseLetter
                    ? Icons.circle_outlined
                    : Icons.check_circle_outline_rounded,
                color: !user.atLeastOneUppercaseLetter
                    ? const Color(0xFFD92D20)
                    : const Color(0xFF60AF47),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.atLeastOneUppercase,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.031,
                  color: const Color(0xFF535862),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                !user.atLeastOneNumber
                    ? Icons.circle_outlined
                    : Icons.check_circle_outline_rounded,
                color: !user.atLeastOneNumber
                    ? const Color(0xFFD92D20)
                    : const Color(0xFF60AF47),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.atLeastOneNumber,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.031,
                  color: const Color(0xFF535862),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                !user.atLeastOneSpecialCharacter
                    ? Icons.circle_outlined
                    : Icons.check_circle_outline_rounded,
                color: !user.atLeastOneSpecialCharacter
                    ? const Color(0xFFD92D20)
                    : const Color(0xFF60AF47),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.atLeastOneSpecialCharacter,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: size.width * 0.031,
                  color: const Color(0xFF535862),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          Text(
            l10n.confirmNewPasswordSectionTitle,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: Colors.black,
              fontSize: size.width * 0.036,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: user.controllerConfirmNewPassword,
            obscureText: !showCurrentConfirmPassword,
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.grey.shade800,
              fontSize: size.width * 0.04,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              setState(() {
                isValidConfirmPassword = user.validConfirmPassword();
              });
            },
            decoration: InputDecoration(
              //prefixIcon: Icon(Icons.numbers_outlined),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showCurrentConfirmPassword = !showCurrentConfirmPassword;
                  });
                },
                icon: Icon(
                  !showCurrentConfirmPassword
                      ? Icons.key_off_rounded
                      : Icons.key_rounded,
                ),
              ),
              labelText: l10n.confirmNewPasswordLabel,
              labelStyle: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey.shade700,
                fontSize: size.width * 0.036,
                fontWeight: FontWeight.w300,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Align(
            alignment: AlignmentGeometry.centerLeft,
            child: TextButton.icon(
              onPressed: null,
              icon: Icon(
                !isValidConfirmPassword
                    ? Icons.info_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: !isValidConfirmPassword
                    ? const Color(0xFFD92D20)
                    : const Color(0xFF60AF47),
                size: size.width * 0.041,
              ),
                label: Text(
                  !isValidConfirmPassword
                    ? l10n.passwordNotMatch
                    : l10n.passwordMatch,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  color: !isValidConfirmPassword
                      ? const Color(0xFFD92D20)
                      : const Color(0xFF60AF47),
                  fontSize: size.width * 0.031,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed:
                !isValidCurrentPassword ||
                    !isValidConfirmPassword ||
                    !user.atLeastOneSpecialCharacter ||
                    !user.atLeast8Characters ||
                    !user.atLeastOneNumber ||
                    !user.atLeastOneUppercaseLetter
                ? null
                : () async {
                    await user.changePassword().then((bool value) {
                      if (!context.mounted) return;
                      if (value) Navigator.of(context).pop();
                    });
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF60AF47),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
              child: Text(
              l10n.updatePasswordButton,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: size.width * 0.036,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
