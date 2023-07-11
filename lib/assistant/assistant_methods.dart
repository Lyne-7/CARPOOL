import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/modals/user_modal.dart';
import 'package:firebase_database/firebase_database.dart';

class AssistantMethods{

  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
    .ref()
    .child("users")
    .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModalCurrentInfo = UserModal.fromSnapshot(snap.snapshot);
    }
    });
  }
}