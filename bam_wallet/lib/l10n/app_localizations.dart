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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bam Wallet'**
  String get appTitle;

  /// No description provided for @bodyText.
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get bodyText;

  /// No description provided for @login_instructions.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email and password'**
  String get login_instructions;

  /// No description provided for @loginScreenName.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginScreenName;

  /// No description provided for @label_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get label_email;

  /// No description provided for @label_username.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get label_username;

  /// No description provided for @label_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get label_name;

  /// No description provided for @enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enter_your_email;

  /// No description provided for @enter_your_username.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enter_your_username;

  /// No description provided for @label_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get label_password;

  /// No description provided for @enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enter_your_password;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @invalid_mail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalid_mail;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get password_required;

  /// No description provided for @invalid_password.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get invalid_password;

  /// No description provided for @btn_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get btn_login;

  /// No description provided for @btn_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get btn_logout;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get greeting;

  /// No description provided for @error_401.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get error_401;

  /// No description provided for @error_invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get error_invalid_credentials;

  /// No description provided for @home_good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get home_good_morning;

  /// No description provided for @home_total_balance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get home_total_balance;

  /// No description provided for @home_my_accounts.
  ///
  /// In en, this message translates to:
  /// **'My accounts'**
  String get home_my_accounts;

  /// No description provided for @home_transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get home_transfer;

  /// No description provided for @home_view_history.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get home_view_history;

  /// No description provided for @transfer_title.
  ///
  /// In en, this message translates to:
  /// **'Make Transfer'**
  String get transfer_title;

  /// No description provided for @transfer_source_account.
  ///
  /// In en, this message translates to:
  /// **'Source account'**
  String get transfer_source_account;

  /// No description provided for @transfer_destination_account.
  ///
  /// In en, this message translates to:
  /// **'Destination account number'**
  String get transfer_destination_account;

  /// No description provided for @transfer_destination_hint.
  ///
  /// In en, this message translates to:
  /// **'E.g. 1111222233'**
  String get transfer_destination_hint;

  /// No description provided for @transfer_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get transfer_amount;

  /// No description provided for @transfer_do_transfer.
  ///
  /// In en, this message translates to:
  /// **'Make transfer'**
  String get transfer_do_transfer;

  /// No description provided for @transfer_history_title.
  ///
  /// In en, this message translates to:
  /// **'Transfer history'**
  String get transfer_history_title;

  /// No description provided for @transfer_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Sent to {holder}'**
  String transfer_sent_to(String holder);

  /// No description provided for @transfer_received_from.
  ///
  /// In en, this message translates to:
  /// **'Received from {holder}'**
  String transfer_received_from(String holder);

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get nav_settings;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_section_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settings_section_account;

  /// No description provided for @settings_section_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settings_section_security;

  /// No description provided for @settings_section_preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settings_section_preferences;

  /// No description provided for @settings_account_update_info.
  ///
  /// In en, this message translates to:
  /// **'Update information'**
  String get settings_account_update_info;

  /// No description provided for @settings_security_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get settings_security_change_password;

  /// No description provided for @settings_security_biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric login'**
  String get settings_security_biometric;

  /// No description provided for @settings_security_two_factor.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get settings_security_two_factor;

  /// No description provided for @settings_preferences_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_preferences_notifications;

  /// No description provided for @settings_preferences_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settings_preferences_privacy_policy;

  /// No description provided for @settings_preferences_support.
  ///
  /// In en, this message translates to:
  /// **'Support center'**
  String get settings_preferences_support;

  /// No description provided for @settings_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settings_version;

  /// No description provided for @settings_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get settings_coming_soon;

  /// No description provided for @error_invalid_credentials_400.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please check your username and password.'**
  String get error_invalid_credentials_400;

  /// No description provided for @error_unauthorized_401.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. The credentials you provided are invalid.'**
  String get error_unauthorized_401;

  /// No description provided for @error_forbidden_403.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden. Your account may be suspended.'**
  String get error_forbidden_403;

  /// No description provided for @error_user_not_found_404.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get error_user_not_found_404;

  /// No description provided for @error_server_500.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get error_server_500;

  /// No description provided for @error_server_generic.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get error_server_generic;

  /// No description provided for @error_connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please check your internet connection.'**
  String get error_connection_timeout;

  /// No description provided for @error_receive_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please check your internet connection.'**
  String get error_receive_timeout;

  /// No description provided for @error_send_timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please check your internet connection.'**
  String get error_send_timeout;

  /// No description provided for @error_request_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled.'**
  String get error_request_cancelled;

  /// No description provided for @error_network_unknown.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get error_network_unknown;

  /// No description provided for @error_unexpected.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get error_unexpected;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
