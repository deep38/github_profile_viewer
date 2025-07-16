// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Repository {
  final String name;
  final String fullName;
  final Owner owner;
  final bool private;
  final String htmlUrl;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime pushedAt;
  final int size;
  final int stars;
  final int watchersCount;
  final String? language;
  final String visibility;
  final int forks;
  final int openIssues;
  final int watchers;
  final int networkCount;
  final int subscribersCount;
  Repository({
    required this.name,
    required this.fullName,
    required this.owner,
    required this.private,
    required this.htmlUrl,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.pushedAt,
    required this.size,
    required this.stars,
    required this.watchersCount,
    required this.language,
    required this.visibility,
    required this.forks,
    required this.openIssues,
    required this.watchers,
    required this.networkCount,
    required this.subscribersCount,
  });

  Repository copyWith({
    String? name,
    String? fullName,
    Owner? owner,
    bool? private,
    String? htmlUrl,
    String? description,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? pushedAt,
    int? size,
    int? stars,
    int? watchersCount,
    String? language,
    String? visibility,
    int? forks,
    int? openIssues,
    int? watchers,
    int? networkCount,
    int? subscribersCount,
  }) {
    return Repository(
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      owner: owner ?? this.owner,
      private: private ?? this.private,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pushedAt: pushedAt ?? this.pushedAt,
      size: size ?? this.size,
      stars: stars ?? this.stars,
      watchersCount: watchersCount ?? this.watchersCount,
      language: language ?? this.language,
      visibility: visibility ?? this.visibility,
      forks: forks ?? this.forks,
      openIssues: openIssues ?? this.openIssues,
      watchers: watchers ?? this.watchers,
      networkCount: networkCount ?? this.networkCount,
      subscribersCount: subscribersCount ?? this.subscribersCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'full_name': fullName,
      'owner': owner.toMap(),
      'private': private,
      'html_url': htmlUrl,
      'description': description,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
      'pushed_at': pushedAt.toString(),
      'size': size,
      'stargazers_count': stars,
      'watchers_count': watchersCount,
      'language': language,
      'visibility': visibility,
      'forks': forks,
      'open_issues': openIssues,
      'watchers': watchers,
      'network_count': networkCount,
      'subscribers_count': subscribersCount,
    };
  }



  factory Repository.fromMap(Map<String, dynamic> map) {
    return Repository(
      name: map['name'] as String,
      fullName: map['full_name'] as String,
      owner: Owner.fromMap(map['owner'] as Map<String,dynamic>),
      private: map['private'] as bool,
      htmlUrl: map['html_url'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      pushedAt: DateTime.parse(map['pushed_at'] as String),
      size: map['size'].toInt() as int,
      stars: map['stargazers_count'].toInt() as int,
      watchersCount: map['watchers_count'].toInt() as int,
      language: map['language'] as String?,
      visibility: map['visibility'] as String,
      forks: map['forks'].toInt() as int,
      openIssues: map['open_issues'].toInt() as int,
      watchers: map['watchers'].toInt() as int,
      networkCount: map['network_count'].toInt() as int,
      subscribersCount: map['subscribers_count'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Repository.fromJson(String source) => Repository.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Repository(name: $name, fullName: $fullName, owner: $owner, private: $private, htmlUrl: $htmlUrl, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, pushedAt: $pushedAt, size: $size, stars: $stars, watchersCount: $watchersCount, language: $language, visibility: $visibility, forks: $forks, openIssues: $openIssues, watchers: $watchers, networkCount: $networkCount, subscribersCount: $subscribersCount)';
  }

  @override
  bool operator ==(covariant Repository other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.fullName == fullName &&
      other.owner == owner &&
      other.private == private &&
      other.htmlUrl == htmlUrl &&
      other.description == description &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.pushedAt == pushedAt &&
      other.size == size &&
      other.stars == stars &&
      other.watchersCount == watchersCount &&
      other.language == language &&
      other.visibility == visibility &&
      other.forks == forks &&
      other.openIssues == openIssues &&
      other.watchers == watchers &&
      other.networkCount == networkCount &&
      other.subscribersCount == subscribersCount;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      fullName.hashCode ^
      owner.hashCode ^
      private.hashCode ^
      htmlUrl.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      pushedAt.hashCode ^
      size.hashCode ^
      stars.hashCode ^
      watchersCount.hashCode ^
      language.hashCode ^
      visibility.hashCode ^
      forks.hashCode ^
      openIssues.hashCode ^
      watchers.hashCode ^
      networkCount.hashCode ^
      subscribersCount.hashCode;
  }
}

class Owner {
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  Owner({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  Owner copyWith({
    String? login,
    String? avatarUrl,
    String? htmlUrl,
  }) {
    return Owner(
      login: login ?? this.login,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      htmlUrl: htmlUrl ?? this.htmlUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'login': login,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      login: map['login'] as String,
      avatarUrl: map['avatar_url'] as String,
      htmlUrl: map['html_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) => Owner.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Owner(login: $login, avatarUrl: $avatarUrl, htmlUrl: $htmlUrl)';

  @override
  bool operator ==(covariant Owner other) {
    if (identical(this, other)) return true;
  
    return 
      other.login == login &&
      other.avatarUrl == avatarUrl &&
      other.htmlUrl == htmlUrl;
  }

  @override
  int get hashCode => login.hashCode ^ avatarUrl.hashCode ^ htmlUrl.hashCode;
}
