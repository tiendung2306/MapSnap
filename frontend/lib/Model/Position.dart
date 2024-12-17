class Position {
  final double longitude; // Tọa độ kinh độ
  final double latitude;  // Tọa độ vĩ độ
  final int createdAt;    // Thời gian tạo (timestamp)
  final String locationId; // ID vị trí
  final String userId;    // ID người dùng
  final String? address;  // Địa chỉ (tùy chọn)
  final String? country;  // Quốc gia (tùy chọn)
  final String? city;     // Thành phố (tùy chọn)
  final String? district; // Quận/huyện (tùy chọn)
  final String? homeNumber; // Số nhà (tùy chọn)
  final String? id;       // ID của đối tượng (tùy chọn)

  Position({
    required this.longitude,
    required this.latitude,
    required this.createdAt,
    required this.locationId,
    required this.userId,
    this.address,
    this.country,
    this.city,
    this.district,
    this.homeNumber,
    this.id,
  });

  // Phương thức từ JSON
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      longitude: json['longitude'],
      latitude: json['latitude'],
      createdAt: 10, //error
      locationId: json['locationId'],
      userId: json['userId'],
      address: json['address'],
      country: json['country'],
      city: json['city'],
      district: json['district'],
      homeNumber: json['homeNumber'] != null ? json['homeNumber'] : null,
      id: json['id'],
    );
  }

  // Phương thức chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'createdAt': createdAt,
      'locationId': locationId,
      'userId': userId,
      'address': address,
      'country': country,
      'city': city,
      'district': district,
      'homeNumber': homeNumber,
      'id': id,
    };
  }
}
