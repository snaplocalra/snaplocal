// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_translated_language_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveTranslatedLanguageDbModelAdapter
    extends TypeAdapter<HiveTranslatedLanguageDbModel> {
  @override
  final int typeId = 0;

  @override
  HiveTranslatedLanguageDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveTranslatedLanguageDbModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveTranslatedLanguageDbModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sourceText)
      ..writeByte(1)
      ..write(obj.translatedText)
      ..writeByte(2)
      ..write(obj.localeCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveTranslatedLanguageDbModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
