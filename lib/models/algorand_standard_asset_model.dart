import 'package:equatable/equatable.dart';

class AlgorandStandardAsset extends Equatable {
  final int id;
  final String? name;
  final String? unitName;
  final int amount;
  final int decimals;

  AlgorandStandardAsset({
    required this.id,
    required this.name,
    required this.unitName,
    required this.amount,
    required this.decimals,
  });

  AlgorandStandardAsset copyWith({
    int? amount,
  }) {
    return AlgorandStandardAsset(
      id: id,
      name: name,
      unitName: unitName,
      amount: amount ?? this.amount,
      decimals: decimals,
    );
  }

  @override
  List<Object?> get props => [id, name, unitName, amount, decimals];
}
