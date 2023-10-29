import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rigify/ads/banner_ad_widget.dart';
import 'package:rigify/app/news_page/rss_feed/rss_feed.dart';
import 'package:rigify/app/news_page/twitter_feed/api/api_twitter.dart';

class TwitterEmbed extends ConsumerWidget {
  final bool adsControllerAvailable;
  final bool adsRemoved;

  const TwitterEmbed(
      {Key? key,
      required this.adsControllerAvailable,
      required this.adsRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetsAsyncValue = ref.watch(twitterProvider);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
              onRefresh: () => Future.delayed(const Duration(seconds: 1))
                  .then((value) => ref.refresh(twitterProvider.future)),
              child: tweetsAsyncValue.when(
                data: (tweets) {
                  return tweets.isEmpty
                      ? RSSFeed(
                          adsControllerAvailable: adsControllerAvailable,
                          adsRemoved: adsRemoved,
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final tweet = tweets[index];
                            late String url;
                            var currentDate = Jiffy(
                                tweet.createdAt
                                    .toString()
                                    .replaceAll('+0000', ''),
                                'EEE MMM dd hh:mm:ss  yyyy')
                              ..startOf(Units.DAY);
                            var dateparse = currentDate.fromNow().split(" ");
                            bool image = false;
                            if (tweet.entities.media.isEmpty) {
                              image = true;
                            } else {
                              image = false;
                              url = tweet.entities.media[0].mediaUrl;
                            }

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        tweet.user.profileImageUrl
                                            .replaceAll('_normal', ''),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                tweet.user.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                '@${tweet.user.screenName} · ${dateparse[0] + " " + dateparse[1]}',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(tweet.fullText),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                                child: image
                                                    ? Container()
                                                    : Image.network(
                                                        '$url?format=jpg&name=small')),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            if ((index % tweets.length ==
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
                          itemCount: tweets.length,
                        );
                },
                error: (error, stackTrace) =>
                    const Center(child: Text('Error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              )),
        ),
      ),
    );
  }
}
