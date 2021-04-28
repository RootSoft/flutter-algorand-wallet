import 'package:algorand_dart/algorand_dart.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileInProgress extends ProfileState {}

class ProfileFailure extends ProfileState {}

class ProfileNoAccount extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Account account;
  final String seedphrase;

  ProfileSuccess({required this.account, required this.seedphrase});

  @override
  List<Object?> get props => [account, seedphrase];
}
