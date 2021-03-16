import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class WalletStarted extends WalletEvent {}

class WalletCreateStarted extends WalletEvent {}

class WalletImportStarted extends WalletEvent {
  final String passphrase;

  WalletImportStarted({required this.passphrase});

  @override
  List<Object?> get props => [passphrase];
}
