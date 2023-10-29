import 'dart:io';

// import 'package:dart_twitter_api/twitter_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rigify/app/news_page/twitter_feed/model/twitter_response_model.dart';

class ApiConstants {
  static String baseUrl = 'api.twitter.com';
  static String timelineEndPoint = '1.1/statuses/user_timeline.json';
}

final twitterProvider =
    FutureProvider.autoDispose<List<TwitterResponseModel>>((ref) async {
  return ref.watch(apiTwitterProvider).getTwitterTimeline();
});

final apiTwitterProvider = Provider<ApiTwitter>((ref) {
  return ApiTwitter();
});

class ApiTwitter {
  // final twitterOauth = TwitterApi(
  //   client: TwitterClient(
  //     consumerKey: TwitterAPIKeys.consumerKey,
  //     consumerSecret: TwitterAPIKeys.consumerSecret,
  //     token: TwitterAPIKeys.token,
  //     secret: TwitterAPIKeys.secret,
  //   ),
  // );

  Future<List<TwitterResponseModel>> getTwitterTimeline() async {
    try {
      // Future twitterRequest = twitterOauth.client.get(
      //   Uri.https(ApiConstants.baseUrl, ApiConstants.timelineEndPoint, {
      //     'count': '30',
      //     'user_id': '368753015',
      //     'exclude_replies': 'true',
      //     'tweet_mode': 'extended',
      //   }),
      // );

      // var res = await twitterRequest;

      // var tweets = json
      //     .decode(res.body)
      //     .map<TwitterResponseModel>(
      //         (tweet) => TwitterResponseModel.fromJson(tweet))
      //     .toList();
      // return tweets;
    } on SocketException catch (e) {
      print('SocketException: $e');
    } on HttpException catch (e) {
      print('HttpException: $e');
    } on FormatException catch (e) {
      print('FormatException: $e');
    } catch (e) {
      print('Exception: $e');
    }
    return [];
  }
}
