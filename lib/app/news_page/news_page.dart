import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rigify/app/news_page/twitter_feed/twitter_feed.dart';
import 'package:rigify/main.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GlobalKey menuKey = GlobalKey();

    final adsControllerAvailable = (adsControllerProvider) != null;

    final adsRemoved = inAppPurchaseControllerProvider != null
        ? ref.watch(inAppPurchaseControllerProvider!).maybeMap(
              active: (value) => true,
              orElse: () => false,
            )
        : false;

    final lang = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${lang?.newsTitle}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              key: menuKey,
              icon: const FaIcon(FontAwesomeIcons.plus),
              onPressed: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    const PopupMenuItem(
                      value: 'twitter',
                      child: Row(children: [
                        FaIcon(FontAwesomeIcons.twitter),
                        SizedBox(width: 8),
                        Text('@Rigassatiksme_'),
                      ]),
                    ),
                    const PopupMenuItem(
                      value: 'rigassatiksme',
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                              'https://i1.ifrype.com/business/343/391/v1499339085/ll_13343391.jpg',
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('rigassatiksme.lv'),
                        ],
                      ),
                    ),
                  ],
                  elevation: 8,
                ).then((value) {
                  if (value != null) {
                    // Handle the selected value here
                    if (value == 'twitter') {
                      launchUrl(Uri.parse(
                        'https://twitter.com/Rigassatiksme_',
                      ));
                    } else if (value == 'rigassatiksme') {
                      launchUrl(Uri.parse(
                        'https://www.rigassatiksme.lv/lv/aktualitates/',
                      ));
                    }
                  }
                });
              },
            ),
          ),
          const SizedBox.shrink(), // For positioning the title text on the left
        ],
      ),
      body: TwitterEmbed(
        adsControllerAvailable: adsControllerAvailable,
        adsRemoved: adsRemoved,
      ),
    );
  }
}
