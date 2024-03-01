// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

part 'reminder.g.dart';

class Reminder = _Reminder with _$Reminder;

abstract class _Reminder with Store {
  final String id;
  final DateTime creationTime;

  @observable
  String text;

  @observable
  bool isDone;

  _Reminder({
    required this.id,
    required this.creationTime,
    required this.text,
    required this.isDone,
  });

  @override
  bool operator ==(covariant _Reminder other) =>
      id == other.id &&
      creationTime == other.creationTime &&
      text == other.text &&
      isDone == other.isDone;

  @override
  int get hashCode => Object.hash(id, creationTime, text, isDone);
}
