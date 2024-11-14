class Picture {
  String id;
  String user_id;
  String location_id;
  String visit_id;
  String journey_id;
  String link;
  DateTime created_at;

  Picture({
    required this.id,
    required this.user_id,
    required this.location_id,
    required this.visit_id,
    required this.journey_id,
    required this.link,
    required this.created_at,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
        id: json['id'],
        user_id: json['user_id'],
        location_id: json['location_id'],
        visit_id: json['visit_id'],
        journey_id: json['journey_id'],
        link: json['link'],
        created_at: json['created_at']
    );
  }
}

class CreatePicture {
  String user_id;
  String location_id;
  String visit_id;
  String journey_id;
  String link;
  DateTime created_at;

  CreatePicture({
    required this.user_id,
    required this.location_id,
    required this.visit_id,
    required this.journey_id,
    required this.link,
    required this.created_at,
  });

  factory CreatePicture.fromJson(Map<String, dynamic> json) {
    return CreatePicture(
        user_id: json['user_id'],
        location_id: json['location_id'],
        visit_id: json['visit_id'],
        journey_id: json['journey_id'],
        link: json['link'],
        created_at: json['createdAt']
    );
  }
}