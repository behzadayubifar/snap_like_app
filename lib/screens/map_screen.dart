import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:snap_like_app/constants/dimens.dart';
import 'package:snap_like_app/constants/styles.dart';
import 'package:snap_like_app/gen/assets.gen.dart';
import 'package:snap_like_app/widgets/my_back_button.dart';

class CurrentWidgetStates {
  CurrentWidgetStates._();

  static const stateSelectOrigin = 0;
  static const stateSelectDestination = 1;
  static const stateRequestDriver = 2;
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<GeoPoint> geoPoints = [];
  String distance = "در حال محاسبۀ فاصله ...";
  String originAddress = "آدرس مبدا";
  String destAddress = "آدرس مقصد";
  List currentWidgetList = [CurrentWidgetStates.stateSelectDestination];

  Widget markerIcon = SvgPicture.asset(
    Assets.icons.origin,
    height: 100,
    width: 40,
  );

  Widget originIcon = SvgPicture.asset(
    Assets.icons.origin,
    height: 100,
    width: 40,
  );

  Widget destIcon = SvgPicture.asset(
    Assets.icons.destination,
    height: 100,
    width: 40,
  );

  MapController mapController = MapController(
    initMapWithUserPosition: UserTrackingOption.withoutUserPosition(),
    // initPosition: GeoPoint(latitude: 35.6892, longitude: 51.3890),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Osm Map
            SizedBox.expand(
              child: OSMFlutter(
                controller: mapController,
                mapIsLoading: const SpinKitCircle(color: Colors.black),
                osmOption: OSMOption(
                  markerOption: MarkerOption(
                      advancedPickerMarker: MarkerIcon(
                    iconWidget: markerIcon,
                  )),
                  isPicker: true,
                  zoomOption: const ZoomOption(
                    stepZoom: 1,
                    initZoom: 15,
                    minZoomLevel: 8,
                    maxZoomLevel: 18,
                  ),
                ),
              ),
            ),

            // current widget
            currentWidget(),

            // back button
            MyBackButton(
              onPressed: () {
                switch (currentWidgetList.last) {
                  case CurrentWidgetStates.stateSelectOrigin:
                    break;
                  case CurrentWidgetStates.stateSelectDestination:
                    geoPoints.removeLast();
                    markerIcon = originIcon;
                    break;
                  case CurrentWidgetStates.stateRequestDriver:
                    mapController.advancedPositionPicker();
                    mapController.removeMarker(geoPoints.last);
                    geoPoints.removeLast();
                    markerIcon = destIcon;
                    break;
                }

                if (geoPoints.isNotEmpty) {
                  geoPoints.removeLast();
                  markerIcon = originIcon;
                }

                if (currentWidgetList.length > 1) {
                  setState(() {
                    currentWidgetList.removeLast();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget currentWidget() {
    Widget widget = origin();

    switch (currentWidgetList.last) {
      case CurrentWidgetStates.stateSelectDestination:
        widget = origin();
        break;
      case CurrentWidgetStates.stateRequestDriver:
        widget = reqDriver();
        break;
    }
    return widget;
  }

  Positioned origin() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: ElevatedButton(
          onPressed: () async {
            GeoPoint originGeoPoint =
                await mapController.getCurrentPositionAdvancedPositionPicker();
            geoPoints.add(originGeoPoint);

            markerIcon = destIcon;

            setState(() {
              currentWidgetList.add(CurrentWidgetStates.stateSelectOrigin);
            });
          },
          child: Text(
            "انتخاب مبدا",
            style: MyTextStyles.button,
          ),
        ),
      ),
    );
  }

  Positioned dest() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: ElevatedButton(
          onPressed: () async {
            await mapController
                .getCurrentPositionAdvancedPositionPicker()
                .then((destCoordinate) => geoPoints.add(destCoordinate));

            mapController.cancelAdvancedPositionPicker();

            await mapController.addMarker(geoPoints.first,
                markerIcon: MarkerIcon(
                  iconWidget: originIcon,
                ));

            await mapController.addMarker(geoPoints.last,
                markerIcon: MarkerIcon(
                  iconWidget: destIcon,
                ));

            setState(() {
              currentWidgetList.add(CurrentWidgetStates.stateSelectDestination);
            });

            await distance2point(geoPoints[0], geoPoints[1]).then((result) {
              setState(() {
                if (result < 1000) {
                  distance = "فاصلۀ مبدا تا مقصد ${result.toInt()} متر";
                } else {
                  distance = "فاصلۀ مبدا تا مقصد ${result ~/ 1000} کیلومتر";
                }
              });
            });

            getAddress();
          },
          child: Text(
            "انتخاب مقصد",
            style: MyTextStyles.button,
          ),
        ),
      ),
    );
  }

  Positioned reqDriver() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.large),
        child: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.medium),
                color: Colors.white,
              ),
              child: Text(distance),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  currentWidgetList.add(CurrentWidgetStates.stateRequestDriver);
                }),
                child: Text(
                  "درخواست راننده",
                  style: MyTextStyles.button,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  currentWidgetList.add(CurrentWidgetStates.stateRequestDriver);
                }),
                child: Text(
                  "مبدا : $originAddress",
                  style: MyTextStyles.button,
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => setState(() {
                  currentWidgetList.add(CurrentWidgetStates.stateRequestDriver);
                }),
                child: Text(
                  "مقصد : $destAddress",
                  style: MyTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getAddress() async {
    try {
      await placemarkFromCoordinates(
              geoPoints.first.latitude, geoPoints.first.longitude,
              localeIdentifier: "fa")
          .then((List<Placemark> placeList) {
        setState(() {
          originAddress =
              "${placeList.first.locality} ${placeList.first.thoroughfare} ${placeList[2].name}";
        });
      });
      await placemarkFromCoordinates(
              geoPoints.last.latitude, geoPoints.last.longitude,
              localeIdentifier: "fa")
          .then((List<Placemark> placeList) {
        setState(() {
          destAddress =
              "${placeList.first.locality} ${placeList.first.thoroughfare} ${placeList[2].name}";
        });
      });
    } catch (e) {
      originAddress = "آدرس مبدا یافت نشد";
      destAddress = "آدرس مقصد یافت نشد";
    }
  }
}
