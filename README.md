# Rigify - Public Transit Routes and Timetables

GTFS data fetching and converting it into a user friendly UI. Built using Flutter Framework

[<img src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png"
      alt="Get it on Google Play"
      height="80">](https://play.google.com/store/apps/details?id=com.yamawagi.rigify)
      

## About

Developed in motion of not being able to find a good looking and not full of Ads public transit timetable app and deciding to build one on my own.

* This project uses AdMob for showing Banner Ads (Currently only Banner ads are implemented) and scrapes rigassatiksme.lv for their news feed.

- Main data is gotten from a GTFS feed found here [routes](https://saraksti.rigassatiksme.lv/riga/routes.txt) and [stops](https://openmobilitydata-data.s3-us-west-1.amazonaws.com/public/feeds/rigas-satiksme/333/20221105/original/stops.txt).
- In App Purchases to remove ads are also implemented.
- Realtime map data is fetched from [here](https://saraksti.rigassatiksme.lv/gps.txt).

While this app is developed for a specific data feed, it can be easily modified and replaced with different GTFS data.

Part project is old and part new, so the codebase can be messy

## Features

- Light / dark / system theme switch
- l10n / localization -  [flutter_localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- In App Purchases - [in_app_purchase](https://pub.dev/packages/in_app_purchase)
- Search bar
- Favorites - [hive](https://pub.dev/packages/hive)
- Firebase Analytics & Crashlytics
- Riverpod
- Maps
- Logging
- Splash screen

      
## Screenshots

<img align="center" width="250" height="500" src="https://i.imgur.com/5aS7xeA.png">
<img align="center" width="250" height="500" src="https://i.imgur.com/pi2pnwc.png">
<img align="center" width="250" height="500" src="https://i.imgur.com/Qzda7KO.png">
<details>
<summary>Click for more</summary>
<img align="center" width="250" height="500" src="https://i.imgur.com/ecrtHUf.png">
<img align="center" width="250" height="500" src="https://i.imgur.com/QVgl376.png">
<img align="center" width="250" height="500" src="https://i.imgur.com/2FN3ece.png">
</details>

## Setup
- In App Purchases
    - An upload to play store is first required in order to properly display legitimate Ads, afterwards change the <b>productId</b> value in `lib\IAP\ad_removal_state.gen.dart` to your own ID.
- Setup your own API keys, references below.
- You will have to run `flutter gen-l10n` to generate l10n

## Env values

Env values are stored in <b>keys.dart</b> file. 

To enable AdMob, add:

`Ad unit ID for Android`

`Ad unit ID for IOS` 

To enable mapbox maps, add:

`Mapbox public token`

To enable fetching from Twitter, add:

`Consumer key`

`Consumer secret`

`Token`

`Secret`
## Roadmap

- More language support

- Use Fimber, add Env vars, Refactor all to Clean arch

- Ticket reader using nfc from [here](https://github.com/hepnn/E-talons) 

