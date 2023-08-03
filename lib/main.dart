import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:latlong2/latlong.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MapboxMap(
        minMaxZoomPreference: MinMaxZoomPreference(7,13),
        styleString: 'mapbox://styles/rahul07sharma/clktkvaqb00co01o2dntb8xqk',
        // 'https://api.mapbox.com/styles/v1/rahul07sharma/clktkvaqb00co01o2dntb8xqk/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicmFodWwwN3NoYXJtYSIsImEiOiJjbGtzYmN6NnMwMDF6M2hvYTRvb2FwdDI2In0.7tSwDDTzzWIx1VhtYbfvNQ',
        myLocationEnabled:true,
        accessToken: 'sk.eyJ1IjoicmFodWwwN3NoYXJtYSIsImEiOiJjbGt1bzMyNnYwMGRyM2xwZHJuMXF2OTMzIn0.hojM5Wqzbm-fXmMzbSHlag',
        initialCameraPosition: const CameraPosition(
          target: LatLng(12.972442, 77.580643),
          zoom:10,
          tilt:60,
        ),
          annotationOrder:[AnnotationType.symbol,
            ]
      ),

      // MapboxOverlay(
        // controller: MapboxOverlayController(),
        // options: MapboxMapOptions(
        //   style: Style.dark,
        //   camera: new CameraPosition(
        //       target: LatLng(lat: 52.376316, lng: 4.897801),
        //       zoom: 15.0,
        //       bearing: 0.0,
        //       tilt: 0.0),
        // ),

    );
  }
}

