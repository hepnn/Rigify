import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rigify/app/setting_page/widgets/language_picker.dart';
import 'package:rigify/app/setting_page/widgets/theme_card.dart';
import 'package:rigify/main.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final InAppReview inAppReview = InAppReview.instance;

    Future<void> _openStoreListing() => inAppReview.openStoreListing();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(lang.settingsTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const _LanguageSelectionRow(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                lang.themeModeTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const ThemeCard(),
            const _ContactDevRow(),
            const _RemoveAdsRow(),
            _RateMyApp(
              onSelected: _openStoreListing,
            ),
          ],
        ),
      ),
    );
  }
}

class _RateMyApp extends StatelessWidget {
  final VoidCallback onSelected;

  const _RateMyApp({
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onSelected,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(lang.rate_my_app),
                  const Spacer(),
                  const Icon(
                    Icons.exit_to_app,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelectionRow extends StatelessWidget {
  const _LanguageSelectionRow();

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _SettingsLine(
              lang.settingsLang,
              child: const LanguageSelector(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactDevRow extends StatelessWidget {
  const _ContactDevRow();

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _SettingsLine(
              lang.supportTitle,
              child: SizedBox(
                height: 50,
                width: 200,
                child: Card(
                  elevation: 2,
                  child: Center(
                    child: TextButton(
                      child: const Text(
                        'martinssvdev@gmail.com',
                      ),
                      onPressed: () {
                        _composeMail();
                      },
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

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _composeMail() {
// #docregion encode-query-parameters
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'martinssvdev@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': '[Rigify] Feedback',
      }),
    );

    launchUrl(emailLaunchUri);
// #enddocregion encode-query-parameters
  }
}

class _RemoveAdsRow extends ConsumerWidget {
  const _RemoveAdsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = AppLocalizations.of(context)!;

    if (inAppPurchaseControllerProvider == null) {
      return const SizedBox.shrink();
    }

    Widget icon;
    VoidCallback? callback;

    if (inAppPurchaseControllerProvider != null
        ? ref.watch(inAppPurchaseControllerProvider!).maybeMap(
              active: (value) => true,
              orElse: () => false,
            )
        : false) {
      icon = const Text('❤️');
    } else if (inAppPurchaseControllerProvider != null
        ? ref.watch(inAppPurchaseControllerProvider!).maybeMap(
              pending: (value) => true,
              orElse: () => false,
            )
        : false) {
      icon = const CircularProgressIndicator();
    } else {
      icon = const Text(
        '1.79€',
        style: TextStyle(fontWeight: FontWeight.bold),
      );
      callback = () {
        if (inAppPurchaseControllerProvider != null) {
          ref.read(inAppPurchaseControllerProvider!.notifier).buy();
        }
      };
    }
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _SettingsLine(
              lang.removeAdsTitle,
              onSelected: callback,
              child: SizedBox(
                height: 50,
                width: 100,
                child: Card(
                  elevation: 2,
                  child: Center(child: icon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget child;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, {this.onSelected, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Permanent Marker',
              fontSize: 14,
            ),
          ),
          const Spacer(),
          InkResponse(onTap: onSelected, child: child),
        ],
      ),
    );
  }
}
