import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rigify/app/news_page/rss_feed/model/feed_item.dart';
import 'package:xml/xml.dart';

const String latvianRSS =
    'https://rsseverything.com/feed/46c839b6-6b7a-4679-89dc-a853ee3215fe.xml';

const String englishRSS =
    'https://rsseverything.com/feed/e33a4023-bde8-46a2-b688-ffe9d92fc67b.xml';

Future<List<FeedItem>> fetchFeedItems(Locale locale) async {
  String rssUrl = locale.languageCode == 'lv' ? latvianRSS : englishRSS;

  final response = await http.get(
    Uri.parse(rssUrl),
  );

  final document = XmlDocument.parse(response.body);

  return document.findAllElements('item').map((node) {
    final pubDate = node.findElements('description').single.innerText;
    final dateMatch = RegExp(r'\d+\.\s\w+\.\s\d+').firstMatch(pubDate);
    final date = dateMatch?.group(0) ?? '';

    return FeedItem(
      guid: node.findElements('guid').single.innerText,
      pubDate: date,
      title: node.findElements('title').single.innerText,
      link: node.findElements('link').single.innerText,
    );
  }).toList();
}
