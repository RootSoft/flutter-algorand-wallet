import 'dart:typed_data';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/database/entities.dart';
import 'package:flutter_algorand_wallet/database/entities/box_entity.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';

part 'account_entity.g.dart';

@HiveType(typeId: accountTypeId, adapterName: 'AccountAdapter')
class AccountEntity implements BoxEntity<Account> {
  @HiveField(0)
  late String publicAddress;

  @HiveField(1)
  late Uint8List privateKey;

  AccountEntity();

  AccountEntity.account(Account account, Uint8List privateKey) {
    this.publicAddress = account.publicAddress;
    this.privateKey = privateKey;
  }

  @override
  Future<Account> unwrap() async {
    return Account.fromSeed(this.privateKey);
  }
}
