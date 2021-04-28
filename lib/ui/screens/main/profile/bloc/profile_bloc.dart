import 'dart:async';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/profile/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AccountRepository accountRepository;

  /// Stream to listen to account changes
  late final StreamSubscription<Account> _accountSubscription;

  ProfileBloc({
    required this.accountRepository,
  }) : super(ProfileInitial()) {
    _accountSubscription =
        _buildAccountSubscription(accountRepository.accountStateChanges);
  }

  void start() {
    add(ProfileStarted());
  }

  /// Reload the profile with new changes.
  void reload() {
    add(ProfileStarted());
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileStarted) {
      final account = accountRepository.account;
      if (account == null) {
        yield ProfileNoAccount();
        return;
      }

      final seedPhrase = await account.seedPhrase;

      yield ProfileSuccess(account: account, seedphrase: seedPhrase.join(' '));
    }
  }

  StreamSubscription<Account> _buildAccountSubscription(
      Stream<Account> stream) {
    return stream.listen((account) {
      reload();
    });
  }

  @override
  Future<void> close() async {
    _accountSubscription.cancel();
    return super.close();
  }
}
