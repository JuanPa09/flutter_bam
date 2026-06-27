import 'dart:ui';
import 'package:bam_wallet/core/local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _localeKey = 'app_locale';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('es')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final saved = LocalStorage().prefs.getString(_localeKey);
    if (saved != null) {
      state = Locale(saved);
    }
  }

  Future<void> setLocale(Locale locale) async {
    await LocalStorage().prefs.setString(_localeKey, locale.languageCode);
    state = locale;
  }

  void toggle() {
    setLocale(
      state.languageCode == 'es' ? const Locale('en') : const Locale('es'),
    );
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
