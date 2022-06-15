import 'dart:async';

import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' hide Location;

class LocationService {
  final Location location = Location();
  PermissionStatus? _permissionStatus;
  bool? _serviceEnabled;

  Future _checkPermissions() async {
    final PermissionStatus status = await location.hasPermission();
    _permissionStatus = status;
    print(status.toString());
  }

  Future<void> _requestPermissions() async {
    if(_permissionStatus != PermissionStatus.granted){
      final PermissionStatus status = await location.requestPermission();
      _permissionStatus = status;
    }
  }

  Future<void> _checkService() async {
    final bool service = await location.serviceEnabled();
    _serviceEnabled = service;
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == false){
      location.requestService();
    }
  }

  Future<dynamic> _getLocation() async {
    try {
      await _checkPermissions();
      await _requestPermissions();
      final LocationData _locResult = await location.getLocation();
      return _locResult;
    } on PlatformException catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getTheNameOfTheCurrentLocation() async {
    try {
      LocationData coordinates = await _getLocation();
      List<Placemark> address = await placemarkFromCoordinates(coordinates.latitude!, coordinates.longitude!);
      return '${address[0].name} ${address[0].locality}, ${address[0].country}';
    } catch (e) {
      print(e.toString());
    }
  }

}

