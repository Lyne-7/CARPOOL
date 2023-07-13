import 'dart:async';
import 'dart:core';



import 'package:carpool_users/assistant/assistant_methods.dart';
import 'package:carpool_users/global/maps_key.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

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
  }
getAddressFromLatLng() async {
    try{
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapKey
      );
      setState(() {
        _address = data.address;
      });
    } catch(e){
      print(e);
  }
}
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
    return GestureDetector(
     onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              onCameraMove: (CameraPosition? position){
                  if(pickLocation != position!.target){
                    setState(() {
                      pickLocation = position.target;
                    });
                  }
              },
              onCameraIdle: (){
                 getAddressFromLatLng();
              },
            ),
           Align(
             alignment:Alignment.center,
             child: Padding(
               padding: const EdgeInsets.only(bottom:35.0),
               child: Image.asset('images/pick.png',height:45 , width:45 ),
             ),
           ),
           Positioned(
             top: 40,
             right: 20,
             left: 20,
             child: Container(
               decoration: BoxDecoration(
                 border: Border.all(color: Colors.black),
                 color: Colors.white,
               ),
               padding: EdgeInsets.all(20),
               child: Text(_address ?? 'Set your pickup location',
                 overflow: TextOverflow.visible, softWrap: true,
               ),

             ),
           )
          ],
        )
      )
    );
  }
}
