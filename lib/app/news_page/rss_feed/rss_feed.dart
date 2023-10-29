import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rigify/ads/banner_ad_widget.dart';
import 'package:rigify/app/news_page/rss_feed/api/feed_fetch.dart';
import 'package:rigify/app/news_page/rss_feed/model/feed_item.dart';
import 'package:url_launcher/url_launcher.dart';

final feedItemsProvider =
    FutureProvider<List<FeedItem>>((ref) => fetchFeedItems());

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

              RegExp regex = RegExp(r'(\d{2})\s(\w{3})\s\d{4}');
              RegExpMatch? match = regex.firstMatch(date);
              if (match != null) {
                String? day = match.group(1);
                String? month = match.group(2);

                DateTime dateTime =
                    Jiffy('$day $month 2023', 'dd MMM yyyy').dateTime;
                String formattedDate = Jiffy(dateTime).format('dd MMM');

                date = formattedDate;
                print(formattedDate); // Output: 07 Jul
              }

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  if (await canLaunch(feedItem.link)) {
                    await launch(feedItem.link);
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
                              // Text(
                              //   date,
                              //   style: const TextStyle(color: Colors.grey),
                              // )
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
              if ((index % feedItems.length ==
                      0) && // README: To abide by family program policy, there can only be 1 ad per page.
                  adsControllerAvailable &&
                  !adsRemoved) {
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
