import 'dart:convert';

class User {
  final String? name;
  final String username;
  final String? bio;
  final String? location;
  final String avatarUrl;
  final int publicRepos;
  final int followers;
  final int following;
  final String profileLink;
  User({
    this.name,
    required this.username,
    this.bio,
    this.location,
    required this.avatarUrl,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.profileLink,
  });

  User copyWith({
    String? name,
    String? username,
    String? bio,
    String? location,
    String? avatarUrl,
    int? publicRepos,
    int? followers,
    int? following,
    String? profileLink,
  }) {
    return User(
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      publicRepos: publicRepos ?? this.publicRepos,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profileLink: profileLink ?? this.profileLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'login': username,
      'bio': bio,
      'location': location,
      'avatar_url': avatarUrl,
      'public_repos': publicRepos,
      'followers': followers,
      'following': following,
      'html_url': profileLink,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] != null ? map['name'] as String : null,
      username: map['login'] as String,
      bio: map['bio'] != null ? map['bio'] as String : null,
      location: map['location'] != null ? map['location'] as String : null,
      avatarUrl: map['avatar_url'] as String,
      publicRepos: map['public_repos'] as int,
      followers: map['followers'] as int,
      following: map['following'] as int,
      profileLink: map['html_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, username: $username, bio: $bio, location: $location, avatar: $avatarUrl, publicRepositoryCount: $publicRepos, followersCount: $followers, followingCount: $following, profileLink: $profileLink)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.username == username &&
      other.bio == bio &&
      other.location == location &&
      other.avatarUrl == avatarUrl &&
      other.publicRepos == publicRepos &&
      other.followers == followers &&
      other.following == following &&
      other.profileLink == profileLink;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      username.hashCode ^
      bio.hashCode ^
      location.hashCode ^
      avatarUrl.hashCode ^
      publicRepos.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      profileLink.hashCode;
  }
}
