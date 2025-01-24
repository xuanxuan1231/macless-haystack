import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class LocationPopup extends Marker {
  /// The location to display.
  final LatLng location;

  /// The time stamp the location was recorded.
  final DateTime time;
  final DateTime end;
  final BuildContext ctx;

  /// Displays a small popup window with the coordinates at [location] and
  /// the [time] in a human readable format.
  LocationPopup(
      {super.key,
      required this.location,
      required this.time,
      required this.end,
      required this.ctx})
      : super(
          width: 200,
          height: 150,
          point: location,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: InkWell(
              onTap: () {
                /* NOOP */
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        '${DateFormat('MM/dd H:mm', Localizations.localeOf(ctx).toString()).format(time.toLocal())} - ${DateFormat('MM/dd H:mm', Localizations.localeOf(ctx).toString()).format(end.toLocal())}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '纬度：${location.round(decimals: 2).latitude}， '
                        '经度：${location.round(decimals: 2).longitude}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          rotate: true,
        );
}
