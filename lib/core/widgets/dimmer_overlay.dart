
import 'package:flutter/material.dart';

class DimmerOverlay extends StatelessWidget {
  // to close the overlay when tapped
  final VoidCallback? onTap;

  final double opacity;

  const DimmerOverlay({
    super.key,
    this.onTap,
    this.opacity = 0.6,
  });

  @override
  Widget build(BuildContext context) {
// to handle tap events
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(opacity),
        child: const Center(
            
            ),
      ),
    );
  }
}
