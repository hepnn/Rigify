import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rigify/app/bus_data/data_api.dart';
import 'package:rigify/app/bus_data/stop.dart';
import 'package:rigify/app/bus_data/utils/utils.dart';
import 'package:rigify/app/route_page/widgets/route_list.dart';

HomePageTwoState? homepageState;

class HomePageTwo extends StatefulWidget {
  const HomePageTwo(this.choice, {Key? key}) : super(key: key);

  final String choice;

  @override
  HomePageTwoState createState() => HomePageTwoState();
}

class HomePageTwoState extends State<HomePageTwo> {
  bool update = false;
  bool searching = false;

  final TextEditingController searchController = TextEditingController();
  List<Stop> searchResults = [];

  void rebuild() {
    setState(() => update = !update);
  }

  Widget showRoutes(String? choice) {
    homepageState = this;
    return stops.keys.isEmpty
        ? FutureBuilder<FetchResponse>(
            future: fetchData(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return BrackPage(
                  snapshot.data,
                  choice: widget.choice,
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        : BrackPage(
            FetchResponse(true),
            choice: choice,
          );
  }

  @override
  Widget build(BuildContext context) {
    final String name = transportNames[widget.choice]!;
    final lang = AppLocalizations.of(context)!;

    String getLocalizedString(String key, context) {
      // Weird implementation of localization, but it works lol
      switch (key) {
        case 'Autobuss':
          return lang.bus;
        case 'Tramvajs':
          return lang.tramway;
        case 'Trolejbuss':
          return lang.trolleybus;
      }
      return key;
    }

    List<String?> getTransportNames() {
      final List<String?> names = [];
      for (var t in transportNames.values) {
        names.add(getLocalizedString(t, context));
      }
      return names;
    }

    String localizedString = getLocalizedString(name, context);

    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              getTransportNames().contains(localizedString)
                  ? Text(localizedString)
                  : Text(name),
            ],
          ),
        ),
        body: showRoutes(widget.choice),
      ),
    );
  }
}

class BrackPage extends StatelessWidget {
  const BrackPage(this._response, {Key? key, this.choice}) : super(key: key);
  final FetchResponse? _response;
  final String? choice;

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    final FetchResponse response = _response!;

    if (response.success) {
      return NumList(choice);
    }

    Container createLine(String str) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(str),
        );

    final List<Widget?> errorLines = [
      createLine('ERROR'),
      (response.error ?? '').isNotEmpty ? createLine(response.error!) : null,
      ElevatedButton(
        child: Text(lang.routesPageErrorTitle),
        onPressed: () => homepageState?.rebuild(),
      ),
    ]..removeWhere(
        (widget) => widget == null,
      );

    return Center(
      child: IntrinsicHeight(
        child: Column(children: errorLines as List<Widget>),
      ),
    );
  }
}
