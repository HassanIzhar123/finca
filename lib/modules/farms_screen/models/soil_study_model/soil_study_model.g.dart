// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'soil_study_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoilStudyModelAdapter extends TypeAdapter<SoilStudyModel> {
  @override
  final int typeId = 0;

  @override
  SoilStudyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoilStudyModel(
      uid: fields[0] as String,
      id: fields[1] as String,
      path: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SoilStudyModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoilStudyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
