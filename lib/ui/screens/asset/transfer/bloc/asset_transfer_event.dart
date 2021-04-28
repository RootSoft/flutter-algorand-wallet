import 'package:equatable/equatable.dart';
import 'package:flutter_algorand_wallet/models/models.dart';

class AssetTransferEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssetTransferStarted extends AssetTransferEvent {
  final AlgorandStandardAsset asset;

  AssetTransferStarted(this.asset);

  @override
  List<Object?> get props => [asset];
}

class AssetTransferSent extends AssetTransferEvent {
  final double amount;
  final String recipientAddress;

  AssetTransferSent({required this.amount, required this.recipientAddress});

  @override
  List<Object?> get props => [amount, recipientAddress];
}
