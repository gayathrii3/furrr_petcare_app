import 'package:flutter/material.dart';

class HeartbeatIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const HeartbeatIcon({super.key, required this.icon, required this.color, required this.size});

  @override
  State<HeartbeatIcon> createState() => _HeartbeatIconState();
}

class _HeartbeatIconState extends State<HeartbeatIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(widget.icon, color: widget.color, size: widget.size),
    );
  }
}

class FloatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const FloatingIcon({super.key, required this.icon, required this.color, required this.size});

  @override
  State<FloatingIcon> createState() => _FloatingIconState();
}

class _FloatingIconState extends State<FloatingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _floatAnimation = Tween<Offset>(begin: const Offset(0, -0.15), end: const Offset(0, 0.15))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _floatAnimation,
      child: Icon(widget.icon, color: widget.color, size: widget.size),
    );
  }
}

class SwayingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const SwayingIcon({super.key, required this.icon, required this.color, required this.size});

  @override
  State<SwayingIcon> createState() => _SwayingIconState();
}

class _SwayingIconState extends State<SwayingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _rotateAnimation = Tween<double>(begin: -0.12, end: 0.12)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
        return Transform.rotate(
          angle: _rotateAnimation.value,
          child: child,
        );
      },
      child: Icon(widget.icon, color: widget.color, size: widget.size),
    );
  }
}
