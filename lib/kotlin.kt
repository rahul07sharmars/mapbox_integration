package com.example.hazardtrees

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.CallLog.Locations.LATITUDE
import android.provider.CallLog.Locations.LONGITUDE
import android.widget.Toast
import androidx.annotation.DrawableRes
import androidx.appcompat.content.res.AppCompatResources
import com.example.hazardtrees.databinding.ActivityMapboxBinding
import com.mapbox.android.gestures.MoveGestureDetector
import com.mapbox.common.location.compat.permissions.PermissionsManager
import com.mapbox.geojson.Point
import com.mapbox.maps.CameraOptions

import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.Style
import com.mapbox.maps.extension.style.expressions.dsl.generated.all
import com.mapbox.maps.extension.style.expressions.dsl.generated.color
import com.mapbox.maps.extension.style.expressions.dsl.generated.eq
import com.mapbox.maps.extension.style.expressions.dsl.generated.get
import com.mapbox.maps.extension.style.expressions.dsl.generated.interpolate
import com.mapbox.maps.extension.style.expressions.dsl.generated.match
import com.mapbox.maps.extension.style.expressions.dsl.generated.properties
import com.mapbox.maps.extension.style.layers.generated.circleLayer
import com.mapbox.maps.extension.style.layers.generated.fillLayer
import com.mapbox.maps.extension.style.layers.generated.lineLayer
import com.mapbox.maps.extension.style.layers.properties.generated.LineCap
import com.mapbox.maps.extension.style.layers.properties.generated.LineJoin
import com.mapbox.maps.extension.style.sources.generated.geoJsonSource
import com.mapbox.maps.extension.style.sources.generated.vectorSource
import com.mapbox.maps.extension.style.style
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.animation.CameraAnimatorType
import com.mapbox.maps.plugin.annotation.annotations
import com.mapbox.maps.plugin.annotation.generated.PointAnnotationOptions
import com.mapbox.maps.plugin.annotation.generated.createCircleAnnotationManager
import com.mapbox.maps.plugin.annotation.generated.createPointAnnotationManager
import com.mapbox.maps.plugin.gestures.OnMoveListener
import com.mapbox.maps.plugin.gestures.gestures
import com.mapbox.maps.plugin.locationcomponent.OnIndicatorBearingChangedListener
import com.mapbox.maps.plugin.locationcomponent.OnIndicatorPositionChangedListener
import com.mapbox.maps.plugin.locationcomponent.location
import java.lang.ref.WeakReference


class MapboxActivity : AppCompatActivity() {
    private lateinit var locationPermissionHelper: LocationPermissionHelper

    private lateinit var mapView: MapView

    private val onIndicatorBearingChangedListener = OnIndicatorBearingChangedListener {
        mapView.getMapboxMap().setCamera(CameraOptions.Builder().bearing(it).build())
    }
    private val onIndicatorPositionChangedListener = OnIndicatorPositionChangedListener {
        mapView.getMapboxMap().setCamera(CameraOptions.Builder().center(it).build())
        mapView.gestures.focalPoint = mapView.getMapboxMap().pixelForCoordinate(it)
    }
    private val onMoveListener = object : OnMoveListener {
        override fun onMoveBegin(detector: MoveGestureDetector) {
            onCameraTrackingDismissed()
        }

        override fun onMove(detector: MoveGestureDetector): Boolean {
            return false
        }

        override fun onMoveEnd(detector: MoveGestureDetector) {}
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding: ActivityMapboxBinding = ActivityMapboxBinding.inflate(layoutInflater)
        setContentView(binding.root)
        mapView = MapView(this)
        setContentView(mapView)
        mapView.getMapboxMap().setCamera(
            CameraOptions.Builder().center(
                Point.fromLngLat(
                    LATITUDE,
                    LONGITUDE
                )
            ).zoom(ZOOM).build()
        )
        mapView.getMapboxMap().loadStyle(
            (
                    style(styleUri =Style.MAPBOX_STREETS ) {
                        +vectorSource(SOURCE_ID){
                            url("mapbox://mapbox.country-boundaries-v1")
                        }

                        +fillLayer("country_boundaries", SOURCE_ID) {
                            sourceLayer("country_boundaries")

                            fillColor("#659")
                            filter(

                                all {
//                                    eq {  get { literal("id") }
//                                        literal(65998863)}
                                    eq {  get { literal("name") }
                                        literal("Åland Islands")}
                                    eq {  get { literal("name_en") }
                                        literal("Åland Islands")}
                                    eq {  get { literal("color_group") }
                                        literal(4)}
                                    eq {  get { literal("disputed") }
                                        literal(false)}
//                                    eq {  get { literal("wikidata_id") }
//                                        literal("Q5689")}
//                                    eq {  get { literal("iso_3166_1") }
//                                        literal("AX")}
//                                    eq {  get { literal("iso_3166_alpha_3") }
//                                        literal("ALA")}
//                                    eq {  get { literal("mapbox_id") }
//                                        literal("dXJu0m1ieGJuZDpBKzhRRHc6djQ")}
//                                    eq {  get { literal("region") }
//                                        literal("Europe")}
//                                    eq {  get { literal("subregion") }
//                                        literal("Northern Europe")}
//                                    eq {  get { literal("worldview") }
//                                        literal("all")}


                                },

                            )


                        }

                    }
                    )

        )


//        locationPermissionHelper = LocationPermissionHelper(WeakReference(this))
//        locationPermissionHelper.checkPermissions {
//            onMapReady()
//        }
    }
    companion object {
        private const val  SOURCE_ID = "mapbox.country-boundaries-v1"
        private const val LATITUDE = -122.486052
        private const val LONGITUDE = 37.830348
        private val ZOOM :Double?= 4.0
    }
    private fun addAnnotationToMap() {
// Create an instance of the Annotation API and get the PointAnnotationManager.
        bitmapFromDrawableRes(
            this@MapboxActivity,
            R.drawable.red_marker
        )?.let {
            val annotationApi = mapView?.annotations
            val pointAnnotationManager = annotationApi?.createPointAnnotationManager()
// Set options for the resulting symbol layer.
            val pointAnnotationOptions: PointAnnotationOptions = PointAnnotationOptions()
// Define a geographic coordinate.
                .withPoint(Point.fromLngLat(77.60 ,13.00))
// Specify the bitmap you assigned to the point annotation
// The bitmap will be added to map style automatically.
                .withIconImage(it)
                .withDraggable(true)
// Add the resulting pointAnnotation to the map.
            pointAnnotationManager?.create(pointAnnotationOptions)
        }
    }



//    val annotationApi = mapView?.annotations
//    val circleAnnotationManager = annotationApi?.createCircleAnnotationManager(mapView)
//    // Set options for the resulting circle layer.
//    val circleAnnotationOptions: CircleAnnotationOptions = CircleAnnotationOptions()
//        // Define a geographic coordinate.
//        .withPoint(Point.fromLngLat(18.06, 59.31))
//        // Style the circle that will be added to the map.
//        .withCircleRadius(8.0)
//        .withCircleColor("#ee4e8b")
//        .withCircleStrokeWidth(2.0)
//        .withCircleStrokeColor("#ffffff")
//// Add the resulting circle to the map.
//    circleAnnotationManager?.create(circleAnnotationOptions)




//    val annotationApi = mapView?.annotations
//    polylineAnnotationManager = annotationApi.createPolylineAnnotationManager(mapView)
//    // Define a list of geographic coordinates to be connected.
//    val points = listOf(
//        Point.fromLngLat(17.94, 59.25),
//        Point.fromLngLat(18.18, 59.37)
//    )
//    // Set options for the resulting line layer.
//    val polylineAnnotationOptions: PolylineAnnotationOptions = PolylineAnnotationOptions()
//        .withPoints(points)
//        // Style the line that will be added to the map.
//        .withLineColor("#ee4e8b")
//        .withLineWidth(5.0)
//// Add the resulting line to the map.
//    polylineAnnotationManager?.create(polylineAnnotationOptions)


//    val annotationApi = mapView?.annotations
//    val polygonAnnotationManager = annotationApi?.createPolygonAnnotationManager(mapView)
//    // Define a list of geographic coordinates to be connected.
//    val points = listOf(
//        listOf(
//            Point.fromLngLat(17.94, 59.25),
//            Point.fromLngLat(18.18, 59.25),
//            Point.fromLngLat(18.18, 59.37),
//            Point.fromLngLat(17.94, 59.37)
//        )
//    )
//    // Set options for the resulting fill layer.
//    val polygonAnnotationOptions: PolygonAnnotationOptions = PolygonAnnotationOptions()
//        .withPoints(points)
//        // Style the polygon that will be added to the map.
//        .withFillColor("#ee4e8b")
//        .withFillOpacity(0.4)
//// Add the resulting polygon to the map.
//    polygonAnnotationManager?.create(polygonAnnotationOptions)

    private fun bitmapFromDrawableRes(context: Context, @DrawableRes resourceId: Int) =
        convertDrawableToBitmap(AppCompatResources.getDrawable(context, resourceId))

    private fun convertDrawableToBitmap(sourceDrawable: Drawable?): Bitmap? {
        if (sourceDrawable == null) {
            return null
        }
        return if (sourceDrawable is BitmapDrawable) {
            sourceDrawable.bitmap
        } else {
// copying drawable object to not manipulate on the same reference
            val constantState = sourceDrawable.constantState ?: return null
            val drawable = constantState.newDrawable().mutate()
            val bitmap: Bitmap = Bitmap.createBitmap(
                drawable.intrinsicWidth, drawable.intrinsicHeight,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            bitmap
        }
    }
    private fun onMapReady() {
        mapView.getMapboxMap().setCamera(
            CameraOptions.Builder()
                .zoom(14.0)
                .build()
        )
        mapView.getMapboxMap().loadStyleUri(
            Style.MAPBOX_STREETS

        ) {
            initLocationComponent()
            setupGesturesListener()
        }
    }
    private fun setupGesturesListener() {
        mapView.gestures.addOnMoveListener(onMoveListener)
    }
    private fun initLocationComponent() {
        val locationComponentPlugin = mapView.location
        locationComponentPlugin.updateSettings {
            this.enabled = true
            this.pulsingEnabled=true
        }
        locationComponentPlugin.addOnIndicatorPositionChangedListener(onIndicatorPositionChangedListener)
        locationComponentPlugin.addOnIndicatorBearingChangedListener(onIndicatorBearingChangedListener)
    }
    private fun onCameraTrackingDismissed() {
        Toast.makeText(this, "onCameraTrackingDismissed", Toast.LENGTH_SHORT).show()
        mapView.location
            .removeOnIndicatorPositionChangedListener(onIndicatorPositionChangedListener)
        mapView.location
            .removeOnIndicatorBearingChangedListener(onIndicatorBearingChangedListener)
        mapView.gestures.removeOnMoveListener(onMoveListener)
    }
    override fun onDestroy() {
        super.onDestroy()
        mapView.location
            .removeOnIndicatorBearingChangedListener(onIndicatorBearingChangedListener)
        mapView.location
            .removeOnIndicatorPositionChangedListener(onIndicatorPositionChangedListener)
        mapView.gestures.removeOnMoveListener(onMoveListener)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        locationPermissionHelper.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }


}