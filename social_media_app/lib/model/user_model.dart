class Login {
  final String token;

  const Login({
    required this.token,
  });

  /*
  Desc: deserializes the result from JSON
  Params:
  - json: a Map<String, dynamic> received from response.body (the "data" part)
  Return type: factory (Login())
  */
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      token: json["token"],
    );
  }
}

class User {
  final String firstName;
  final String lastName;
  final int date;
  final int updated;

  User({
    required this.firstName,
    required this.lastName,
    required this.date,
    required this.updated,
  });

  /*
  Desc: maps the data of json
  Params:
  - json: a Map<String, dynamic> received from response.body (the "data" part)
  Return type: factory (Post())
  */
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      firstName: json["firstName"],
      lastName: json["lastName"],
      date: json["date"],
      updated: json["updated"],
    );
  }

  /*
  Desc: deserializes the result from JSON
  Params:
  - json: a Map<String, dynamic> received from response.body (the "data" part)
  Return type: factory (User())
  */
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json["firstName"],
      lastName: json["lastName"],
      date: json["date"],
      updated: json["updated"],
    );
  }
}
