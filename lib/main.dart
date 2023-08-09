import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geojson/geojson.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application
  late MapboxMapController controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello world project',
      home: Scaffold(
        appBar: AppBar(title: Text('Hello World App')),
        body: MapboxMap(
          accessToken: 'sk.eyJ1IjoicmFodWwwN3NoYXJtYSIsImEiOiJjbGt1bzMyNnYwMGRyM2xwZHJuMXF2OTMzIn0.hojM5Wqzbm-fXmMzbSHlag',
          styleString: 'mapbox://styles/rahul07sharma/cll0j2fu1009i01pd0q8n8b61',
          initialCameraPosition: const CameraPosition(
            target: LatLng(12.86711, 77.1947171),
            zoom: 3
          ),
            onMapCreated:_onMapCreated,
          onStyleLoadedCallback: _onStyleLoadedCallback,
        )
      ),
    );
  }
  void _onMapCreated(MapboxMapController controller) {
    print("inside _onMapCreated function");
    this.controller = controller;
    // controller.addGeoJsonSource("points", _points);
    // controller.addSource("newLayer", GeojsonSourceProperties(data: _points, lineMetrics: true, tolerance: 0.5));
    // controller.addGeoJsonSource("moving", _movingFeature(0));
    // controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    controller.onFeatureTapped.add(onFeatureTap);
  }
  void onFeatureTap(dynamic featureId, Point<double> point, LatLng latLng) {
    print("inside onFeatureTap function");
    print('Tapped feature with id $featureId');
    final snackBar = SnackBar(
      content: Text(
        'Tapped feature with id $featureId',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void _onStyleLoadedCallback() async {
    print("inside _onStyleLoadedCallback function");
    // controller.addLayer('IND_rds-0cmtd5','7249');
    await controller.addGeoJsonSource("points", _points);
    await controller.addSource("lines", GeojsonSourceProperties(data: _lines));
    await controller.addSource("newLayer", GeojsonSourceProperties(data: _points));
    // // controller.addGeoJsonSource("moving", _movingFeature(0));
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));
    // await controller.addLine(_points as LineOptions);
    await controller.addLayer("point", 'layerId', LineLayerProperties(
        lineColor: Colors.red.toHexStringRGB(),
        lineWidth: [
          Expressions.interpolate,
          ["linear"],
          [Expressions.zoom],
          11.0,
          2.0,
          20.0,
          10.0
        ]));
    // await controller.addFillLayer(
    //   "fills",
    //   "fills",
    //   FillLayerProperties(fillColor: [
    //     Expressions.interpolate,
    //     ['exponential', 0.5],
    //     [Expressions.zoom],
    //     11,
    //     'red',
    //     18,
    //     'green'
    //   ], fillOpacity: 0.4),
    //   belowLayerId: "water",
    //   filter: ['==', 'id', filteredId],
    // );

    // await controller.addLineLayer(
    //   "fills",
    //   "lines",
    //   LineLayerProperties(
    //
    //       lineColor: Colors.yellow.toHexStringRGB(),
    //       lineWidth: [
    //         Expressions.interpolate,
    //         ["linear"],
    //         [Expressions.zoom],
    //         11.0,
    //         2.0,
    //         20.0,
    //         10.0
    //       ]),
    // );

    await controller.addCircleLayer(
      "fills",
      "circles",
      CircleLayerProperties(
        circleRadius: 30,
        circleColor: Colors.yellow.toHexStringRGB(),

      ),
    );
    await controller.addLineLayer('lines', 'line', LineLayerProperties(
      lineColor: Colors.red.toHexStringRGB(),
      lineWidth: 3,
      lineCap: 'round'
    ));
    await controller.addFillLayer('lines', 'fill', FillLayerProperties(
      fillColor: Colors.blue,
    ));
    await controller.addSymbolLayer(
      "points",
      "symbols",
      SymbolLayerProperties(
        iconImage: "assets/symbols/3.0x/custom-icon.png",
        iconColor: Colors.red.toHexStringRGB(),
        iconSize: 4,
        iconAllowOverlap: true,
      ),
    );

    // await controller.addSymbolLayer(
    //   "moving",
    //   "moving",
    //   SymbolLayerProperties(
    //     textField: [Expressions.get, "name"],
    //     textHaloWidth: 1,
    //     textSize: 10,
    //     textHaloColor: Colors.white.toHexStringRGB(),
    //     textOffset: [
    //       Expressions.literal,
    //       [0, 2]
    //     ],
    //     iconImage: "bicycle-15",
    //     iconSize: 2,
    //     iconAllowOverlap: true,
    //     textAllowOverlap: true,
    //   ),
    //   minzoom: 11,
    // );

  }
}
final _fills = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [
          [
            29.820491307509343,
            6.91343080763252
          ],
          [
            28.505379352263915,
            82.68052296588712,
          ]
        ],
        "type": "LineString"
      }
    }
  ]
};

const _points = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [
          [
            29.820491307509343,
            67.91343080763252
          ],
          [
            28.505379352263915,
            82.68052296588712
          ]
        ],
        "type": "LineString"
      }
    }
  ]
};

const  _lines = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [
          [
            72.38479864986056,
            25.255702433372292
          ],
          [
            81.10373553302406,
            25.11360865768485
          ]
        ],
        "type": "LineString"
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [
          [
            [
              75.00857863683154,
              20.0866239230064
            ],
            [
              70.58010984088611,
              21.664675364862532
            ],
            [
              75.12161148031396,
              16.403309969850454
            ],
            [
              79.19835652034885,
              18.377440545801235
            ],
            [
              85.09871504719655,
              22.391800940382552
            ],
            [
              79.59203378605946,
              24.082306158717202
            ],
            [
              75.4225950035748,
              23.242578246715183
            ],
            [
              75.00857863683154,
              20.0866239230064
            ]
          ]
        ],
        "type": "Polygon"
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [
          [
            [
              76.60286835487102,
              16.061414427280525
            ],
            [
              76.60286835487102,
              14.122409984879368
            ],
            [
              79.35865831521176,
              14.122409984879368
            ],
            [
              79.35865831521176,
              16.061414427280525
            ],
            [
              76.60286835487102,
              16.061414427280525
            ]
          ]
        ],
        "type": "Polygon"
      }
    },
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "coordinates": [
          [
            67.91343080763252,
            29.820491307509343
          ],
          [
            82.68052296588712,
            28.505379352263915
          ]
        ],
        "type": "LineString"
      }
    }
  ]
};

Map<String, dynamic> _movingFeature(double t) {
  List<double> makeLatLong(double t) {
    final angle = t * 2 * pi;
    const r = 0.025;
    const center_x = 151.1849;
    const center_y = -33.8748;
    return [
      center_x + r * sin(angle),
      center_y + r * cos(angle),
    ];
  }

  return {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "properties": {"name": "POGAČAR Tadej"},
        "id": 10,
        "geometry": {"type": "Point", "coordinates": makeLatLong(t)}
      },
      {
        "type": "Feature",
        "properties": {"name": "VAN AERT Wout"},
        "id": 11,
        "geometry": {"type": "Point", "coordinates": makeLatLong(t + 0.15)}
      },
    ]
  };
}


