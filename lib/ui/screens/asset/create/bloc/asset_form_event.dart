import 'package:equatable/equatable.dart';

abstract class AssetFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssetFormStarted extends AssetFormEvent {}

class AssetFormCreateStarted extends AssetFormEvent {
  final String assetName;
  final String unitName;
  final int amount;
  final int decimals;

  AssetFormCreateStarted({
    required this.assetName,
    required this.unitName,
    required this.amount,
    required this.decimals,
  });

  @override
  List<Object?> get props => [assetName, unitName, amount, decimals];
}
