import 'package:carpool_users/assistant/request_assistant.dart';
import 'package:carpool_users/global/global.dart';
import 'package:carpool_users/global/maps_key.dart';
import 'package:carpool_users/infoHandler/app_info.dart';
import 'package:carpool_users/modals/directions.dart';
import 'package:carpool_users/modals/predicted_places.dart';
import 'package:carpool_users/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacePredictionTileDesign extends StatefulWidget {
  final PredictedPlaces ? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});
  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}


  // final PredictedPlaces ? predictedPlaces;
  //
  // final Function(PredictedPlaces?) onTilePressed;
  //
  // PlacePredictionTileDesign({this.predictedPlaces, required this.onTilePressed});





//   @override
//   State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
// }

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {

  getPlaceDirectionDetails(String? placeId, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Setting up drop-off. Please wait",
      ),
    );

    String placeDirectionDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);
    Navigator.pop(context);

    if (responseApi == "Error occurred. no response.") {
      // Handle error condition
      return;
    }

    if (responseApi['status'] == 'OK') {
      Directions directions = Directions();
      directions.locationName = responseApi['result']['name'];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi['result']['geometry']['location']['lat'];
      directions.locationLongitude = responseApi['result']['geometry']['location']['lng'];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context, 'obtainDropOff');

      // Navigate back to the MainScreen
      Navigator.pushReplacementNamed(context, 'main_screen');
    } else {
      // Handle other status conditions if needed
    }
  }


// getPlaceDirectionDetails(String? placeId, context) async {
//
//   showDialog(
//       context: context,
//       builder: (BuildContext context) => ProgressDialog(
//         message: "Setting up drop off.Please wait",
//
//       )
//   );
//
//   String placeDirectionDetailsurl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId& key=$mapKey";
//
//   var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsurl);
//   Navigator.pop(context);
//   if(responseApi == "Error occurred. no response."){
//     return;
//   }
//   if(responseApi['status'] == 'OK'){
//     Directions directions = Directions();
//     directions.locationName = responseApi['result']['name'];
//     directions.locationId= placeId;
//     directions.locationLatitude= responseApi['result']['geometry']['location']['lat'];
//     directions.locationLongitude= responseApi['result']['geometry']['location']['lng'];
//
//     Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);
//
//     setState(() {
//       userDropOffAddress = directions.locationName!;
//     });
//
//     Navigator.pop(context, 'obtainDropOff');
//   }
//
//
// }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return ElevatedButton(
      onPressed: (){
        // onTilePressed(widget.predictedPlaces);
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);

      },
      style: ElevatedButton.styleFrom(
        primary: darkTheme ? Colors.black : Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,

            ),
            SizedBox(width:10 ,),
            Expanded(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.predictedPlaces!.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: darkTheme? Colors.amber.shade400 : Colors.blue,

                      ),
                    ),

                    Text(
                      widget.predictedPlaces!.secondary_text!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: darkTheme? Colors.amber.shade400 : Colors.blue,

                      ),
                    ),
                  ],
                ) )
          ],
        ),
      ),
    );
  }
}
