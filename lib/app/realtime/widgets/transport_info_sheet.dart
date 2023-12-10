import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    var modalHeight = 100.0;
    const minHeight = 100.0;
    const maxHeight = 500.0;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          modalHeight = (modalHeight - details.delta.dy)
              .clamp(minHeight, maxHeight)
              .toDouble();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: modalHeight,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.transport.vehicleId,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                // Add more information about the transport here
              ],
            ),
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
