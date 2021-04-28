import 'package:equatable/equatable.dart';

abstract class ListAssetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ListAssetStarted extends ListAssetEvent {}

class ListAssetSearched extends ListAssetEvent {
  final String input;

  ListAssetSearched(this.input);

  @override
  List<Object?> get props => [input];
}
