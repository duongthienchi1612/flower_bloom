import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';

class LottieItem extends StatefulWidget {
  final String animation;
  final bool isBloom;
  final double size;
  final bool shouldAnimate;

  const LottieItem({
    Key? key,
    required this.animation,
    required this.isBloom,
    required this.size,
    this.shouldAnimate = false,
  }) : super(key: key);

  @override
  _LottieItemState createState() => _LottieItemState();
}

class _LottieItemState extends State<LottieItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationComplete = true;
        });
      }
    });

    if (widget.shouldAnimate) {
      _controller.forward(from: 0.0);
    } else {
      // Nếu không cần animation, đặt controller ở frame cuối
      _controller.value = 1.0;
      _isAnimationComplete = true;
    }
  }

  @override
  void didUpdateWidget(LottieItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Nếu trạng thái isBloom thay đổi hoặc shouldAnimate thay đổi, reset animation
    if (oldWidget.isBloom != widget.isBloom || 
        (!oldWidget.shouldAnimate && widget.shouldAnimate)) {
      _isAnimationComplete = false;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nếu là animation hoa nở và không cần animation, trả về một container trong suốt
    if (widget.isBloom && !widget.shouldAnimate) {
      return Container(
        width: widget.size,
        height: widget.size,
        color: Colors.transparent,
      );
    }
    
    // Trong các trường hợp khác, sử dụng controller để quản lý animation
    return Lottie.asset(
      widget.animation,
      controller: _controller,
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      repeat: false,
      frameRate: FrameRate.max,
      options: LottieOptions(
        enableMergePaths: true,
      ),
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        if (!_isAnimationComplete) {
          _controller.forward();
        } else {
          _controller.value = 1.0;
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
