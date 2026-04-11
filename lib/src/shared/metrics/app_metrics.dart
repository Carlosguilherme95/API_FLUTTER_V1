import 'package:flutter/material.dart';

abstract final class AppMetrics {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;

  static EdgeInsets get screenHorizontal =>
      const EdgeInsets.symmetric(horizontal: md);

  static EdgeInsets get sectionPadding => const EdgeInsets.all(md);
}
