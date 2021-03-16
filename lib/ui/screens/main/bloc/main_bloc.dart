import 'dart:async';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainBloc extends Cubit<Account?> {
  final AccountRepository accountRepository;

  late final StreamSubscription _accountSubscription;

  MainBloc({required this.accountRepository})
      : super(accountRepository.account) {
    _buildAccountSubscription(accountRepository.accountStateChanges);
  }

  Account? get account => state;

  void _buildAccountSubscription(Stream<Account> stream) {
    _accountSubscription = stream.listen((account) {
      emit(account);
    });
  }

  @override
  Future<void> close() {
    _accountSubscription.cancel();
    return super.close();
  }
}
