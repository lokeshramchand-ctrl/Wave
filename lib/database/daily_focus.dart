import 'package:isar/isar.dart';

part 'daily_focus.g.dart';

@collection
class DailyFocus {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late DateTime date;

  late int minutes;
}
