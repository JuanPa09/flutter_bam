// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bam Wallet';

  @override
  String get bodyText => 'You have pushed the button this many times:';

  @override
  String get login_instructions => 'Sign in with your email and password';

  @override
  String get loginScreenName => 'Login';

  @override
  String get label_email => 'Email';

  @override
  String get label_name => 'Name';

  @override
  String get enter_your_email => 'Enter your email';

  @override
  String get label_password => 'Password';

  @override
  String get enter_your_password => 'Enter your password';

  @override
  String get email_required => 'Email is required';

  @override
  String get invalid_mail => 'Please enter a valid email';

  @override
  String get password_required => 'Password is required';

  @override
  String get invalid_password => 'Password must be at least 6 characters';

  @override
  String get btn_login => 'Login';

  @override
  String get btn_logout => 'Logout';

  @override
  String get greeting => 'Welcome!';

  @override
  String get error_401 => 'Invalid email or password';

  @override
  String get home_good_morning => 'Good morning';

  @override
  String get home_total_balance => 'Total balance';

  @override
  String get home_my_accounts => 'My accounts';

  @override
  String get home_transfer => 'Transfer';

  @override
  String get home_view_history => 'View history';

  @override
  String get transfer_title => 'Make Transfer';

  @override
  String get transfer_source_account => 'Source account';

  @override
  String get transfer_destination_account => 'Destination account number';

  @override
  String get transfer_destination_hint => 'E.g. 1111222233';

  @override
  String get transfer_amount => 'Amount';

  @override
  String get transfer_do_transfer => 'Make transfer';

  @override
  String get transfer_history_title => 'Transfer history';

  @override
  String transfer_sent_to(String holder) {
    return 'Sent to $holder';
  }

  @override
  String transfer_received_from(String holder) {
    return 'Received from $holder';
  }

  @override
  String get nav_home => 'Home';

  @override
  String get nav_settings => 'Settings';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_section_account => 'Account';

  @override
  String get settings_section_security => 'Security';

  @override
  String get settings_section_preferences => 'Preferences';

  @override
  String get settings_account_update_info => 'Update information';

  @override
  String get settings_security_change_password => 'Change password';

  @override
  String get settings_security_biometric => 'Biometric login';

  @override
  String get settings_security_two_factor => 'Two-factor authentication';

  @override
  String get settings_preferences_notifications => 'Notifications';

  @override
  String get settings_preferences_privacy_policy => 'Privacy policy';

  @override
  String get settings_preferences_support => 'Support center';

  @override
  String get settings_version => 'Version';

  @override
  String get settings_coming_soon => 'Coming soon';
}
