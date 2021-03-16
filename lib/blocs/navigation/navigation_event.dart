import 'package:equatable/equatable.dart';
import 'package:flutter_algorand_wallet/models/navigation/navigation_tab.dart';

abstract class NavigationEvent extends Equatable {}

class NavigationTabChanged extends NavigationEvent {
  final NavigationTab tab;

  NavigationTabChanged({required this.tab});

  @override
  List<Object?> get props => [tab];
}
