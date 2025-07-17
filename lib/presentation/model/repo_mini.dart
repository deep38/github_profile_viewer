// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RepoMini {
  final String name;
  final String? description;
  final String visibility;
  final int stars;
  final int forks;
  final DateTime updatedAt;
  RepoMini({
    required this.name,
    this.description,
    required this.visibility,
    required this.stars,
    required this.forks,
    required this.updatedAt,
  });

  RepoMini copyWith({
    String? name,
    String? description,
    String? visibility,
    int? stars,
    int? forks,
    DateTime? updatedAt,
  }) {
    return RepoMini(
      name: name ?? this.name,
      description: description ?? this.description,
      visibility: visibility ?? this.visibility,
      stars: stars ?? this.stars,
      forks: forks ?? this.forks,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'visibility': visibility,
      'stargazers_count': stars,
      'forks': forks,
      'updated_at': updatedAt.toString(),
    };
  }

  factory RepoMini.fromMap(Map<String, dynamic> map) {
    return RepoMini(
      name: map['name'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      visibility: map['visibility'] as String,
      stars: map['stargazers_count'] as int,
      forks: map['forks'] as int,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory RepoMini.fromJson(String source) => RepoMini.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RepoMini(name: $name, description: $description, visibility: $visibility, stars: $stars, forks: $forks, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant RepoMini other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.description == description &&
      other.visibility == visibility &&
      other.stars == stars &&
      other.forks == forks &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      description.hashCode ^
      visibility.hashCode ^
      stars.hashCode ^
      forks.hashCode ^
      updatedAt.hashCode;
  }
}
