import 'dart:async';
import 'dart:core';
import 'package:carpool_users/assistant/assistant_methods.dart';
import 'package:carpool_users/assistant/geofire_assistant.dart';
import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/global/maps_key.dart';
import 'package:carpool_users/infoHandler/app_info.dart';
import 'package:carpool_users/modals/active_nearby_available_drivers.dart';
import 'package:carpool_users/modals/directions.dart';
import 'package:carpool_users/screens/drawer_screen.dart';
import 'package:carpool_users/screens/precise_pickup_location.dart';
import 'package:carpool_users/screens/search_places_screen.dart';
import 'package:carpool_users/widgets/progress_dialog.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // String userDropOffAddress = '';
  // void openSearchPlacesScreen() async {
  //   final selectedPlace = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SearchPlacesScreen()),
  //   );
  //
  //   if (selectedPlace != null) {
  //     setState(() {
  //       // Update the 'userDropOffLocation' in the AppInfo provider with the selected place
  //       Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(selectedPlace);
  //
  //       // Set the selected place in the 'to' section
  //       userDropOffAddress = selectedPlace.locationName!;
  //     });
  //   }
  // }


  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;


  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
   zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
 double waitingResponsefromDriverContainerHeight =0;
  double assignedDriverInfoContainerHeight = 0;

 Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap=0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet= {};

  Set<Marker> markersSet ={};
 Set<Circle> circlesSet= {};

  String userName = '';
  String userEmail = '';

 bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(userCurrentPosition!, context);
    print("This is our address =" + humanReadableAddress);

    userName = userModalCurrentInfo!.name!;
    userEmail = userModalCurrentInfo!.email!;


    initializeGeoFireListener();

   // AssistantMethods.readTripsForOnlineUser(context);
  }

  initializeGeoFireListener() {
    Geofire.initialize('activeDrivers');

    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);

      if (map != null) {
        var callback = map['Callback'];

        switch (callback) {
        //when any driver becomes active

          case Geofire.onKeyEntered:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers = ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLongitude = map['longitude'];
            activeNearByAvailableDrivers.locationLatitude = map['latitude'];
            activeNearByAvailableDrivers.driveId = map['key'];
            GeoFireAssistant.activeNearByAvailableDriversList.add(
                activeNearByAvailableDrivers);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUsersMap();
            }
            break;
//when driver is offline
          case Geofire.onKeyExited:
            GeoFireAssistant.deleteOfflineDriversFromList(map['key']);
            displayActiveDriversOnUsersMap();

            break;
        //when driver moves update location
          case Geofire.onKeyMoved:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers = ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLongitude = map['longitude'];
            activeNearByAvailableDrivers.locationLatitude = map['latitude'];
            activeNearByAvailableDrivers.driveId = map['key'];
            GeoFireAssistant.updateActiveNearByAvailableDriverLocation(
                activeNearByAvailableDrivers);
            displayActiveDriversOnUsersMap();
            break;

        //display available drivers on user's map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUsersMap();
            break;
        }
      }
    });}

      displayActiveDriversOnUsersMap(){
      setState(() {
        markersSet.clear();
        circlesSet.clear();

        Set<Marker> driversMarkerSet = Set<Marker>();

        for(ActiveNearByAvailableDrivers eachDriver in GeoFireAssistant.activeNearByAvailableDriversList){
          LatLng eachDriverActivePosition = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

          Marker marker = Marker(
            markerId: MarkerId(eachDriver.driveId!),
            position: eachDriverActivePosition,
            icon: activeNearbyIcon!,
            rotation: 360,

          );
          driversMarkerSet.add(marker);
        }

        setState(() {
          markersSet = driversMarkerSet;
        });


      });

    }

    createActiveNearByDriverIconMarker(){
    if(activeNearbyIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(1, 1));
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'images/carpool1.jpg').then((value){
        activeNearbyIcon = value;
      });

    }
    }


  Future<void> drawPolyLineFromOriginToDestination(bool darkTheme) async {
    var originPosition = Provider
        .of<AppInfo>(context, listen: false)
        .userPickUpLocation;
    var destinationPosition = Provider
        .of<AppInfo>(context, listen: false)
        .userDropOffLocation;

    var originLatLng = LatLng(
        originPosition!.locationLatitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(message: 'Please wait',),
    );

    var directionDetailsInfo = await AssistantMethods
        .obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);
    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolylinePointsResultList = pPoints.decodePolyline(
        directionDetailsInfo.e_points!);

    pLineCoordinatedList.clear();
    LatLngBounds boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: originLatLng);


    if (decodePolylinePointsResultList.isNotEmpty) {
      decodePolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });


    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: darkTheme ? Colors.amberAccent : Colors.blue,
        polylineId: PolylineId('PolylineId'),
        jointType: JointType.round,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5,


      );

      polylineSet.add(polyline);
    });

    // LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    }
    else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    }
    else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    }
  }

    else{
      boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);

    }


    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: MarkerId('originId'),
      infoWindow: InfoWindow(title: originPosition.locationName, snippet: 'origin'),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destinationId'),
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: 'Destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),

    );

    setState(() {
      markersSet.add(originMarker);
      markersSet.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: CircleId('originId'),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destinationId'),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );
    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });

  }


 // getAddressFromLatLng() async {
 //     try{
 //       GeoData data = await Geocoder2.getDataFromCoordinates(
 //           latitude: pickLocation!.latitude,
 //           longitude: pickLocation!.longitude,
 //           googleMapApiKey: mapKey
 //       );
 //       setState(() {
 //         Directions userPickUpAddress = Directions();
 //         userPickUpAddress.locationLatitude= pickLocation!.latitude;
 //         userPickUpAddress.locationLongitude= pickLocation!.longitude;
 //         userPickUpAddress.locationName= data.address;
 //
 //         Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
 //         _address = data.address;
 //       });
 //     } catch(e){
 //       print(e);
 //   }
 // }
  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if(
    _locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermissionAllowed();
  }


  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    createActiveNearByDriverIconMarker();

    return GestureDetector(
     onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldState,
       drawer: DrawerScreen(),
       body: Stack(
         children: [
            GoogleMap(
                mapType:MapType.normal,
                myLocationEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,

                initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller){
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController= controller;

                  setState(() {

                  });

                  locateUserPosition();
              },
               // onCameraMove: (CameraPosition? position){
               //     if(pickLocation != position!.target){
               //       setState(() {
               //         pickLocation = position.target;
               //       });
               //     }
               // },
               // onCameraIdle: (){
               //    getAddressFromLatLng();
               // },
            ),
            // Align(
            // alignment:Alignment.center,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom:35.0),
            //     child: Image.asset('images/pick.png',height:45 , width:45 ),
            //   ),
            // ),
           // custom button for drawer
           Positioned(
             top: 50,
             left: 20,
             child: Container(
               child: GestureDetector(
                 onTap: (){
                   _scaffoldState.currentState!.openDrawer();

                 },
                 child: CircleAvatar(
                   backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.white,
                   child: Icon(
                     Icons.menu,
                     color: darkTheme? Colors.black : Colors.lightBlue,
                   ),
                 ),
               ),
             ),
           ),
           
           
           //ui for searching location
           Positioned(
             bottom: 0,
             left: 0,
             right: 0,
             child: Padding(
               padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       color: darkTheme ? Colors.black : Colors.white,
                       borderRadius: BorderRadius.circular(10)

                     ),
                     child: Column(
                       children: [
                         Container(
                           decoration: BoxDecoration(
                             color: darkTheme ? Colors.grey.shade900 : Colors.grey.shade100,
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: Column(
                             children: [
                               Padding(
                                 padding: EdgeInsets.all(5),
                                 child: Row(
                                   children: [
                                     Icon(Icons.location_on_outlined, color: darkTheme ? Colors.amber.shade400 : Colors.blue,),
                                     SizedBox(width: 10,),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text("From",
                                         style: TextStyle(
                                           color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                           fontSize: 12,
                                           fontWeight: FontWeight.bold,
                                         ),
                                         ),
                                         Text(Provider.of<AppInfo>(context).userPickUpLocation != null
                                             ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!
                                              :"Not getting address",
                                         style: TextStyle(color: Colors.grey, fontSize: 14),
                                         )
                                       ],
                                     )
                                   ],
                                 ),
                               ),

                               SizedBox(height: 5,),
                               Divider(
                                 height: 1,
                                 thickness: 2,
                                 color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                               ),

                               SizedBox(height:5,),

                               Padding(
                                 padding: EdgeInsets.all(5),
                                 child: GestureDetector(
                                   onTap: () async {
                                        var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder: (e)=> SearchPlacesScreen()));

                                        if(responseFromSearchScreen == 'obtainedDropOff'){
                                          setState(() {
                                            openNavigationDrawer= false;
                                          });
                                        }


                                   },

                                   child: Row(
                                     children: [
                                       Icon(Icons.location_on_outlined, color: darkTheme ? Colors.amber.shade400 : Colors.blue,),
                                       SizedBox(width: 10,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text("To",
                                             style: TextStyle(
                                               color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                               fontSize: 12,
                                               fontWeight: FontWeight.bold,
                                             ),
                                           ),
                                           Text(Provider.of<AppInfo>(context).userDropOffLocation != null
                                               ? Provider.of<AppInfo>(context).userDropOffLocation!.locationName!
                                               :"Where to?",
                                             style: TextStyle(color: Colors.grey, fontSize: 14),
                                           )
                                         ],
                                       )
                                     ],
                                   ),
                                 ),
                               )


                             ],
                           ),
                         ),


                         SizedBox(height: 5,),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             ElevatedButton(
                                 onPressed: (){
                                   Navigator.push(context, MaterialPageRoute(builder:(c) => PrecisePickUpScreen() ));

                                 },
                                 child: Text(
                                   'Change Pick Up',
                                   style: TextStyle(
                                     color: darkTheme ? Colors.black : Colors.white,
                                   ),
                                 ),
                               style: ElevatedButton.styleFrom(
                                 primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                 textStyle: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: 16,
                                 )
                               ),
                             ),

                             SizedBox(width: 10,),
                             ElevatedButton(
                               onPressed: (){

                               },
                               child: Text(
                                 'Request A Ride',
                                 style: TextStyle(
                                   color: darkTheme ? Colors.black : Colors.white,
                                 ),
                               ),
                               style: ElevatedButton.styleFrom(
                                   primary: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                   textStyle: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 16,
                                   )
                               ),
                             ),
                           ],
                         )
                       ],
                     ),
                   )
                 ],
               )
             ),
           )

           //Positioned(

           //  top: 40,
           //  right: 20,
            // left: 20,
           //  child: Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black),
            //     color: Colors.white,
              // ),
            //   padding: EdgeInsets.all(20),
         //      child: Text(
              //   Provider.of<AppInfo>(context).userPickUpLocation != null  ? (Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0, 24) + "..."
              //   :"Not getting address",
               //  overflow: TextOverflow.visible, softWrap: true,
              // ),

           //  ),
         //  )



          ],
        )
      ),
    );
  }
}


