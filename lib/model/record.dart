import 'dart:convert';

class Record {
  final String id;
  final String name;
  final String author;
  final String audio;
  final String url;
  final DateTime created_at;
  final DateTime update_at;

  Record({
    this.id,
    this.name,
    this.url,
    this.author,
    this.audio,
    this.created_at,
    this.update_at,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "author":author,
        "audio":audio,
        "created_at":created_at.toIso8601String(),
        "update_at":update_at.toIso8601String(),
      };

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      name: json['name'],
      audio: json['audio'],
      url: json['url'],
      author: json['author'],
      created_at: DateTime.parse(json['created_at']),
      update_at: DateTime.parse(json['update_at']),
    );
  }
}
