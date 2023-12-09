import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/app/realtime/provider/transport_service.dart';
import 'package:rigify/app/realtime/ui/transport_map.dart';
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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            transportsAsync.when(
              data: (transports) {
                return TransportMap(transports: transports);
              },
              error: (error, stackTrace) => Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    error.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            Column(
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () {},
                        heroTag: null,
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TransportTypeFilter(),
                _SettingList(),
              ],
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
  const _SettingList({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      iconColor: Colors.grey[700],
      iconSize: 32,
      icon: const Icon(Icons.settings_rounded),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            child: Text('Settings'),
          ),
          const PopupMenuItem(
            child: Text('About'),
          ),
        ];
      },
    );
  }
}
