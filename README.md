# Flutter Algorand Wallet

This solution will guide you in developing and deploying a cross-platform wallet application using the Algorand blockchain features that addresses the following use case:

> Building a cross-platform Algorand wallet that can export to mobile, web and desktop with Dart & Flutter

The solution architecture relies on the recently released community SDK, [algorand-dart](https://pub.dev/packages/algorand_dart), [Bloc](https://bloclibrary.dev/#/), a predictable state management library and [Hive](https://docs.hivedb.dev), a lightweight and blazing fast key-value database written in pure Dart. This solution focuses on developers who want to build cross-platform applications with a write once, run anywhere approach. The sample app shows some example code on how to create and build a cross-platform Flutter application and connect it to the Algorand blockchain with the algorand-dart SDK and is currently a work in progress.

![Algorand wallet](https://i.imgur.com/OMuNmBd.png)

## Requirements
1. Android Studio (or another Flutter-supported IDE)
2. Flutter 2.0 (>=) - stable channel
3. (Optional) A [PureStake](../../tutorials/getting-started-purestake-api-service/) Account and the corresponding API key OR a [locally hosted node](https://developer.algorand.org/docs/run-a-node/setup/install/)

## Setting up our development environment

If it’s your first time working with Flutter, I recommend you to go through the [Getting Started](https://flutter.dev/docs/get-started/install) section of the Flutter documentation to learn more about the different features and installation methods Flutter has to offer.

Ensure you have the latest stable channel of the Flutter SDK (>= 2.0), Dart 2.12.1 (>=) and the latest version of the [algorand-dart SDK](https://pub.dev/packages/algorand_dart).

Once installed, make sure to enable [web](https://flutter.dev/docs/get-started/web) and [desktop](https://flutter.dev/desktop) support if you wish to export to those modules.

Go to the [sample app's github](https://github.com/RootSoft/flutter-algorand-wallet) and download/clone the repository.
Open Android Studio, select **Open an Existing project** and navigate to the cloned project.

Run the following commands to use the latest version of the Flutter SDK:
```bash
flutter channel stable
flutter pub get
```

If Chrome is installed, the ```flutter devices``` command outputs a Chrome device that opens the Chrome browser with your app running, and a **Web Server** that provides the URL serving the app.

Open up ```service_locator.dart``` and inspect how the Algorand client is set up.

When everything is set up, select your target platform and click run!
![](https://i.imgur.com/mNaZkww.png)


**Troubleshoot**

First of all, run ```flutter doctor``` to check which tools are installed on the local machine and which tools need to be configured. Make sure all of them are checked and enabled.

![Flutter Doctor](https://i.imgur.com/zHs9lcr.png)

If you have some issues running the sample project, make sure Flutter is enabled and active:

1. Open plugin preferences (File > Settings > Plugins).
2. Select Marketplace, select the Flutter plugin and click Install.
3. Restart the IDE

After restarting and indexing the IDE, open ```main.dart``` and run ```flutter pub get``` to fetch the dependencies.
Then the option to run ```main.dart``` should be available and the different export options to emulator, Edge or chrome should be visible.

You don’t need to change the run/debug configurations - the Flutter plugin takes care of that.

Also make sure the flutter SDK path is correctly filled in:
1. Open Language & Framework preferences (File > Settings > Languages & Frameworks).
2. Open Flutter and enter the Flutter SDK Path.
