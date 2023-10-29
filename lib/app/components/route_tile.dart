import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rigify/app/bus_data/route.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/recents_page/provider/recents_provider.dart';
import 'package:rigify/app/stop_page/stop_page.dart';
import 'package:rigify/main.dart';

//   List tile showing the route number, name and transport type

class RouteTile extends ConsumerStatefulWidget {
  final bool reorderEnabled;
  final RouteType _route;

  const RouteTile(
    this._route, {
    Key? key,
    this.reorderEnabled = false,
  }) : super(key: key);

  @override
  ConsumerState<RouteTile> createState() => _RouteTileState();
}

class _RouteTileState extends ConsumerState<RouteTile> {
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
    return GestureDetector(
      onTap: () {
        widget.reorderEnabled
            ? null
            : Navigator.push(context,
                MaterialPageRoute(builder: (_) => StopsPage(widget._route)));
        ref.read(recentRoutesProvider.notifier).addRoute(widget._route);
      },
      onLongPress: () =>
          widget.reorderEnabled ? null : _addFavDialog(context, widget._route),
      child: Card(
        elevation: 2,
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
      ),
    );
  }

  _addFavDialog(context, RouteType route) async {
    final lang = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 10,
          children: [
            SimpleDialogOption(
              onPressed: () async {
                favoritesBox.containsKey(route.name)
                    ? favoritesBox.delete(route.name)
                    : favoritesBox.put(route.name, route);
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                favoritesBox.containsKey(route.name)
                    ? lang.favoriteDialogRemove
                    : lang.favoriteDialogAdd,
              ),
            ),
          ],
          //backgroundColor: Colors.green,
        );
      },
    );
  }
}
