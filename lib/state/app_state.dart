import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:reminder_app_mobx/state/reminder.dart';
part 'app_state.g.dart';

class AppState = _AppState with _$AppState;

abstract class _AppState with Store{

}
abstract class _DocumentKey {
  static const text = 'text';
  static const creationDate = 'creation_date';
  static const isDone = 'is_done';
}

typedef LoginOrRegisterFunction = Future<UserCredential> Function({
  required String email,
  required String password,
});

extension ToInt on bool {
  int toInteger() => this ? 1 : 0;
}

extension Sorted on List<Reminder> {
  List<Reminder> sorted() => [...this]..sort(
      (lhs, rhs) {
        final isDone = lhs.isDone.toInteger().compareTo(
              rhs.isDone.toInteger(),
            );
        if (isDone != 0) {
          return isDone;
        }
        return rhs.creationTime.compareTo(lhs.creationTime);
      },
    );
}

enum AppScreen {login, register, reminders}