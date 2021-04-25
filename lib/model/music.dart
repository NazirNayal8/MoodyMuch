class Music {
  final String title;
  final String artist;
  final String imagePath;
  final Duration duration;
  final String openUrl;
  final String previewUrl;

  Music(
    this.title,
    this.artist,
    this.imagePath,
    this.duration,
    this.openUrl,
    this.previewUrl
  );

  Music.fromJson(Map<String,dynamic> json)
    : title = json["name"],
      artist = json["artists"][0]["name"],
      imagePath = json["album"]["images"][0]["url"],
      duration = Duration(milliseconds:  json["duration_ms"]),
      openUrl = json["external_urls"]["spotify"],
      previewUrl = json["preview_url"];
}