import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(1)
  final String accesToken;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final String secret;
  const User({
    required this.accesToken,
    required this.userId,
    required this.secret,
  });

  factory User.fromMap(Map<dynamic, dynamic> map) {
    return User(
      accesToken: map['access_token'] as String,
      userId: map['user_id'].toString(),
      secret: map['secret'] as String,
    );
  }

  @override
  String toString() =>
      'User(accesToken: $accesToken, userId: $userId, secret: $secret)';
}
