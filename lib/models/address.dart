import 'dart:convert';

class Address {
  Address({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.type = 'default',
  });

  final String displayName;
  final double latitude;
  final double longitude;
  final String? type;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'latitude': latitude,
      'longitude': longitude,
      'type': type,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      displayName: map['displayName'] as String,
      latitude: double.parse(map['latitude']),
      longitude: double.parse(map['longitude']),
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return "$displayName ($latitude, $longitude)";
  }
}
