import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static Future<void> register() async {}
}

/// TODO Normally use Dependency Injection for this
/// We can use GetIt or Provider
final algorand = Algorand(
  algodClient: AlgodClient(
    apiUrl: PureStake.TESTNET_ALGOD_API_URL,
    apiKey: 'YOUR API KEY',
    tokenKey: PureStake.API_TOKEN_HEADER,
  ),
  indexerClient: IndexerClient(
    apiUrl: PureStake.TESTNET_INDEXER_API_URL,
    apiKey: 'YOUR API KEY',
    tokenKey: PureStake.API_TOKEN_HEADER,
  ),
);

final accountRepository = AccountRepository();
