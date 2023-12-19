import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/realtime/model/transport_model.dart';
import 'package:rigify/app/realtime/ui/transport_map.dart';

class TransportInfoSheet extends ConsumerStatefulWidget {
  final Transport transport;

  const TransportInfoSheet({
    super.key,
    required this.transport,
  });

  @override
  ConsumerState<TransportInfoSheet> createState() => _TransportInfoSheetState();
}

class _TransportInfoSheetState extends ConsumerState<TransportInfoSheet> {
  @override
  Widget build(BuildContext context) {
    final route = routes.entries
        .firstWhere(
          (element) =>
              element.value.number == widget.transport.number.toString() &&
              element.value.transport == widget.transport.type.jsonName,
          orElse: () => MapEntry('', RouteType.empty()),
        )
        .value;

    List<String> separated = route.number!.split(' ');
    String number;
    String date;

    if (separated.length <= 1) {
      // No space found, treat the original string as the number
      number = route.number!;
      date = ''; // Empty string for date
    } else {
      number = separated[0];
      date = separated[1];
    }
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: widget.transport.type.color,
                    elevation: 4,
                    child: Center(
                      child: ClipRRect(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: number,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: ' $date',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  route.name ?? ' ',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: widget.transport.vehicleId),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        widget.transport.vehicleId,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.copy,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                ref.read(selectedTransportProvider.notifier).state = null;
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.close,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
