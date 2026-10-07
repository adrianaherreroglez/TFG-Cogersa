class Friend {
  final int id;
  final String username;
  final int? requestId;

  Friend({
    required this.id,
    required this.username,
    this.requestId,
  });

  factory Friend.fromJson(
    Map<String, dynamic> json,
  ) {
    return Friend(
      id: json['id'],
      username: json['username'],
      requestId: json['requestId'],
    );
  }
}
