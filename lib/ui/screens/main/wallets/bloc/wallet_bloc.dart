import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/wallets/wallet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final AccountRepository accountRepository;

  WalletBloc({required this.accountRepository}) : super(WalletInitial());

  /// Start the wallet bloc
  void start() {
    add(WalletStarted());
  }

  /// Create a new wallet.
  void createWallet() {
    add(WalletCreateStarted());
  }

  /// Import an existing wallet.
  void importWallet(String passPhrase) {
    add(WalletImportStarted(passphrase: passPhrase));
  }

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is WalletCreateStarted) {
      final account = await accountRepository.createAccount();

      yield WalletCreateSuccess(account: account);
    } else if (event is WalletImportStarted) {
      final words = event.passphrase.trim().split(' ');
      final account = await accountRepository.importAccount(words);

      yield WalletRestoreSuccess(account: account);
    }
  }
}
