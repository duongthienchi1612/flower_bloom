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

  // /// Hiệu ứng slide từ phải sang trái
  // static PageRouteBuilder slideRight({
  //   required Widget page,
  //   Duration duration = const Duration(milliseconds: 400),
  // }) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => page,
  //     transitionDuration: duration,
  //     reverseTransitionDuration: duration,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var curve = Curves.easeInOut;
  //       var curveTween = CurveTween(curve: curve);
        
  //       var slideTween = Tween<Offset>(
  //         begin: const Offset(1.0, 0.0),
  //         end: Offset.zero,
  //       );
  //       var slideAnimation = slideTween.animate(animation.drive(curveTween));
        
  //       return SlideTransition(
  //         position: slideAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }

  // /// Hiệu ứng slide từ dưới lên
  // static PageRouteBuilder slideUp({
  //   required Widget page,
  //   Duration duration = const Duration(milliseconds: 400),
  // }) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => page,
  //     transitionDuration: duration,
  //     reverseTransitionDuration: duration,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var curve = Curves.easeOutCubic;
  //       var curveTween = CurveTween(curve: curve);
        
  //       var slideTween = Tween<Offset>(
  //         begin: const Offset(0.0, 1.0),
  //         end: Offset.zero,
  //       );
  //       var slideAnimation = slideTween.animate(animation.drive(curveTween));
        
  //       return SlideTransition(
  //         position: slideAnimation,
  //         child: child,
  //       );
  //     },
  //   );
  // }

  // /// Hiệu ứng xoay 3D
  // static PageRouteBuilder rotation3D({
  //   required Widget page,
  //   Duration duration = const Duration(milliseconds: 600),
  // }) {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => page,
  //     transitionDuration: duration,
  //     reverseTransitionDuration: duration,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var curve = Curves.easeOut;
  //       var curveTween = CurveTween(curve: curve);
        
  //       var rotateTween = Tween<double>(begin: 0.5, end: 0.0);
  //       var rotateAnimation = rotateTween.animate(animation.drive(curveTween));
        
  //       var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
  //       var fadeAnimation = fadeTween.animate(animation.drive(curveTween));
        
  //       return FadeTransition(
  //         opacity: fadeAnimation,
  //         child: Transform(
  //           alignment: Alignment.center,
  //           transform: Matrix4.identity()
  //             ..setEntry(3, 2, 0.001)
  //             ..rotateY(rotateAnimation.value * 3.14),
  //           child: child,
  //         ),
  //       );
  //     },
  //   );
  // }
} 