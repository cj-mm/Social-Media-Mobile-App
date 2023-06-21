class Post {
  final String id;
  final String text;
  final String username;
  final bool public;
  final int date;
  final int updated;

  const Post({
    required this.id,
    required this.text,
    required this.username,
    required this.public,
    required this.date,
    required this.updated,
  });

  /*
  Desc: maps the data of json
  Params:
  - json: a Map<String, dynamic> received from response.body (the "data" part)
  Return type: factory (Post())
  */
  factory Post.fromMap(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      text: json["text"],
      username: json["username"],
      public: json["public"],
      date: json["date"],
      updated: json["updated"],
    );
  }

  /*
  Desc: deserializes the result from JSON
  Params:
  - json: a Map<String, dynamic> received from response.body (the "data" part)
  Return type: factory (Post())
  */
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      text: json["text"],
      username: json["username"],
      public: json["public"],
      date: json["date"],
      updated: json["updated"],
    );
  }
}
