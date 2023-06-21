import 'package:flutter_test/flutter_test.dart';
import 'package:social_media_app/network_helper/post_network_helper.dart';
import 'package:social_media_app/model/post_model.dart';
import 'package:social_media_app/network_helper/user_network_helper.dart';

void main() {
  String token = "";
  String postID = "";
  test('Testing get posts', () async {
    // setup
    UserNetworkHelper network2 = UserNetworkHelper();
    token = await network2.login("hmm", "hmm"); // login first to get token

    PostNetworkHelper network = PostNetworkHelper(token);
    // do
    await network.posts();

    // test
    expect(network.testOutput, true);
  });

  test('Testing create post', () async {
    // setup
    PostNetworkHelper network = PostNetworkHelper(token);
    // do
    Post post = await network.createPost("this is a post content", true);
    postID = post.id; // get the id of the newly created post

    // test
    expect(network.testOutput, true);
  });

  test('Testing update post', () async {
    // setup
    PostNetworkHelper network = PostNetworkHelper(token);
    // do
    await network.updatePost("this is an updated post", true, postID);

    // test
    expect(network.testOutput, true);
  });

  test('Testing delete post', () async {
    // setup
    PostNetworkHelper network = PostNetworkHelper(token);
    // do
    await network.deletePost(postID);

    // test
    expect(network.testOutput, true);
  });
}
