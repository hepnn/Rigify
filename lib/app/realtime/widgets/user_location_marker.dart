import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationIndicator extends StatefulWidget {
  final LatLng location;
  final double radius;

  const LocationIndicator({
    Key? key,
    required this.location,
    this.radius = 20.0,
  }) : super(key: key);

  @override
  _LocationIndicatorState createState() => _LocationIndicatorState();
}

class _LocationIndicatorState extends State<LocationIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withOpacity(0.3),
          ),
          child: Center(
            child: Container(
              width: widget.radius - _animation.value,
              height: widget.radius - _animation.value,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
        );
      },
    );
  }
}
