import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_item.freezed.dart';

@freezed
abstract class FeedItem with _$FeedItem {
  const factory FeedItem({
    required String guid,
    required String pubDate,
    required String title,
    required String link,
  }) = _FeedItem;
}
