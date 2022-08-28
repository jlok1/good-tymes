import 'package:good_tymes/models/address.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Address>> getAddresses(String q) async {
  try {
    List<Address> addresses = [];
    var url =
        'https://nominatim.openstreetmap.org/search?q=${q.replaceAll(' ', '+')}&format=json&countrycodes=MY&limit=10';
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    for (var j in json) {
      addresses.add(
        Address(
          displayName: j['display_name'] as String,
          latitude: double.parse(j['lat']),
          longitude: double.parse(j['lon']),
        ),
      );
    }
    return addresses;
  } catch (e) {
    //print(e.toString());
    return [];
  }
}

Future<String> reverseAddress(double lat, double lon) async {
  try {
    var url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lon';
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    return json['display_name'];
  } catch (e) {
    return '';
  }
}
