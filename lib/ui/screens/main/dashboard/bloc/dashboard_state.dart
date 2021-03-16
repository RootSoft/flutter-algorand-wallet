import 'package:algorand_dart/algorand_dart.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_algorand_wallet/models/models.dart';
import 'package:flutter_algorand_wallet/models/transaction_event.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardInProgress extends DashboardState {}

class DashboardFailure extends DashboardState {}

class DashboardNoAccount extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final Account account;
  final AccountInformation information;
  final List<AlgorandStandardAsset> assets;
  final AlgorandStandardAsset? selectedAsset;
  final List<TransactionEvent> transactions;

  DashboardSuccess({
    required this.account,
    required this.information,
    required this.assets,
    required this.selectedAsset,
    this.transactions = const [],
  });

  DashboardSuccess copyWith({
    AlgorandStandardAsset? asset,
    List<TransactionEvent>? transactions,
  }) {
    return DashboardSuccess(
      account: account,
      information: information,
      assets: assets,
      selectedAsset: asset ?? selectedAsset,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  List<Object?> get props => [
        account.publicAddress,
        information,
        ...assets,
        selectedAsset,
        ...transactions
      ];
}
