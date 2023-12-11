import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/app/realtime/provider/transport_service.dart';
import 'package:rigify/app/realtime/ui/transport_map.dart';
import 'package:rigify/app/realtime/widgets/transport_info_sheet.dart';
import 'package:rigify/app/realtime/widgets/transport_type_filter.dart';

class TransportPage extends ConsumerStatefulWidget {
  const TransportPage({super.key});

  @override
  ConsumerState<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends ConsumerState<TransportPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transportsAsync = ref.watch(transportsStreamProvider);
    final selectedTransport = ref.watch(selectedTransportProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            transportsAsync.when(
              data: (transports) {
                return TransportMap(
                  transports: transports,
                );
              },
              error: (error, stackTrace) => Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TransportTypeFilter(),
                  const Spacer(),
                  _IconContainer(
                    icon: Icons.search_rounded,
                    iconColor: Colors.grey.shade500,
                    color: Colors.white,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Search for bus number or bus ID',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(searchTransportProvider.notifier)
                                        .update((_) => _searchController.text);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Search'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // const _SettingList(),
                ],
              ),
            ),
            if (selectedTransport != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: TransportInfoSheet(
                  transport: selectedTransport,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _SettingList extends StatelessWidget {
  const _SettingList();

  @override
  Widget build(BuildContext context) {
    return _IconContainer(
      icon: Icons.settings_rounded,
      iconColor: Colors.grey.shade500,
      color: Colors.white,
      onTap: () {},
    );
  }
}

class _IconContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color color;
  final VoidCallback onTap;

  const _IconContainer({
    required this.icon,
    required this.iconColor,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            color: null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
