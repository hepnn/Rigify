// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StopTypeAdapter extends TypeAdapter<StopType> {
  @override
  final int typeId = 2;

  @override
  StopType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StopType(
      stopName: fields[0] as String?,
      route: fields[1] as RouteType?,
      id: fields[2] as String?,
      asciiName: fields[3] as String?,
      latitude: fields[4] as double?,
      longitude: fields[5] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, StopType obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.stopName)
      ..writeByte(1)
      ..write(obj.route)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.asciiName)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StopTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
