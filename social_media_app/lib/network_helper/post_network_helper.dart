import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../model/post_model.dart';

class PostNetworkHelper {
  final String token;
  bool testOutput = false;

  PostNetworkHelper(this.token);

  /*
  Desc: get all posts (get request)
  Params: None
  Return type: Future<List<Post>>
  */
  Future<List<Post>> posts() async {
    String limit = "50";

    final response = await http.get(
      Uri.parse(
          'https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post?limit=$limit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsed =
          json.decode(response.body)["data"].cast<Map<String, dynamic>>();
      testOutput = json.decode(response.body)["success"];

      return parsed.map<Post>((json) => Post.fromMap(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts.');
    }
  }

  /*
  Desc: adds a post to the network (post request)
  Params: 
  - text: a String that is the content of the created post
  - public: a bool to determine if the post is for public or friends
  Return type: Future<Post>
  */
  Future<Post> createPost(String text, bool public) async {
    final response = await http.post(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "text": text,
        "public": public,
      }),
    );

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Post.fromJson(jsonDecode(response.body)["data"]);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create post.');
    }
  }

  /*
  Desc: edits a post in the network (put request)
  Params:
  - text: a String that is the content of the edited post
  - public: a bool to determine if the post is for public or friends
  - id: a String to determine which post is edited
  Return type: Future<Post>
  */
  Future<Post> updatePost(String text, bool public, String id) async {
    final response = await http.put(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "text": text,
        "public": public,
      }),
    );

    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Post.fromJson(jsonDecode(response.body)["data"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update post.');
    }
  }

  /*
  Desc: deletes a post in the network (delete request)
  Params:
  - id: a String to determine which post will be deleted
  Return type: Future<void>
  */
  Future<void> deletePost(String id) async {
    final http.Response response = await http.delete(
      Uri.parse('https://cmsc-23-2022-bfv6gozoca-as.a.run.app/api/post/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      testOutput = json.decode(response.body)["success"];
      // If the server did return a 200 OK response,
      // then parse the JSON. After deleting,
      // we'll get an empty JSON `{}` response.
      print("successfull deleted");
    } else {
      // If the server did not return a "200 OK response",
      // then throw an exception.
      throw Exception('Failed to delete post.');
    }
  }
}
