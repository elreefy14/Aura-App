import 'package:flutter/material.dart';

extension ContextLess on BuildContext {
  NavigatorState get nav {
    return Navigator.of(this);
  }

  ColorScheme get color {
    return Theme.of(this).colorScheme;
  }
}
