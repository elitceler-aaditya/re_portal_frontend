import 'package:flutter/material.dart';

class SelfContainedAnimatedTextSwitcher extends StatefulWidget {
  const SelfContainedAnimatedTextSwitcher({super.key});

  @override
  State<SelfContainedAnimatedTextSwitcher> createState() =>
      _SelfContainedAnimatedTextSwitcherState();
}

class _SelfContainedAnimatedTextSwitcherState
    extends State<SelfContainedAnimatedTextSwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentIndex = 0;

  final List<String> _searchOptions = ['location', 'builders', 'apartments'];
  final Duration _switchDuration = const Duration(seconds: 3);
  final Duration _animationDuration = const Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward(from: 0.0).then((_) {
      Future.delayed(_switchDuration - _animationDuration, () {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _searchOptions.length;
          });
          _controller.reverse(from: 1.0).then((_) => _startAnimation());
        }
      });
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
      animation: _animation,
      builder: (context, child) {
        return ClipRect(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20 * (1 - _animation.value)),
              Opacity(
                opacity: _animation.value,
                child: Text(
                  "Search for ${_searchOptions[_currentIndex]}",
                  key: ValueKey<String>(_searchOptions[_currentIndex]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors
                        .black54, // Assuming this is similar to your CustomColors.black50
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
