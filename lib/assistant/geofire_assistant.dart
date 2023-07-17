import 'package:carpool_users/modals/active_nearby_available_drivers.dart';

class GeoFireAssistant{
  static List <ActiveNearByAvailableDrivers> activeNearByAvailableDriversList = [];

  static void deleteOfflineDriversFromList(String driverId){
    int indexNumber = activeNearByAvailableDriversList.indexWhere((element) => element.driveId == driverId);

    activeNearByAvailableDriversList.removeAt(indexNumber);

  }

  static void updateActiveNearByAvailableDriverLocation(ActiveNearByAvailableDrivers driverWhoMove){
    int indexNumber = activeNearByAvailableDriversList.indexWhere((element) => element.driveId == driverWhoMove.driveId);

    activeNearByAvailableDriversList[indexNumber].locationLatitude= driverWhoMove.locationLatitude;
    activeNearByAvailableDriversList[indexNumber].locationLongitude = driverWhoMove.locationLongitude;
  }
}