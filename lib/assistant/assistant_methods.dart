import 'package:carpool_users/assistant/request_assistant.dart';
import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/global/maps_key.dart';
import 'package:carpool_users/modals/directions.dart';
import 'package:carpool_users/modals/user_modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

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

  static Future<String> searchAddressForGeographicCoordinates(Position position, context) async {

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = '';

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    if(requestResponse!= 'Error occurred. no response.'){
      humanReadableAddress = requestResponse['results'][0]["Formatted address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude= position.latitude;
      userPickUpAddress.locationLongitude= position.longitude;
      userPickUpAddress.locationName= humanReadableAddress;

     // Provider.of<AppInfo>(context. listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }
}