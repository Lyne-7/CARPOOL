import 'package:carpool_users/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User ? currentUser;

UserModal? userModalCurrentInfo;