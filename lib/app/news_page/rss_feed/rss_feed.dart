import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rigify/ads/banner_ad_widget.dart';
import 'package:rigify/app/news_page/rss_feed/api/feed_fetch.dart';
import 'package:rigify/app/news_page/rss_feed/model/feed_item.dart';
import 'package:rigify/locale/locale_providers.dart';
import 'package:url_launcher/url_launcher.dart';

final feedItemsProvider = FutureProvider<List<FeedItem>>(
  (ref) => fetchItems(
    ref.watch(localeProvider),
  ),
);

class RSSFeed extends ConsumerWidget {
  final bool adsRemoved;
  final bool adsControllerAvailable;
  const RSSFeed({
    super.key,
    required this.adsRemoved,
    required this.adsControllerAvailable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedItemsAsyncValue = ref.watch(feedItemsProvider);

    return Scaffold(
      body: feedItemsAsyncValue.when(
        data: (feedItems) {
          return ListView.separated(
            itemCount: feedItems.length,
            itemBuilder: (context, index) {
              final feedItem = feedItems[index];

              String date = feedItem.pubDate;
              String formattedDate = '';

              try {
                formattedDate =
                    Jiffy(date, 'dd. MMM. yyyy').format('dd MMM yyyy');
              } catch (e) {
                formattedDate = '';
              }

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(feedItem.link))) {
                    await canLaunchUrl(Uri.parse(feedItem.link));
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            'https://i1.ifrype.com/business/343/391/v1499339085/ll_13343391.jpg',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feedItem.title,
                                softWrap: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: FaIcon(
                            FontAwesomeIcons.upRightFromSquare,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              final showAd = (index % feedItems.length ==
                      0) && // README: To abide by family program policy, there can only be 1 ad per page.
                  adsControllerAvailable &&
                  !adsRemoved;

              if (showAd) {
                return const SizedBox(
                  height: 50,
                  child: BannerAdWidget(),
                );
              } else {
                return const SizedBox(
                  height: 5,
                );
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
