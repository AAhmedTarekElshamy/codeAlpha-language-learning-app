// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 2;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      currentStreak: fields[0] as int,
      longestStreak: fields[1] as int,
      totalWordsLearned: fields[2] as int,
      totalQuizzesTaken: fields[3] as int,
      totalCorrectAnswers: fields[4] as int,
      totalQuestionsAnswered: fields[5] as int,
      lastStudyDate: fields[6] as DateTime?,
      studyDates: (fields[7] as List?)?.cast<String>(),
      dailyXp: fields[8] as int,
      totalXp: fields[9] as int,
      achievements: (fields[10] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.longestStreak)
      ..writeByte(2)
      ..write(obj.totalWordsLearned)
      ..writeByte(3)
      ..write(obj.totalQuizzesTaken)
      ..writeByte(4)
      ..write(obj.totalCorrectAnswers)
      ..writeByte(5)
      ..write(obj.totalQuestionsAnswered)
      ..writeByte(6)
      ..write(obj.lastStudyDate)
      ..writeByte(7)
      ..write(obj.studyDates)
      ..writeByte(8)
      ..write(obj.dailyXp)
      ..writeByte(9)
      ..write(obj.totalXp)
      ..writeByte(10)
      ..write(obj.achievements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
