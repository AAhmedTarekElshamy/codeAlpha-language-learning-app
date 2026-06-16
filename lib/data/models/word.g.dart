// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 0;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      id: fields[0] as String,
      original: fields[1] as String,
      translation: fields[2] as String,
      pronunciation: fields[3] as String,
      category: fields[4] as String,
      subcategory: fields[5] as String,
      languageCode: fields[6] as String,
      exampleSentence: fields[7] as String?,
      exampleTranslation: fields[8] as String?,
      masteryLevel: fields[9] as int,
      timesReviewed: fields[10] as int,
      timesCorrect: fields[11] as int,
      lastReviewedAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.original)
      ..writeByte(2)
      ..write(obj.translation)
      ..writeByte(3)
      ..write(obj.pronunciation)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.subcategory)
      ..writeByte(6)
      ..write(obj.languageCode)
      ..writeByte(7)
      ..write(obj.exampleSentence)
      ..writeByte(8)
      ..write(obj.exampleTranslation)
      ..writeByte(9)
      ..write(obj.masteryLevel)
      ..writeByte(10)
      ..write(obj.timesReviewed)
      ..writeByte(11)
      ..write(obj.timesCorrect)
      ..writeByte(12)
      ..write(obj.lastReviewedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
