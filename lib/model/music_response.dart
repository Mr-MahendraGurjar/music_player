class MusicResponse {
  List<Music>? music;

  MusicResponse({this.music});

  MusicResponse.fromJson(Map<String, dynamic> json) {
    if (json['music'] != null) {
      music = <Music>[];
      json['music'].forEach((v) {
        music!.add(Music.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (music != null) {
      data['music'] = music!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Music {
  String? id;
  String? title;
  String? album;
  String? artist;
  String? genre;
  String? source;
  String? image;
  int? trackNumber;
  int? totalTrackCount;
  int? duration;
  String? site;

  Music(
      {this.id,
        this.title,
        this.album,
        this.artist,
        this.genre,
        this.source,
        this.image,
        this.trackNumber,
        this.totalTrackCount,
        this.duration,
        this.site});

  Music.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    album = json['album'];
    artist = json['artist'];
    genre = json['genre'];
    source = json['source'];
    image = json['image'];
    trackNumber = json['trackNumber'];
    totalTrackCount = json['totalTrackCount'];
    duration = json['duration'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['album'] = album;
    data['artist'] = artist;
    data['genre'] = genre;
    data['source'] = source;
    data['image'] = image;
    data['trackNumber'] = trackNumber;
    data['totalTrackCount'] = totalTrackCount;
    data['duration'] = duration;
    data['site'] = site;
    return data;
  }
}
