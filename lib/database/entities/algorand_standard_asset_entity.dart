import 'package:flutter_algorand_wallet/database/entities.dart';
import 'package:flutter_algorand_wallet/database/entities/box_entity.dart';
import 'package:flutter_algorand_wallet/models/models.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';

part 'algorand_standard_asset_entity.g.dart';

@HiveType(
    typeId: algorandStandardAssetTypeId,
    adapterName: 'AlgorandStandardAssetAdapter')
class AlgorandStandardAssetEntity implements BoxEntity<AlgorandStandardAsset> {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String? name;

  @HiveField(2)
  late String? unitName;

  @HiveField(3)
  late int amount;

  @HiveField(4)
  late int decimals;

  AlgorandStandardAssetEntity();

  AlgorandStandardAssetEntity.asset(AlgorandStandardAsset asset) {
    this.id = asset.id;
    this.name = asset.name;
    this.unitName = asset.unitName;
    this.amount = asset.amount;
    this.decimals = asset.decimals;
  }

  @override
  Future<AlgorandStandardAsset> unwrap() async {
    return AlgorandStandardAsset(
      id: id,
      name: name,
      unitName: unitName,
      amount: amount,
      decimals: decimals,
    );
  }
}
