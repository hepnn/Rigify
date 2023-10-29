import 'package:http/http.dart' as http;
import 'package:rigify/app/news_page/rss_feed/model/feed_item.dart';
import 'package:xml/xml.dart';

Future<List<FeedItem>> fetchFeedItems() async {
  final response = await http.get(Uri.parse(
      'https://rsseverything.com/feed/e44756ac-c187-4a41-bec5-16359e511d0b.xml'));
  final document = XmlDocument.parse(response.body);

  return document.findAllElements('item').map((node) {
    return FeedItem(
      guid: node.findElements('guid').single.text,
      pubDate: node.findElements('pubDate').single.text,
      title: node.findElements('title').single.text,
      link: node.findElements('link').single.text,
    );
  }).toList();
}
