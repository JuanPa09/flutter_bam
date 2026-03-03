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
  String get label_name => 'Nombre';

  @override
  String get enter_your_email => 'Ingrese su correo electrónico';

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
}
