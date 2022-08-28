import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:good_tymes/api/nominatim.dart';
import 'package:good_tymes/components/address_search.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/models/address.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
    required this.setAddress,
    required this.initialAddress,
  }) : super(key: key);

  final Function setAddress;
  final Address initialAddress;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _diplayName;
  LatLng? _coordinates;

  bool _isLoading = false;
  bool _isSaving = false;

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });
      //final locData = await Location().getLocation();
      setState(() {
        //_coordinates = LatLng(locData.latitude!, locData.longitude!);
        _coordinates = LatLng(4.583280, 101.093727);
        _isLoading = false;
      });
    } catch (e) {
      return;
    }
  }

  void _setCoordinates(double lat, double lon) {
    setState(() {
      _coordinates = LatLng(lat, lon);
    });
  }

  @override
  void initState() {
    if (widget.initialAddress.type == 'default') {
      _getCurrentLocation();
    } else {
      _diplayName = widget.initialAddress.displayName;
      _coordinates = LatLng(
        widget.initialAddress.latitude,
        widget.initialAddress.longitude,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/app/leaflet_js.png',
          width: size.width / 3,
          fit: BoxFit.cover,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.cancel,
            color: Colors.black54,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: AddressSearch(_setCoordinates),
              );
              setState(() {
                _diplayName = result;
              });
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black54,
            ),
          )
        ],
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Colors.green,
            child: IconButton(
              icon: const Icon(Icons.my_location),
              color: Colors.black54,
              iconSize: 28.0,
              onPressed: _getCurrentLocation,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: const Color.fromARGB(255, 51, 150, 54),
        child: InkWell(
          onTap: () async {
            setState(() {
              _isSaving = true;
            });
            // Obtain Address from Coordinates
            final latitude = _coordinates!.latitude;
            final longitude = _coordinates!.longitude;
            final address = await reverseAddress(latitude, longitude);
            widget.setAddress(
              Address(
                displayName: address,
                latitude: latitude,
                longitude: longitude,
              ),
            );
            setState(() {
              _isSaving = false;
            });
            if (!mounted) return;
            Navigator.of(context).pop();
          },
          child: SizedBox(
            height: kToolbarHeight,
            child: Center(
              child: !_isSaving
                  ? Text(
                      getText(context).save,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    onTap: (tapPos, latLng) {
                      setState(() {
                        _coordinates = latLng;
                      });
                    },
                    center: _coordinates,
                    zoom: 17,
                    rotation: 0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          point: _coordinates as LatLng,
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.location_pin),
                            color: Colors.red,
                            iconSize: 30.0,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
