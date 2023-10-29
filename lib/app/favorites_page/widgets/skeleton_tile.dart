import 'package:flutter/material.dart';
import 'package:rigify/app/components/shimmer_skeleton_card.dart';

class NumTileSkeleton extends StatelessWidget {
  const NumTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Skeleton(
            width: 60,
            height: 60,
          ),
          SizedBox(width: 12),
          Flexible(
            child: Skeleton(
              height: 15,
              width: 150,
            ),
          ),
        ]),
      ),
    );
  }
}
