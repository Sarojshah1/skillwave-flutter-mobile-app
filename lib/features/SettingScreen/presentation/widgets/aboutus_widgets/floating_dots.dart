import 'package:flutter/material.dart';

class FloatingDot extends StatefulWidget {
  final Color color;
  final double size;
  final double verticalMovement;
  final Duration duration;
  final Duration delay;

  const FloatingDot({
    required this.color,
    required this.size,
    required this.verticalMovement,
    required this.duration,
    required this.delay,
    super.key,
  });

  @override
  State<FloatingDot> createState() => _FloatingDotState();
}

class _FloatingDotState extends State<FloatingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -widget.verticalMovement), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -widget.verticalMovement, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 0.8), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.3), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _animation.value),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
