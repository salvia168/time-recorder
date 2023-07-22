import 'package:flutter/material.dart';

class Blink extends StatefulWidget {
  const Blink(
      {super.key,
      required this.duration,
      required this.child,
      this.visible = true});

  final Duration duration;
  final Widget child;
  final bool visible;

  @override
  State<Blink> createState() => _BlinkState();
}

class _BlinkState extends State<Blink> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.visible ? 1.0 : 0.0,
      child: RepaintBoundary(
          child: FadeTransition(
        opacity: _animation,
        child: widget.child,
      )),
    );
  }
}
