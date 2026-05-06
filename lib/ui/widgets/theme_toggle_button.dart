import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return IconButton(
      onPressed: themeProvider.toggleTheme,
      icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
      tooltip: themeProvider.isDarkMode
          ? 'Activer le mode clair'
          : 'Activer le mode sombre',
    );
  }
}