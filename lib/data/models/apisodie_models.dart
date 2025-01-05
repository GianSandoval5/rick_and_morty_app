class Episode {
  final String id;
  final String name;
  final String airDate;
  final String episodeCode;

  Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episodeCode,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      airDate: json['air_date'],
      episodeCode: json['episode'],
    );
  }
}
