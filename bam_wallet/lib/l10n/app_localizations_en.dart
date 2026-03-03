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
}
