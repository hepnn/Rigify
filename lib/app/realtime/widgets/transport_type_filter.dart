import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:rigify/app/realtime/provider/stops_provider.dart';
import 'package:rigify/app/realtime/provider/transport_service.dart';
import 'package:rigify/app/realtime/ui/transport_page.dart';

final isInitialSetupDoneProvider = StateProvider<bool>((ref) => false);

class TransportTypeFilter extends ConsumerStatefulWidget {
  const TransportTypeFilter({super.key});

  @override
  ConsumerState<TransportTypeFilter> createState() =>
      _TransportTypeFilterState();
}

class _TransportTypeFilterState extends ConsumerState<TransportTypeFilter> {
  var isListVisible = false;

  @override
  Widget build(BuildContext context) {
    final isInitialSetupDone = ref.watch(isInitialSetupDoneProvider);
    final selectedTypes = ref.watch(selectedTransportTypesProvider);
    final bool isSelected = ref.watch(stopVisibilityProvider);

    if (!isInitialSetupDone && selectedTypes.isEmpty) {
      Future.microtask(() {
        ref.read(selectedTransportTypesProvider.notifier).state = Set.from(
          TransportType.values.where((type) => type != TransportType.unknown),
        );
        ref.read(isInitialSetupDoneProvider.notifier).state = true;
      });
    }

    final typeWidgets = TransportType.values
        .where((type) => type != TransportType.unknown)
        .map((type) {
      final isSelected = selectedTypes.contains(type);
      return _SelectTransportItem(
        onTap: () {
          final currentTypes =
              ref.read(selectedTransportTypesProvider.notifier).state;
          if (isSelected) {
            currentTypes.remove(type);
          } else {
            currentTypes.add(type);
          }
          ref.read(selectedTransportTypesProvider.notifier).state = {
            ...currentTypes
          };
        },
        icon: type.icon,
        iconColor: isSelected ? type.color : Colors.grey,
        color: isSelected ? type.color.withOpacity(0.2) : Colors.white,
        isSelected: isSelected,
      );
    }).toList();

    return TapRegion(
      onTapOutside: (tap) {
        if (isListVisible) {
          setState(() {
            isListVisible = false;
          });
        }
      },
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isListVisible = !isListVisible;
              });
            },
            child: IconContainer(
              icon: isListVisible ? Icons.close : Icons.filter_list,
              iconColor: Colors.white,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            height: isListVisible ? null : 0,
            child: Visibility(
              maintainState: true, // Maintain state to keep the list state
              visible: isListVisible,
              child: Column(
                children: [
                  _SelectTransportItem(
                    onTap: () {
                      ref.read(stopVisibilityProvider.notifier).state =
                          !isSelected;
                    },
                    svgIcon: 'assets/app_assets/bus-stop.svg',
                    iconColor: isSelected ? Colors.white : Colors.grey.shade400,
                    color: Colors.blueGrey,
                    isSelected: isSelected,
                  ),
                  ...typeWidgets,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectTransportItem extends StatelessWidget {
  final IconData? icon;
  final String? svgIcon;
  final Color iconColor;
  final Color color;
  final VoidCallback onTap;
  final bool isSelected;

  const _SelectTransportItem({
    this.icon,
    this.svgIcon,
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
            child: svgIcon == null
                ? Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  )
                : SvgPicture.asset(
                    svgIcon!,
                    height: 20,
                    color: iconColor,
                  ),
          ),
        ),
      ),
    );
  }
}
