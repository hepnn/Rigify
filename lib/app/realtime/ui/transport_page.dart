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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TransportTypeFilter(),
                _SettingList(),
              ],
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
