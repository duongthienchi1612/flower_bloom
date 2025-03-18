import 'package:flutter/material.dart';

/// Các hiệu ứng chuyển trang tùy chỉnh cho ứng dụng
class AppRouteTransitions {
  /// Hiệu ứng fade và scale khi chuyển trang
  static PageRouteBuilder fadeScale({
    required Widget page,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeOutBack;
        var curveTween = CurveTween(curve: curve);

        var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
        var fadeAnimation = fadeTween.animate(animation.drive(curveTween));

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
    );
  }
}
