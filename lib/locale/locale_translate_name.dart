import 'dart:ui';

String translateLocaleName({required Locale locale}) {
  switch (locale.toLanguageTag()) {
    case ("en-US"):
      {
        return "English";
      }
    case ("lv-LV"):
      {
        return "Latviešu";
      }
    default:
      {
        return "N/A";
      }
  }
}
