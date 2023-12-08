import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rigify/app/news_page/rss_feed/model/feed_item.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart' as dom;

const String latvianRSS =
    'https://www.rigassatiksme.lv/lv/aktu%C4%81la%20inform%C4%81cija/';

const String englishRSS =
    'https://www.rigassatiksme.lv/en/current%20information/';

Future<List<FeedItem>> fetchItems(Locale locale) async {
  String rssUrl = locale.languageCode == 'lv' ? latvianRSS : englishRSS;
  final response = await http.get(Uri.parse(rssUrl));

  if (response.statusCode == 200) {
    var document = htmlParser.parse(response.body);
    List<dom.Element> itemElements = document.querySelectorAll('li.item');
    List<FeedItem> items = [];

    for (var element in itemElements) {
      String description =
          element.querySelector('span.description')?.text ?? '';

      String dateString = element.querySelector('span.date')?.text.trim() ?? '';
      String link = element.querySelector('a')?.attributes['href'] ?? '';
      String title = element.querySelector('a')?.text ?? '';

      items.add(
        FeedItem(
          title: title,
          link: link,
          content: description,
          pubDate: dateString,
        ),
      );
    }

    if (items.isNotEmpty) {
      items.removeAt(0); // First item is invalid (mismatch or something)
    }

    return items;
  } else {
    throw Exception('Failed to load content');
  }
}
