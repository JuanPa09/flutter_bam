// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cartera BAM';

  @override
  String get bodyText => 'Tienes que presionar el boton para contar:';

  @override
  String get login_instructions => 'Inicie sesión con su correo y contraseña';

  @override
  String get loginScreenName => 'Inicio de Sesión';

  @override
  String get label_email => 'Correo electrónico';

  @override
  String get label_username => 'Usuario';

  @override
  String get label_name => 'Nombre';

  @override
  String get enter_your_email => 'Ingrese su correo electrónico';

  @override
  String get enter_your_username => 'Ingrese su contraseña';

  @override
  String get label_password => 'Contraseña';

  @override
  String get enter_your_password => 'Ingrese su contraseña';

  @override
  String get email_required => 'Debe ingresar correo';

  @override
  String get invalid_mail => 'El correo es inválido';

  @override
  String get password_required => 'Debe ingresar contraseña';

  @override
  String get invalid_password => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get btn_login => 'Entrar';

  @override
  String get btn_logout => 'Salir';

  @override
  String get greeting => '¡Bienvenido!';

  @override
  String get error_401 => 'Credenciales invalidas';

  @override
  String get error_invalid_credentials => 'Credenciales inválidas';

  @override
  String get home_good_morning => 'Buenos días';

  @override
  String get home_total_balance => 'Balance total';

  @override
  String get home_my_accounts => 'Mis cuentas';

  @override
  String get home_transfer => 'Transferir';

  @override
  String get home_view_history => 'Ver historial';

  @override
  String get transfer_title => 'Realizar Transferencia';

  @override
  String get transfer_source_account => 'Cuenta origen';

  @override
  String get transfer_destination_account => 'Número de cuenta destino';

  @override
  String get transfer_destination_hint => 'Ej. 1111222233';

  @override
  String get transfer_amount => 'Monto';

  @override
  String get transfer_do_transfer => 'Realizar transferencia';

  @override
  String get transfer_history_title => 'Historial de transferencias';

  @override
  String transfer_sent_to(String holder) {
    return 'Enviado a $holder';
  }

  @override
  String transfer_received_from(String holder) {
    return 'Recibido de $holder';
  }

  @override
  String get nav_home => 'Inicio';

  @override
  String get nav_settings => 'Ajustes';

  @override
  String get settings_title => 'Ajustes';

  @override
  String get settings_section_account => 'Cuenta';

  @override
  String get settings_section_security => 'Seguridad';

  @override
  String get settings_section_preferences => 'Preferencias';

  @override
  String get settings_account_update_info => 'Actualizar información';

  @override
  String get settings_security_change_password => 'Cambiar contraseña';

  @override
  String get settings_security_biometric => 'Inicio de sesión con biometría';

  @override
  String get settings_security_two_factor => 'Autenticación de dos factores';

  @override
  String get settings_preferences_notifications => 'Notificaciones';

  @override
  String get settings_preferences_privacy_policy => 'Políticas de privacidad';

  @override
  String get settings_preferences_support => 'Centro de soporte';

  @override
  String get settings_version => 'Versión';

  @override
  String get settings_coming_soon => 'Próximamente';
}
