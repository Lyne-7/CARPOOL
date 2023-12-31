import 'package:carpool_users/assistant/request_assistant.dart';
import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/global/maps_key.dart';
import 'package:carpool_users/infoHandler/app_info.dart';
import 'package:carpool_users/modals/directions.dart';
import 'package:carpool_users/modals/directions_details_info.dart';
import 'package:carpool_users/modals/user_modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
      humanReadableAddress = requestResponse['results'][0]['Formatted address'];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude= position.latitude;
      userPickUpAddress.locationLongitude= position.longitude;
      userPickUpAddress.locationName= humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async{

    String urlOriginToDestinationDirectionDetails = 'https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey';
    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);
    // if(responseDirectionApi == "Error occurred. no response."){
    //   return null;
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi['routes'][0]['overview_polyline']['points'];
    directionDetailsInfo.distance_text = responseDirectionApi['routes'][0]['legs'][0]['distance']['text'];
    directionDetailsInfo.distance_value = responseDirectionApi['routes'][0]['legs'][0]['distance']['value'];

    directionDetailsInfo.duration_text = responseDirectionApi['routes'][0]['legs'][0]['duration']['text'];
    directionDetailsInfo.distance_value = responseDirectionApi['routes'][0]['legs'][0]['duration']['value'];

    return directionDetailsInfo;

}

static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){
    double timeTravelledFareAmountPerMinute = (directionDetailsInfo.duration_value! /60 ) * 0.1;
    double distanceTravelledFareAmountPerKilometer = (directionDetailsInfo.duration_value! /1000) * 0.1;


    //USD
  double totalFareAmount = timeTravelledFareAmountPerMinute + distanceTravelledFareAmountPerKilometer;

  return double.parse(totalFareAmount.toStringAsFixed(1));

}
}