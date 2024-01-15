import 'package:mobx/mobx.dart';

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
}
