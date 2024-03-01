// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:reminder_app_mobx/auth/auth_error.dart';
import 'package:reminder_app_mobx/state/reminder.dart';
part 'app_state.g.dart';

class AppState = _AppState with _$AppState;

abstract class _AppState with Store {
  @observable
  AppScreen currentScreen = AppScreen.login;

  @observable
  bool isLoading = false;

  @observable
  User? currentUser;

  @observable
  AuthError? authError;

  @observable
  ObservableList<Reminder> reminder = ObservableList<Reminder>();

  @computed
  ObservableList<Reminder> get sortedReminders => ObservableList.of(
        reminder.sorted(),
      );

  @action
  void goTo(AppScreen appScreen) {
    currentScreen = appScreen;
  }

  @action
  Future<bool> delete(Reminder reminderElement) async {
    isLoading = true;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      isLoading = false;
      return false;
    }
    final userId = user.uid;
    final collection =
        await FirebaseFirestore.instance.collection(userId).get();

    try {
      final firebaseReminder = collection.docs
          .firstWhere((element) => element.id == reminderElement.id);
      await firebaseReminder.reference.delete();

      reminder.removeWhere((element) => element.id == reminderElement.id);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteAccount() async {
    isLoading = true;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      isLoading = false;
      return false;
    }
    final userId = user.uid;

    try {
      final store = FirebaseFirestore.instance;
      final operation = store.batch();
      final collection = await store.collection(userId).get();
      for (final document in collection.docs) {
        operation.delete(document.reference);
      }
      await operation.commit();

      await user.delete();
      await auth.signOut();
      currentScreen = AppScreen.login;
      return true;
    } on FirebaseAuthException catch (e) {
      authError = AuthError.from(e);
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logOut() async {
    isLoading = true;
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
    isLoading = false;
    currentScreen = AppScreen.login;
    reminder.clear();
  }

  @action
  Future<bool> createReminder(String text) async {
    isLoading = true;
    final userId = currentUser?.uid;

    if (userId == null) {
      isLoading = false;
      return false;
    }
    final creationDate = DateTime.now();

    final firebaseReminder =
        await FirebaseFirestore.instance.collection(userId).add(
      {
        _DocumentKey.text: text,
        _DocumentKey.creationDate: creationDate,
        _DocumentKey.isDone: false,
      },
    );

    final reminderItem = Reminder(
      id: firebaseReminder.id,
      creationTime: creationDate,
      text: text,
      isDone: false,
    );

    reminder.add(
      reminderItem,
    );
    isLoading = false;
    return true;
  }

  @action
  Future<bool> modify(
    Reminder reminderItem, {
    required bool isDone,
  }) async {
    final userId = currentUser?.uid;

    if (userId == null) {
      return false;
    }

    final collection =
        await FirebaseFirestore.instance.collection(userId).get();

    final firebaseReminder = collection.docs
        .where((element) => element.id == reminderItem.id)
        .first
        .reference;
    await firebaseReminder.update(
      {
        _DocumentKey.isDone: isDone,
      },
    );

    reminder.firstWhere((element) => element.id == reminderItem.id).isDone =
        isDone;
    return true;
  }

  @action
  Future<void> initialize() async {
    isLoading = true;
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await _loadingReminders();
      currentScreen = AppScreen.reminders;
    } else {
      currentScreen = AppScreen.login;
    }
    isLoading = false;
  }

  @action
  Future<bool> _loadingReminders() async {
    final userId = currentUser?.uid;
    if (userId == null) {
      return false;
    }
    final collection =
        await FirebaseFirestore.instance.collection(userId).get();
    final reminders = collection.docs.map(
      (e) => Reminder(
        id: e.id,
        creationTime: DateTime.parse(e[_DocumentKey.creationDate] as String),
        text: e[_DocumentKey.text] as String,
        isDone: e[_DocumentKey.isDone] as bool,
      ),
    );
    reminder = ObservableList.of(reminders);

    return true;
  }

  @action
  Future<bool> _registerOrLogin({
    required LoginOrRegisterFunction fn,
    required String email,
    required String password,
  }) async {
    authError = null;
    isLoading = true;
    try {
      await fn(email: email, password: password);
      currentUser = FirebaseAuth.instance.currentUser;
      await _loadingReminders();
      return true;
    } on FirebaseAuthException catch (e) {
      currentUser = null;
      authError = AuthError.from(e);
      return false;
    } finally {
      isLoading = false;
      if (currentUser != null) {
        currentScreen = AppScreen.reminders;
      }
    }
  }

  @action
  Future<bool> register({
    required String email,
    required String password,
  }) async =>
      _registerOrLogin(
        fn: FirebaseAuth.instance.createUserWithEmailAndPassword,
        email: email,
        password: password,
      );

  @action
  Future<bool> login({
    required String email,
    required String password,
  }) async =>
      _registerOrLogin(
        fn: FirebaseAuth.instance.signInWithEmailAndPassword,
        email: email,
        password: password,
      );
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

enum AppScreen { login, register, reminders }
