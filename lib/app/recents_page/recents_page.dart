import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rigify/app/components/route_tile.dart';
import 'package:rigify/app/recents_page/provider/recents_provider.dart';

class RecentRoutesScreen extends ConsumerWidget {
  const RecentRoutesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentRoutes = ref.watch(recentRoutesProvider);
    final lang = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Text(lang.recentPageTitle),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: recentRoutes.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.map_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: Text(
                    lang.recentPageInfo,
                    style: const TextStyle(
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              )
            : Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: recentRoutes
                          .map((route) => RouteTile(route))
                          .toList(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
