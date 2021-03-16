// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algorand_standard_asset_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlgorandStandardAssetAdapter
    extends TypeAdapter<AlgorandStandardAssetEntity> {
  @override
  final int typeId = 1;

  @override
  AlgorandStandardAssetEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlgorandStandardAssetEntity()
      ..id = fields[0] as int
      ..name = fields[1] as String?
      ..unitName = fields[2] as String?
      ..amount = fields[3] as int
      ..decimals = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, AlgorandStandardAssetEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.unitName)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.decimals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlgorandStandardAssetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
