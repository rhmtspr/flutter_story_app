class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double lat;
  final double lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      createdAt:
          json['createAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
