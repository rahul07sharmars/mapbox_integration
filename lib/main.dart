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
    this.controller = controller;

    // controller.onFeatureTapped.add(onFeatureTap);
  }
  void onFeatureTap(dynamic featureId, Point<double> point, LatLng latLng) {
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
    await controller.addGeoJsonSource("points", _points);
    await controller.addGeoJsonSource("moving", _movingFeature(0));
    await controller.addSource("fills", GeojsonSourceProperties(data: _fills));

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

    await controller.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
          lineColor: Colors.lightBlue.toHexStringRGB(),
          lineWidth: [
            Expressions.interpolate,
            ["linear"],
            [Expressions.zoom],
            11.0,
            2.0,
            20.0,
            10.0
          ]),
    );

    await controller.addCircleLayer(
      "fills",
      "circles",
      CircleLayerProperties(
        circleRadius: 4,
        circleColor: Colors.blue.toHexStringRGB(),
      ),
    );

    await controller.addSymbolLayer(
      "points",
      "symbols",
      SymbolLayerProperties(
        iconImage: "{type}-15",
        iconSize: 2,
        iconAllowOverlap: true,
      ),
    );

    await controller.addSymbolLayer(
      "moving",
      "moving",
      SymbolLayerProperties(
        textField: [Expressions.get, "name"],
        textHaloWidth: 1,
        textSize: 10,
        textHaloColor: Colors.white.toHexStringRGB(),
        textOffset: [
          Expressions.literal,
          [0, 2]
        ],
        iconImage: "bicycle-15",
        iconSize: 2,
        iconAllowOverlap: true,
        textAllowOverlap: true,
      ),
      minzoom: 11,
    );

  }
}
final _fills = {
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "id": 0, // web currently only supports number ids
      "properties": <String, dynamic>{'id': 0},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [151.178099204457737, -33.901517742631846],
            [151.179025547977773, -33.872845324482071],
            [151.147000529140399, -33.868230472039514],
            [151.150838238009328, -33.883172899638311],
            [151.14223647675135, -33.894158309528244],
            [151.155999294764086, -33.904812805307806],
            [151.178099204457737, -33.901517742631846]
          ],
          [
            [151.162657925954278, -33.879168932438581],
            [151.155323416087612, -33.890737666431583],
            [151.173659690754278, -33.897637567778119],
            [151.162657925954278, -33.879168932438581]
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "id": 1,
      "properties": <String, dynamic>{'id': 1},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [51.18735077583878, -33.891143558434102],
            [11.197374605989864, -33.878357032551868],
            [151.213021560372084, -33.886475683791488],
            [151.204953599518745, -33.899463918807818],
            [151.18735077583878, -33.891143558434102]
          ]
        ]
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


