import 'package:algorand_dart/algorand_dart.dart';
import 'package:equatable/equatable.dart';

abstract class ListAssetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListAssetInitial extends ListAssetState {}

class ListAssetInProgress extends ListAssetState {}

class ListAssetFailure extends ListAssetState {
  final AlgorandException exception;

  ListAssetFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class ListAssetSuccess extends ListAssetState {
  final List<Asset> assets;

  ListAssetSuccess({required this.assets});

  @override
  List<Object?> get props => [...assets];
}

class ListAssetOptInSuccess extends ListAssetSuccess {
  final Asset asset;

  ListAssetOptInSuccess({required this.asset, required List<Asset> assets})
      : super(assets: assets);

  @override
  List<Object?> get props => [asset];
}
