import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final prefs = await getPrefs();

    final theme = prefs.getInt("ThemeMode") ?? ThemeMode.system.index;

    return ThemeMode.values[theme];
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final prefs = await getPrefs();

    await prefs.setInt("ThemeMode", theme.index);
  }

  Future<SharedPreferences> getPrefs() async {
    WidgetsFlutterBinding.ensureInitialized();

    return await SharedPreferences.getInstance();
  }
}
