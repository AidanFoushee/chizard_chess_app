// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0; // Ensure this matches the typeId in your annotations

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      opponent: fields[0] as String,
      winner: fields[1] as String,
      notes: fields[2] as String,
      imagePath: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(4) // Number of fields
      ..writeByte(0)
      ..write(obj.opponent)
      ..writeByte(1)
      ..write(obj.winner)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JournalEntryAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
