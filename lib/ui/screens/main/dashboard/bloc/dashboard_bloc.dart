import 'dart:async';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/database/entities/algorand_standard_asset_entity.dart';
import 'package:flutter_algorand_wallet/models/algorand_standard_asset_model.dart';
import 'package:flutter_algorand_wallet/models/transaction_event.dart';
import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/dashboard/dashboard.dart';
import 'package:flutter_algorand_wallet/utils/list_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AccountRepository accountRepository;

  /// Stream to listen to account changes
  late final StreamSubscription<Account> _accountSubscription;

  DashboardBloc({required this.accountRepository}) : super(DashboardInitial()) {
    _accountSubscription =
        _buildAccountSubscription(accountRepository.accountStateChanges);
  }

  /// Start the dashboard.
  void start() {
    add(DashboardStarted());
  }

  /// Reload the dashboard with new changes.
  void reload() {
    add(DashboardStarted());
  }

  void setSelectedAsset(AlgorandStandardAsset asset) {
    add(DashboardAssetChanged(asset));
  }

  void compound() {
    add(DashboardCompoundStarted());
  }

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    // Fetch the active account
    final account = accountRepository.account;

    if (account == null) {
      yield DashboardNoAccount();
      return;
    }

    final currentState = state;
    if (event is DashboardStarted) {
      yield DashboardInProgress();

      // Fetch the balance
      final information =
          await algorand.getAccountByAddress(account.publicAddress);

      // Sync the assets locally
      final assets = await syncAssets(information.assets);

      final algorandAsset = AlgorandStandardAsset(
        id: -1,
        name: 'Algorand',
        unitName: 'Algo',
        amount: information.amountWithoutPendingRewards,
        decimals: 6,
      );

      // Add Algorand as first item
      assets.insert(0, algorandAsset);

      yield DashboardSuccess(
        account: account,
        information: information,
        assets: assets,
        selectedAsset: assets.firstOrNull,
      );

      // Load the transactions for your Algo's.
      setSelectedAsset(algorandAsset);
    }

    if (event is DashboardAssetChanged && currentState is DashboardSuccess) {
      yield currentState.copyWith(
        asset: event.asset,
        transactions: [],
        isFetchingTransactions: true,
      );

      // Fetch the transactions for the account
      try {
        SearchTransactionsResponse transactionsResponse;
        if (event.asset.id == -1) {
          transactionsResponse = await algorand
              .indexer()
              .transactions()
              .forAccount(account.publicAddress)
              .whereTransactionType(TransactionType.PAYMENT)
              .search(limit: 50);
        } else {
          transactionsResponse = await algorand
              .indexer()
              .transactions()
              .forAccount(account.publicAddress)
              .whereAssetId(event.asset.id)
              .whereTransactionType(TransactionType.ASSET_TRANSFER)
              .search(limit: 50);
        }

        // Map tx's to tx events for easier display
        final txEvents = transactionsResponse.transactions
            .map(
              (tx) => TransactionEvent.fromTransaction(
                account: account,
                transaction: tx,
                decimals: event.asset.decimals,
              ),
            )
            .toList();

        yield currentState.copyWith(
          asset: event.asset,
          transactions: txEvents,
          isFetchingTransactions: false,
        );
      } catch (ex) {
        print(ex);
      }
    }

    if (event is DashboardCompoundStarted && currentState is DashboardSuccess) {
      // Send a 0-transaction with a min fee
      final txId = await algorand.sendPayment(
        account: account,
        recipient: account.address,
        amount: Algo.toMicroAlgos(0),
      );

      print(txId);
    }
  }

  /// Sync the assets
  Future<List<AlgorandStandardAsset>> syncAssets(
      final List<AssetHolding> holdings) async {
    final assetBox = Hive.box<AlgorandStandardAssetEntity>('assets');
    final asas = <AlgorandStandardAsset>[];

    for (var holding in holdings) {
      // Check if we have the holding stored locally
      if (assetBox.containsKey(holding.assetId)) {
        final asset = await assetBox.get(holding.assetId)?.unwrap();
        if (asset == null) continue;

        // Update the latest amount
        asas.add(asset.copyWith(amount: holding.amount));
        continue;
      }

      // Prevent spamming the API
      await Future.delayed(const Duration(milliseconds: 200));

      try {
        final assetResponse =
            await algorand.indexer().getAssetById(holding.assetId);

        // Store the asset
        final asset = assetResponse.asset;

        final asa = AlgorandStandardAsset(
          id: asset.index,
          name: asset.params.name,
          unitName: asset.params.unitName,
          amount: holding.amount,
          decimals: asset.params.decimals,
        );

        asas.add(asa);

        await assetBox.put(asa.id, AlgorandStandardAssetEntity.asset(asa));
      } on AlgorandException catch (ex) {
        print(ex.message);
      }
    }

    return asas;
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
