// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FireBaseUser {
  final String email;
  final String name;
  final String profilepic;

  const FireBaseUser({
    required this.email,
    required this.name,
    required this.profilepic,
  });

  FireBaseUser copyWith({
    String? email,
    String? name,
    String? profilepic,
  }) {
    return FireBaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilepic: profilepic ?? this.profilepic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilepic': profilepic,
    };
  }

  factory FireBaseUser.fromMap(Map<String, dynamic> map) {
    return FireBaseUser(
      email: map['email'] as String,
      name: map['name'] as String,
      profilepic: map['profilepic'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FireBaseUser.fromJson(String source) =>
      FireBaseUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FireBaseUser(email: $email, name: $name, profilepic: $profilepic)';

  @override
  bool operator ==(covariant FireBaseUser other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.profilepic == profilepic;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ profilepic.hashCode;
}
