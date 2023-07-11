import 'package:firebase_database/firebase_database.dart';

class UserModal {
  String? phone;
  String? name;
  String? id;
  String? email;

  UserModal({
    this.name,
    this.email,
    this.id,
    this.phone
});

UserModal.fromSnapshot(DataSnapshot snap){
  phone = (snap.value as dynamic)["phone"];
  id = snap.key;
  name = (snap.value as dynamic)["name"];
  email = (snap.value as dynamic)["email"];

}

}