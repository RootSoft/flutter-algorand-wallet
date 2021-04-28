import 'package:algorand_dart/algorand_dart.dart';
import 'package:equatable/equatable.dart';

abstract class AssetFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssetFormInitial extends AssetFormState {}

class AssetFormInProgress extends AssetFormState {}

class AssetFormFailure extends AssetFormState {
  final AlgorandException exception;

  AssetFormFailure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

class AssetFormSuccess extends AssetFormState {}
