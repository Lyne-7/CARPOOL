import 'package:carpool_users/modals/directions_details_info.dart';
import 'package:carpool_users/modals/user_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User ? currentUser;

UserModal? userModalCurrentInfo = UserModal();


DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress= '';
String driveCarDetails = '';
String driverName= '';
String driverPhone= '';

double countRatingStars = 0.0;
String titleStarRating = '';