import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry {
  @HiveField(0)
  String opponent;

  @HiveField(1)
  String winner;

  @HiveField(2)
  String notes;

  @HiveField(3)
  String? imagePath; // Store image path instead of File object

  JournalEntry({required this.opponent, required this.winner, required this.notes, this.imagePath});
}
