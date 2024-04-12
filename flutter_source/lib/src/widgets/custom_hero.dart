import 'package:flutter/material.dart';

/// Кастомный [CustomHero], в котором прописан собственный путь полета,
class CustomHero extends Hero {
  const CustomHero({
    super.key,
    required super.tag,
    required super.child,
  }) : super(createRectTween: _createRectTween);

  static Tween<Rect?> _createRectTween(Rect? begin, Rect? end) {
    return _CustomRectTween(begin: begin, end: end);
  }
}

class _CustomRectTween extends RectTween {
  _CustomRectTween({super.begin, super.end});

  @override
  Rect? lerp(double t) {
    return Rect.lerp(begin, end, t);
  }
}
