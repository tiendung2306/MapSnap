class ForwardGeocoding {
  String formatted_address;
  double lat;
  double lng;
  String name;


  ForwardGeocoding({
    required this.formatted_address,
    required this.lat,
    required this.lng,
    required this.name,

  });

  factory ForwardGeocoding.fromJson(Map<String, dynamic> json) {
    return ForwardGeocoding(
      formatted_address: json['results'][0]['formatted_address'],
      lat: json['results'][0]['geometry']['location']['lat'],
      lng: json['results'][0]['geometry']['location']['lng'],
      name: json['results'][0]['name'],
    );
  }
}