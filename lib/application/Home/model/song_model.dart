import 'dart:core';

class Song {
  final String name;
  final String link;
  final bool isFavorite;
  final String id;
  final String artist;
  final String coverUrl;

  Song({
    required this.name,
    required this.link,
    required this.isFavorite,
    required this.id,
    required this.artist,
    required this.coverUrl,
  });
}
