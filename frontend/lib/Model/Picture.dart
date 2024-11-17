class Picture {
  String id;
  String userId;
  String locationId;
  String visitId;
  String journeyId;
  String link;
  int capturedAt;

  Picture({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.visitId,
    required this.journeyId,
    required this.link,
    required this.capturedAt,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['id'],
      userId: json['userId'],
      locationId: json['locationId'],
      visitId: json['visitId'],
      journeyId: json['journeyId'],
      link: json['link'],
      capturedAt: json['capturedAt']
    );
  }
}

class CreatePicture {
  String userId;
  String locationId;
  String visitId;
  String journeyId;
  String link;
  DateTime capturedAt;

  CreatePicture({
    required this.userId,
    required this.locationId,
    required this.visitId,
    required this.journeyId,
    required this.link,
    required this.capturedAt,
  });

  factory CreatePicture.fromJson(Map<String, dynamic> json) {
    return CreatePicture(
        userId: json['userId'],
        locationId: json['locationId'],
        visitId: json['visitId'],
        journeyId: json['journeyId'],
        link: json['link'],
        capturedAt: json['capturedAt']
    );
  }
}