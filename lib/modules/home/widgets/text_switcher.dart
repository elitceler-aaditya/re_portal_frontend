import 'package:flutter/material.dart';

class SelfContainedAnimatedTextSwitcher extends StatefulWidget {
  const SelfContainedAnimatedTextSwitcher({super.key});

  @override
  State<SelfContainedAnimatedTextSwitcher> createState() =>
      _SelfContainedAnimatedTextSwitcherState();
}

class _SelfContainedAnimatedTextSwitcherState
    extends State<SelfContainedAnimatedTextSwitcher> {
  int _currentIndex = 0;
  final List<String> _searchOptions = ['location', 'builders', 'apartments'];
  final Duration _switchDuration = const Duration(seconds: 3);
  final Duration _animationDuration = const Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(_switchDuration, () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _searchOptions.length;
        });
        _startAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _animationDuration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.5),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Text(
        _searchOptions[_currentIndex],
        key: ValueKey<String>(_searchOptions[_currentIndex]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }
}
