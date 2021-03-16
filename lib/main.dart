import 'package:flutter/material.dart';
import 'package:flutter_algorand_wallet/database/entities.dart';
import 'package:flutter_algorand_wallet/database/entities/account_entity.dart';
import 'package:flutter_algorand_wallet/routes/routes.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';

void main() async {
  // Initialize hive
  await Hive.initFlutter();
  Hive.registerAdapter(AlgorandStandardAssetAdapter());
  Hive.registerAdapter(AccountAdapter());

  await Hive.openBox<AccountEntity>('accounts');
  await Hive.openBox<AlgorandStandardAssetEntity>('assets');

  // Register the service locator and dependencies
  await ServiceLocator.register();

  // Register the account repository
  await accountRepository.init();

  // Register the routing
  await RouteConfiguration.register();

  final routeName = '/'; //MainScreen.routeName;

  // Run the app
  runApp(AlgorandWallet(initialRoute: routeName));
}

class AlgorandWallet extends StatelessWidget {
  final String initialRoute;

  AlgorandWallet({
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algorand Wallet',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: initialRoute,
      onGenerateRoute: router.generator,
    );
  }
}
