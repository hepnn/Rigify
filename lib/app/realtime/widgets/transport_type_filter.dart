import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:rigify/app/realtime/provider/transport_service.dart';

class TransportTypeFilter extends ConsumerWidget {
  const TransportTypeFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTypes = ref.watch(selectedTransportTypesProvider);

    final typeWidgets = TransportType.values
        .where((type) => type != TransportType.unknown)
        .map((type) {
      final isSelected = selectedTypes.contains(type);
      return _SelectTransportItem(
        onTap: () {
          final currentTypes =
              ref.read(selectedTransportTypesProvider.state).state;
          if (isSelected) {
            currentTypes.remove(type);
          } else {
            currentTypes.add(type);
          }
          ref.read(selectedTransportTypesProvider.state).state = {
            ...currentTypes
          };
        },
        icon: Icons.directions_bus,
        iconColor: isSelected ? type.color : Colors.grey,
        color: isSelected ? type.color.withOpacity(0.2) : Colors.white,
        isSelected: isSelected,
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: typeWidgets,
    );
  }
}

class _SelectTransportItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color color;
  final VoidCallback onTap;
  final bool isSelected;

  const _SelectTransportItem({
    required this.icon,
    required this.onTap,
    required this.iconColor,
    required this.color,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? color : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
