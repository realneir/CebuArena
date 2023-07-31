import 'package:firebase_database/firebase_database.dart';
import 'package:captsone_ui/models/user_model.dart';

class AuthenticationService {
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('users');

  Stream<List<UserModel>> getUsers() {
    return _userRef.onValue.map((event) {
      final Map<dynamic, dynamic>? values =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (values != null) {
        return values.values
            .map(
                (value) => UserModel.fromJson(Map<String, dynamic>.from(value)))
            .toList();
      } else {
        return [];
      }
    });
  }
}
