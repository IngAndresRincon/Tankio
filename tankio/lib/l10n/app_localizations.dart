import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tankio'**
  String get appTitle;

  /// No description provided for @selectLanguageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguageTooltip;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @biometricTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Biometric'**
  String get biometricTitle;

  /// No description provided for @biometricWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get biometricWelcomeTitle;

  /// No description provided for @biometricWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use Touch ID or Face ID to continue'**
  String get biometricWelcomeSubtitle;

  /// No description provided for @biometricUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Biometrics'**
  String get biometricUnlockButton;

  /// No description provided for @biometricLoginWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Login with email instead'**
  String get biometricLoginWithEmail;

  /// No description provided for @biometricPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric access'**
  String get biometricPermissionTitle;

  /// No description provided for @biometricPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'First enable biometric authentication permissions on your device to continue using Face ID or Touch ID.'**
  String get biometricPermissionMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginWelcomeTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your fuel and EV services, ready when you are'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orText;

  /// No description provided for @biometricContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Biometrics'**
  String get biometricContinueButton;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccountPrompt;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join to fuel, charge, pay and manage vehicle'**
  String get createAccountSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameLabel;

  /// No description provided for @documentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select document type'**
  String get documentTypeLabel;

  /// No description provided for @documentNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your document number'**
  String get documentNumberLabel;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get registerEmailLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordLabel;

  /// No description provided for @registerActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerActionTitle;

  /// No description provided for @registerActionMessage.
  ///
  /// In en, this message translates to:
  /// **'Please wait while the information is entered.'**
  String get registerActionMessage;

  /// No description provided for @registerSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful'**
  String get registerSuccessTitle;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully. You can now log in with your email and password.'**
  String get registerSuccessMessage;

  /// No description provided for @registerSuccessButton.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get registerSuccessButton;

  /// No description provided for @registerErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerErrorTitle;

  /// No description provided for @registerErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not complete your registration. Please review the information and try again.'**
  String get registerErrorMessage;

  /// No description provided for @registerErrorButton.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get registerErrorButton;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @termsAgreement.
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to our Terms of Service and Privacy Policy.'**
  String get termsAgreement;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'I already have an account ? '**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @accountInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfoTitle;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// No description provided for @personalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfoTitle;

  /// No description provided for @personalInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfoSubtitle;

  /// No description provided for @vehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehiclesTitle;

  /// No description provided for @vehiclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehiclesSubtitle;

  /// No description provided for @myQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'My QR code'**
  String get myQrCodeTitle;

  /// No description provided for @yourQrIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Your QR identifier'**
  String get yourQrIdentifier;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordSubtitle;

  /// No description provided for @biometricAuthenticationTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthenticationTitle;

  /// No description provided for @biometricAuthenticationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthenticationSubtitle;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account Tankio'**
  String get deleteAccountSubtitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSubtitle;

  /// No description provided for @termsConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditionsTitle;

  /// No description provided for @termsConditionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditionsSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @requestDeletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Request account deletion'**
  String get requestDeletionTitle;

  /// No description provided for @requestDeletionMessage.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent. Once your account is deleted, you will not be able to recover your profile or the information associated with it.'**
  String get requestDeletionMessage;

  /// No description provided for @whatWillBeLostTitle.
  ///
  /// In en, this message translates to:
  /// **'What will be lost'**
  String get whatWillBeLostTitle;

  /// No description provided for @profileInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile information'**
  String get profileInformationTitle;

  /// No description provided for @profileInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal account data, login access and profile preferences will be removed.'**
  String get profileInformationSubtitle;

  /// No description provided for @savedVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved vehicles'**
  String get savedVehiclesTitle;

  /// No description provided for @savedVehiclesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Registered vehicles and associated tags or references will no longer be available.'**
  String get savedVehiclesSubtitle;

  /// No description provided for @historyRecordsTitle.
  ///
  /// In en, this message translates to:
  /// **'History and records'**
  String get historyRecordsTitle;

  /// No description provided for @historyRecordsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Purchases, balance movements, notifications and activity history will be removed from the app.'**
  String get historyRecordsSubtitle;

  /// No description provided for @qrAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'QR and access identifiers'**
  String get qrAccessTitle;

  /// No description provided for @qrAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your access identifiers and session-related information will be invalidated.'**
  String get qrAccessSubtitle;

  /// No description provided for @scanQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCodeTitle;

  /// No description provided for @scanQrCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code'**
  String get scanQrCodeLabel;

  /// No description provided for @scanQrCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Align the QR code to quickly start the fueling or charging session.'**
  String get scanQrCodeSubtitle;

  /// No description provided for @refundRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund request'**
  String get refundRequestTitle;

  /// No description provided for @ifYouStillHaveBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'If you still have balance'**
  String get ifYouStillHaveBalanceTitle;

  /// No description provided for @refundRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'Before deleting the account, request the refund of any remaining balance by sending an email to:'**
  String get refundRequestMessage;

  /// No description provided for @refundRequestInstructions.
  ///
  /// In en, this message translates to:
  /// **'Include your registered email and a short request so the team can validate the refund before the deletion is processed.'**
  String get refundRequestInstructions;

  /// No description provided for @deleteAccountNotice.
  ///
  /// In en, this message translates to:
  /// **'After deletion, you will no longer be able to sign in with this account, and the related data will be removed according to the application\'s retention rules.'**
  String get deleteAccountNotice;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountButton;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to continue? This action is permanent and the account cannot be restored once deleted.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete it'**
  String get deleteAccountConfirmButton;

  /// No description provided for @changePasswordTitleScreen.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitleScreen;

  /// No description provided for @currentPasswordSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPasswordSectionTitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get currentPasswordLabel;

  /// No description provided for @currentPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordInvalid;

  /// No description provided for @currentPasswordValid.
  ///
  /// In en, this message translates to:
  /// **'Current password is valid'**
  String get currentPasswordValid;

  /// No description provided for @newPasswordSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordSectionTitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get newPasswordLabel;

  /// No description provided for @atLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get atLeast8Characters;

  /// No description provided for @atLeastOneUppercase.
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter (A-Z)'**
  String get atLeastOneUppercase;

  /// No description provided for @atLeastOneNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one number (0-9)'**
  String get atLeastOneNumber;

  /// No description provided for @atLeastOneSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'At least one special character (!@#&)'**
  String get atLeastOneSpecialCharacter;

  /// No description provided for @confirmNewPasswordSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPasswordSectionTitle;

  /// No description provided for @confirmNewPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmNewPasswordLabel;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Password does not match'**
  String get passwordNotMatch;

  /// No description provided for @passwordMatch.
  ///
  /// In en, this message translates to:
  /// **'Password matches'**
  String get passwordMatch;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordButton;

  /// No description provided for @notificationsTitleScreen.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitleScreen;

  /// No description provided for @deleteNotificationAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteNotificationAction;

  /// No description provided for @termsConditionsTitleScreen.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditionsTitleScreen;

  /// No description provided for @legalTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Terms of Service'**
  String get legalTermsTitle;

  /// No description provided for @termsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: October 26, 2024'**
  String get termsLastUpdated;

  /// No description provided for @termsSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get termsSection1Title;

  /// No description provided for @termsSection1Body.
  ///
  /// In en, this message translates to:
  /// **'INSEPET provides fuel station and electric vehicle charging services through our mobile application. These terms govern your use of the app, including balance management, vehicle registration, and QR-based equipment interaction. By using INSEPET, you agree to comply with these terms. We may update these terms from time to time. Continued use means you accept any changes.'**
  String get termsSection1Body;

  /// No description provided for @termsSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Account Registration'**
  String get termsSection2Title;

  /// No description provided for @termsSection2Body.
  ///
  /// In en, this message translates to:
  /// **'You must provide accurate personal information including name, document type, email, and phone number. You are responsible for maintaining the confidentiality of your login credentials. Biometric authentication can be enabled for faster access. You must be at least 18 years old to register. One account per user is permitted. We reserve the right to verify your identity.'**
  String get termsSection2Body;

  /// No description provided for @termsSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Privacy & Data Security'**
  String get termsSection3Title;

  /// No description provided for @termsSection3Body.
  ///
  /// In en, this message translates to:
  /// **'Your personal data is protected according to our Privacy Policy. Biometric data never leaves your device and is not shared with us. Transaction history, vehicle information, and payment methods are stored securely. We do not sell your data to third parties. Location access is required for map and nearby station features. You can request data deletion by contacting support.'**
  String get termsSection3Body;

  /// No description provided for @termsSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Wallet & Payment'**
  String get termsSection4Title;

  /// No description provided for @termsSection4Body.
  ///
  /// In en, this message translates to:
  /// **'You can recharge your INSEPET wallet using the Epayco payment gateway. All transactions are final unless a technical error occurs. Refunds are processed within 7-10 business days after approval. Minimum recharge amount may apply. Your wallet balance can be used for both fuel and charging sessions. We are not responsible for third-party payment processor delays.'**
  String get termsSection4Body;

  /// No description provided for @termsSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. QR Code & Equipment Use'**
  String get termsSection5Title;

  /// No description provided for @termsSection5Body.
  ///
  /// In en, this message translates to:
  /// **'Scan Tankio or Inselect QR codes to start fueling or charging sessions. You must ensure the equipment is compatible with your vehicle. Do not leave your vehicle unattended during active sessions. The QR code payload is encrypted for security. Report any malfunctioning equipment immediately.'**
  String get termsSection5Body;

  /// No description provided for @termsSection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. Vehicle Registration'**
  String get termsSection6Title;

  /// No description provided for @termsSection6Body.
  ///
  /// In en, this message translates to:
  /// **'You can register multiple vehicles under your account. Electric vehicles require connector type selection. You must provide accurate plate numbers and vehicle details. Active vehicles can be set as default for faster sessions. Fake or incorrect vehicle information may lead to account suspension.'**
  String get termsSection6Body;

  /// No description provided for @termsAgreementText.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms & conditions'**
  String get termsAgreementText;

  /// No description provided for @acceptAndContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Accept and continue'**
  String get acceptAndContinueButton;

  /// No description provided for @homeWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get homeWelcomeBack;

  /// No description provided for @walletBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalanceLabel;

  /// No description provided for @availableFundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Funds'**
  String get availableFundsLabel;

  /// No description provided for @groupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupLabel;

  /// No description provided for @lastTopUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Last top-up: '**
  String get lastTopUpLabel;

  /// No description provided for @rechargeButton.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get rechargeButton;

  /// No description provided for @viewWalletButton.
  ///
  /// In en, this message translates to:
  /// **'View Wallet'**
  String get viewWalletButton;

  /// No description provided for @activityLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityLabel;

  /// No description provided for @vehiclesLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehiclesLabel;

  /// No description provided for @bookingLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookingLabel;

  /// No description provided for @historyLabel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyLabel;

  /// No description provided for @recentActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivityLabel;

  /// No description provided for @noRecentActivityMessage.
  ///
  /// In en, this message translates to:
  /// **'No recent activity found.'**
  String get noRecentActivityMessage;

  /// No description provided for @informationTitle.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get informationTitle;

  /// No description provided for @programmingErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Programming Error'**
  String get programmingErrorTitle;

  /// No description provided for @insufficientBalanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Your balance is not enough to start a booking. Please recharge first at the station you want to use.'**
  String get insufficientBalanceMessage;

  /// No description provided for @programmingInsufficientBalanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance to create the schedule.'**
  String get programmingInsufficientBalanceMessage;

  /// No description provided for @noBalanceGroupsMessage.
  ///
  /// In en, this message translates to:
  /// **'No balance groups were found for this user.'**
  String get noBalanceGroupsMessage;

  /// No description provided for @homeNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavHome;

  /// No description provided for @homeNavMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get homeNavMap;

  /// No description provided for @homeNavPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get homeNavPurchase;

  /// No description provided for @homeNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeNavProfile;

  /// No description provided for @notImplemented.
  ///
  /// In en, this message translates to:
  /// **'Not implemented'**
  String get notImplemented;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activityRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get activityRegistered;

  /// No description provided for @activityWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get activityWaiting;

  /// No description provided for @activityAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Authorized'**
  String get activityAuthorized;

  /// No description provided for @activityInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get activityInProgress;

  /// No description provided for @activityCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get activityCancelled;

  /// No description provided for @activityRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get activityRejected;

  /// No description provided for @activityIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get activityIncomplete;

  /// No description provided for @activityCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get activityCompleted;

  /// No description provided for @activityStopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get activityStopped;

  /// No description provided for @activityAuthorizePayment.
  ///
  /// In en, this message translates to:
  /// **'Authorize your payment'**
  String get activityAuthorizePayment;

  /// No description provided for @activityPaymentInProgress.
  ///
  /// In en, this message translates to:
  /// **'Payment in progress'**
  String get activityPaymentInProgress;

  /// No description provided for @activityNoInformation.
  ///
  /// In en, this message translates to:
  /// **'No information'**
  String get activityNoInformation;

  /// No description provided for @purchaseHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get purchaseHistoryTitle;

  /// No description provided for @noPurchaseHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No purchase history found'**
  String get noPurchaseHistoryFound;

  /// No description provided for @reservationLabel.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get reservationLabel;

  /// No description provided for @purchaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchaseLabel;

  /// No description provided for @saleLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get saleLabel;

  /// No description provided for @discountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountLabel;

  /// No description provided for @returnLabel.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnLabel;

  /// No description provided for @refundLabel.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refundLabel;

  /// No description provided for @balanceMovementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Balance Movements'**
  String get balanceMovementsTitle;

  /// No description provided for @balanceMovementEmpty.
  ///
  /// In en, this message translates to:
  /// **'No balance movements found'**
  String get balanceMovementEmpty;

  /// No description provided for @purchaseInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase information'**
  String get purchaseInformationTitle;

  /// No description provided for @saleValuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sale values'**
  String get saleValuesTitle;

  /// No description provided for @saleIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Sale ID'**
  String get saleIdLabel;

  /// No description provided for @systemLabel.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLabel;

  /// No description provided for @companyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get companyLabel;

  /// No description provided for @stationAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Station address'**
  String get stationAddressLabel;

  /// No description provided for @productLabel.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productLabel;

  /// No description provided for @identifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get identifierLabel;

  /// No description provided for @programmingMoneyLabel.
  ///
  /// In en, this message translates to:
  /// **'Programming money'**
  String get programmingMoneyLabel;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @moneyLabel.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get moneyLabel;

  /// No description provided for @powerLabel.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get powerLabel;

  /// No description provided for @chargingProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'Charging Process'**
  String get chargingProcessTitle;

  /// No description provided for @sessionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetailsTitle;

  /// No description provided for @currentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentLabel;

  /// No description provided for @voltageLabel.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get voltageLabel;

  /// No description provided for @estimatedCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get estimatedCostLabel;

  /// No description provided for @stopChargingButton.
  ///
  /// In en, this message translates to:
  /// **'Stop Charging'**
  String get stopChargingButton;

  /// No description provided for @totalPowerLabel.
  ///
  /// In en, this message translates to:
  /// **'Total power'**
  String get totalPowerLabel;

  /// No description provided for @initialDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial date'**
  String get initialDateLabel;

  /// No description provided for @finalDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Final date'**
  String get finalDateLabel;

  /// No description provided for @zeroSaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Zero sale'**
  String get zeroSaleLabel;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @selectBalanceGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Select balance group'**
  String get selectBalanceGroupTitle;

  /// No description provided for @chooseBalanceGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the group where you want to use the balance'**
  String get chooseBalanceGroupSubtitle;

  /// No description provided for @selectGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Select group'**
  String get selectGroupLabel;

  /// No description provided for @selectedBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected balance'**
  String get selectedBalanceTitle;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @prefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Prefix'**
  String get prefixLabel;

  /// No description provided for @lastMoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Last move'**
  String get lastMoveLabel;

  /// No description provided for @availableBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get availableBalanceLabel;

  /// No description provided for @useThisBalanceButton.
  ///
  /// In en, this message translates to:
  /// **'Use this balance'**
  String get useThisBalanceButton;

  /// No description provided for @currentBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalanceLabel;

  /// No description provided for @balanceStationHintLabel.
  ///
  /// In en, this message translates to:
  /// **'If you cannot see your balance, first select your station from the icon in the top right corner.'**
  String get balanceStationHintLabel;

  /// No description provided for @stationBalanceAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Station balance'**
  String get stationBalanceAlertTitle;

  /// No description provided for @stationBalanceAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'There are currently no available balance records to select.'**
  String get stationBalanceAlertMessage;

  /// No description provided for @selectStationLabel.
  ///
  /// In en, this message translates to:
  /// **'Select station'**
  String get selectStationLabel;

  /// No description provided for @scanStationQrHelpLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code here to identify the station'**
  String get scanStationQrHelpLabel;

  /// No description provided for @selectPaymentGatewayLabel.
  ///
  /// In en, this message translates to:
  /// **'Select payment gateway'**
  String get selectPaymentGatewayLabel;

  /// No description provided for @enterAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmountLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @transactionFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transaction fee'**
  String get transactionFeeLabel;

  /// No description provided for @totalToPayLabel.
  ///
  /// In en, this message translates to:
  /// **'Total to pay'**
  String get totalToPayLabel;

  /// No description provided for @continueToPayButton.
  ///
  /// In en, this message translates to:
  /// **'Continue to Pay'**
  String get continueToPayButton;

  /// No description provided for @nearbyStationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Station'**
  String get nearbyStationsTitle;

  /// No description provided for @enterStationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter the station name'**
  String get enterStationNameLabel;

  /// No description provided for @editModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Edit mode is disabled'**
  String get editModeDisabled;

  /// No description provided for @editModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Edit mode is enabled'**
  String get editModeEnabled;

  /// No description provided for @requiredFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredFieldMessage;

  /// No description provided for @invalidEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmailMessage;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChangesButton;

  /// No description provided for @myVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehiclesTitle;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @plateLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get plateLabel;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @addVehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicles'**
  String get addVehiclesTitle;

  /// No description provided for @addVehicleDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your vehicle details'**
  String get addVehicleDetailsTitle;

  /// No description provided for @addVehicleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register your vehicle to manage maintenance and track performance metrics.'**
  String get addVehicleSubtitle;

  /// No description provided for @fuelLabel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuelLabel;

  /// No description provided for @electricLabel.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get electricLabel;

  /// No description provided for @plateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get plateNumberLabel;

  /// No description provided for @vehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleLabel;

  /// No description provided for @vehicleTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleTypeTitle;

  /// No description provided for @selectVehicleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle type'**
  String get selectVehicleTypeLabel;

  /// No description provided for @vehicleBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Brand'**
  String get vehicleBrandTitle;

  /// No description provided for @selectBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Select brand'**
  String get selectBrandLabel;

  /// No description provided for @vehicleModelTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModelTitle;

  /// No description provided for @selectModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Select model'**
  String get selectModelLabel;

  /// No description provided for @connectorTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Connector Type (Electric Only)'**
  String get connectorTypeTitle;

  /// No description provided for @selectConnectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Select connector'**
  String get selectConnectorLabel;

  /// No description provided for @saveVehicleButton.
  ///
  /// In en, this message translates to:
  /// **'Save Vehicle'**
  String get saveVehicleButton;

  /// No description provided for @waitAMomentMessage.
  ///
  /// In en, this message translates to:
  /// **'Wait a moment.'**
  String get waitAMomentMessage;

  /// No description provided for @securitySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettingsTitle;

  /// No description provided for @biometricAuthenticationHeader.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthenticationHeader;

  /// No description provided for @biometricProtectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protected by your device\'s secure hardware'**
  String get biometricProtectionSubtitle;

  /// No description provided for @enableBiometricLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric login'**
  String get enableBiometricLoginTitle;

  /// No description provided for @enableBiometricLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use biometric to login to your account'**
  String get enableBiometricLoginSubtitle;

  /// No description provided for @faceIdTitle.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceIdTitle;

  /// No description provided for @faceIdSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Device support Face ID'**
  String get faceIdSubtitle;

  /// No description provided for @biometricDataSecureMessage.
  ///
  /// In en, this message translates to:
  /// **'Your biometric data is securely stored on your device and is never shared with the app'**
  String get biometricDataSecureMessage;

  /// No description provided for @aboutBiometricLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'About Biometric Login'**
  String get aboutBiometricLoginTitle;

  /// No description provided for @fasterAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Faster Access'**
  String get fasterAccessTitle;

  /// No description provided for @fasterAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In quickly without typing your password'**
  String get fasterAccessSubtitle;

  /// No description provided for @secureAndPrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure & Private'**
  String get secureAndPrivateTitle;

  /// No description provided for @secureAndPrivateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your biometric data stays on your device'**
  String get secureAndPrivateSubtitle;

  /// No description provided for @youAreInControlTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re in control'**
  String get youAreInControlTitle;

  /// No description provided for @youAreInControlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can turn biometric login on or off anytime'**
  String get youAreInControlSubtitle;

  /// No description provided for @otherOptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Other options'**
  String get otherOptionsTitle;

  /// No description provided for @usePasswordInsteadTitle.
  ///
  /// In en, this message translates to:
  /// **'Use password Instead'**
  String get usePasswordInsteadTitle;

  /// No description provided for @usePasswordInsteadSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in using your account password'**
  String get usePasswordInsteadSubtitle;

  /// No description provided for @manageBiometricPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage biometric permissions'**
  String get manageBiometricPermissionsTitle;

  /// No description provided for @manageBiometricPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update biometric access in your device settings'**
  String get manageBiometricPermissionsSubtitle;

  /// No description provided for @inselectScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Inselect Schedule'**
  String get inselectScheduleTitle;

  /// No description provided for @selectVehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicleLabel;

  /// No description provided for @selectVehicleDropdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Select vehicle'**
  String get selectVehicleDropdownLabel;

  /// No description provided for @connectorTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Connector Type'**
  String get connectorTypeLabel;

  /// No description provided for @selectFuelLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Fuel'**
  String get selectFuelLabel;

  /// No description provided for @amountSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountSectionLabel;

  /// No description provided for @valueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get valueLabel;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTitle;

  /// No description provided for @moneySummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get moneySummaryLabel;

  /// No description provided for @powerSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get powerSummaryLabel;

  /// No description provided for @connectorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Connector Name'**
  String get connectorNameLabel;

  /// No description provided for @rateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rateLabel;

  /// No description provided for @estimatedTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total'**
  String get estimatedTotalLabel;

  /// No description provided for @confirmScheduleButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Schedule'**
  String get confirmScheduleButton;

  /// No description provided for @scheduleConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule confirmation'**
  String get scheduleConfirmationTitle;

  /// No description provided for @scheduleConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Your schedule has been registered, authorize your electric charging from the activity view.'**
  String get scheduleConfirmationMessage;

  /// No description provided for @scheduleErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule Error'**
  String get scheduleErrorTitle;

  /// No description provided for @scheduleErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We were unable to create the schedule for your electric vehicle charging.'**
  String get scheduleErrorMessage;

  /// No description provided for @qrDoesNotBelongTitle.
  ///
  /// In en, this message translates to:
  /// **'QR does not belong to the available balance'**
  String get qrDoesNotBelongTitle;

  /// No description provided for @qrDoesNotBelongMessage.
  ///
  /// In en, this message translates to:
  /// **'The scanned QR code does not match the available balance information. Please validate the station balance and the correct group.'**
  String get qrDoesNotBelongMessage;

  /// No description provided for @activeLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeLabel;

  /// No description provided for @inactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactiveLabel;

  /// No description provided for @stationInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Station information'**
  String get stationInformationTitle;

  /// No description provided for @stationTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Station type'**
  String get stationTypeLabel;

  /// No description provided for @webPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Web page'**
  String get webPageLabel;

  /// No description provided for @uuidLabel.
  ///
  /// In en, this message translates to:
  /// **'UUID'**
  String get uuidLabel;

  /// No description provided for @openRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Open route'**
  String get openRouteTitle;

  /// No description provided for @wazeLabel.
  ///
  /// In en, this message translates to:
  /// **'Waze'**
  String get wazeLabel;

  /// No description provided for @googleMapsLabel.
  ///
  /// In en, this message translates to:
  /// **'Google Maps'**
  String get googleMapsLabel;

  /// No description provided for @noMapAppInstalledMessage.
  ///
  /// In en, this message translates to:
  /// **'No map app is installed on this device.'**
  String get noMapAppInstalledMessage;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you confirm that you want to exit the application? You can return later using biometric login.'**
  String get logoutConfirmMessage;

  /// No description provided for @yesLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, logout'**
  String get yesLogoutButton;

  /// No description provided for @sessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpiredTitle;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please login again to continue.'**
  String get sessionExpiredMessage;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// No description provided for @programmingIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Programming ID'**
  String get programmingIdLabel;

  /// No description provided for @authorizeButton.
  ///
  /// In en, this message translates to:
  /// **'Authorize'**
  String get authorizeButton;

  /// No description provided for @releaseAuthorizationButton.
  ///
  /// In en, this message translates to:
  /// **'Release authorization'**
  String get releaseAuthorizationButton;

  /// No description provided for @viewActivityButton.
  ///
  /// In en, this message translates to:
  /// **'View activity'**
  String get viewActivityButton;

  /// No description provided for @cancelAuthorizationButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel authorization'**
  String get cancelAuthorizationButton;

  /// No description provided for @actionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsLabel;

  /// No description provided for @registrationDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Registration date'**
  String get registrationDateLabel;

  /// No description provided for @vehicleInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleInfoLabel;

  /// No description provided for @hoseLabel.
  ///
  /// In en, this message translates to:
  /// **'Hose'**
  String get hoseLabel;

  /// No description provided for @activeVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Active vehicle'**
  String get activeVehicleTitle;

  /// No description provided for @setEnableAsDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Set enable as default'**
  String get setEnableAsDefaultLabel;

  /// No description provided for @recoverPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get recoverPasswordTitle;

  /// No description provided for @recoverPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address to receive a recovery link'**
  String get recoverPasswordSubtitle;

  /// No description provided for @recoverPasswordEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get recoverPasswordEmailLabel;

  /// No description provided for @sendRecoveryEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Send recovery email'**
  String get sendRecoveryEmailButton;

  /// No description provided for @rememberPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get rememberPasswordPrompt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
