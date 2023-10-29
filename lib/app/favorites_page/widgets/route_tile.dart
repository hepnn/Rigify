// Ugly boilerplate copy of num_tile.dart for favorites page only, because of issues with gesture detectors. We have reordable listview in favorites page and if we have a gesturedetecotr on the tile, it will not work properly. So we have to copy the whole file and remove the gesture detector. This is not a good solution, but it works for now.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';

class FavoriteTile extends ConsumerStatefulWidget {
  final bool reorderEnabled;
  final RouteType _route;

  const FavoriteTile(
    this._route, {
    Key? key,
    this.reorderEnabled = false,
  }) : super(key: key);

  @override
  ConsumerState<FavoriteTile> createState() => _FavoriteTileState();
}

class _FavoriteTileState extends ConsumerState<FavoriteTile> {
  @override
  Widget build(BuildContext context) {
    List<String> separated = widget._route.number!.split(' ');
    String number;
    String date;

    if (separated.length <= 1) {
      // No space found, treat the original string as the number
      number = widget._route.number!;
      date = ''; // Empty string for date
    } else {
      number = separated[0];
      date = separated[1];
    }
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: widget.reorderEnabled
              ? Border.all(color: Colors.grey.shade600)
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: colors[widget._route.transport],
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
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget._route.name!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.reorderEnabled)
              const FaIcon(FontAwesomeIcons.arrowsUpDownLeftRight),
          ],
        ),
      ),
    );
  }
}
