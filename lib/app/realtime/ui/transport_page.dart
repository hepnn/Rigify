import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:rigify/app/realtime/provider/search_provider.dart';
import 'package:rigify/app/realtime/provider/transport_service.dart';
import 'package:rigify/app/realtime/ui/transport_map.dart';
import 'package:rigify/app/realtime/widgets/transport_info_sheet.dart';
import 'package:rigify/app/realtime/widgets/transport_type_filter.dart';

class TransportPage extends ConsumerStatefulWidget {
  final bool mapEnabled;

  const TransportPage({
    super.key,
    required this.mapEnabled,
  });

  @override
  ConsumerState<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends ConsumerState<TransportPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    final transportsAsync = ref.watch(transportsStreamProvider);
    final selectedTransport = ref.watch(selectedTransportProvider);

    TransportType dropdownvalue = TransportType.unknown;

    final List<DropdownMenuItem<TransportType>> list = [
      DropdownMenuItem(
        value: TransportType.bus,
        child: Text(lang.bus),
      ),
      DropdownMenuItem(
        value: TransportType.tram,
        child: Text(lang.tramway),
      ),
      DropdownMenuItem(
        value: TransportType.trolley,
        child: Text(lang.trolleybus),
      ),
      DropdownMenuItem(
        value: TransportType.unknown,
        child: Text(lang.all),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          transportsAsync.when(
            data: (transports) {
              return widget.mapEnabled
                  ? TransportMap(
                      transports: transports,
                    )
                  : const _MapDisabledState();
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
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
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          hintText:
                                              lang.realtimeMapSearchPlaceholder,
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Flexible(
                                      flex: 1,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        value: dropdownvalue,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(14),
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                        ),
                                        items: list,
                                        onChanged: (value) {
                                          setState(() {
                                            dropdownvalue =
                                                value as TransportType;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    final searchText =
                                        _searchController.text.trim();
                                    final searchType = dropdownvalue;

                                    final searchCriteria = SearchCriteria(
                                      searchText: searchText,
                                      transportType: searchType,
                                    );

                                    ref
                                        .read(searchTransportProvider.notifier)
                                        .update((_) => searchCriteria);
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

class _MapDisabledState extends StatelessWidget {
  const _MapDisabledState({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.map,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              lang.map_disabled,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
