import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/database/entities/account_entity.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:rxdart/rxdart.dart';

class AccountRepository {
  final Box<AccountEntity> accountBox;

  final BehaviorSubject<Account> _accountSubject =
      new BehaviorSubject<Account>();

  AccountRepository() : accountBox = Hive.box<AccountEntity>('accounts');

  /// Listen for account changes
  Stream<Account> get accountStateChanges => _accountSubject.stream;

  /// Get the current active account.
  Account? get account => _accountSubject.value;

  /// Init the account repo and load the wallets
  Future<void> init() async {
    final account = await accountBox.get(0)?.unwrap();
    if (account == null) return;

    _accountSubject.add(account);
  }

  /// Create a new account.
  ///
  /// Throws [AlgorandException] if unable to create the account
  Future<Account> createAccount() async {
    final account = await algorand.createAccount();

    // Store the account in our local DB.
    // NOTE! Storing your private key like this is insecure!
    // Make sure to encrypt
    final privateKey = await account.keyPair.extractPrivateKeyBytes();
    final entity =
        AccountEntity.account(account, Uint8List.fromList(privateKey));
    await accountBox.put(0, entity);

    // Publish account on stream
    _accountSubject.add(account);

    return account;
  }

  /// Import an existing account by the 25-word mnemonic.
  ///
  /// Throws [AlgorandException] if unable to restore the account
  Future<Account> importAccount(List<String> words) async {
    final account = await algorand.restoreAccount(words);

    // Store the account in our local DB.
    // NOTE! Storing your private key like this is insecure!
    // Make sure to encrypt the private key and store it in a secure location!
    final privateKey = await account.keyPair.extractPrivateKeyBytes();
    final entity =
        AccountEntity.account(account, Uint8List.fromList(privateKey));
    await accountBox.put(0, entity);

    // Publish account on streamn
    _accountSubject.add(account);

    return account;
  }

  void close() {
    _accountSubject.close();
  }
}
