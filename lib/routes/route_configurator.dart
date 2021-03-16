import 'package:flutter_algorand_wallet/routes/route_handlers.dart';
import 'package:flutter_algorand_wallet/routes/routes.dart';
import 'package:flutter_algorand_wallet/ui/screens/screens.dart';

final router = FluroRouter();

class RouteConfiguration {
  static Future<void> register() async {
    // Register the routes
    router.define("/", handler: rootHandler);
    router.define(AssetTransferScreen.routeName, handler: assetTransferHandler);
  }
}
