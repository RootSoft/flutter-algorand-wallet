import 'package:equatable/equatable.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';

class NavigationTab extends Equatable {
  final String label;
  final IconData icon;

  NavigationTab({
    required this.label,
    required this.icon,
  });

  @override
  List<Object?> get props => [label, icon];
}
