import 'package:flutter_test/flutter_test.dart';
import 'package:social_media_app/network_helper/user_network_helper.dart';

void main() {
  String token = "";
  String newUserName =
      "newUserName7"; // make sure this username does not exist yet

  test('Testing signup', () async {
    // setup
    UserNetworkHelper network = UserNetworkHelper();
    // do
    await network.signup(newUserName, "juan2345", "Juan", "Dela Cruz");

    // test
    expect(network.testOutput, true);
  });

  test('Testing login', () async {
    // setup
    UserNetworkHelper network = UserNetworkHelper();
    // do
    token = await network.login(newUserName, "juan2345");

    // test
    expect(network.testOutput, true);
  });

  test('Testing view profile', () async {
    // setup
    UserNetworkHelper network = UserNetworkHelper();
    // do
    await network.viewprofile(token, newUserName);

    // test
    expect(network.testOutput, true);
  });

  test('Testing update name', () async {
    // setup
    UserNetworkHelper network = UserNetworkHelper();
    // do
    await network.updateName(token, newUserName, "Juanito", "Manuel");
    // test
    expect(network.testOutput, true);
  });

  test('Testing update password', () async {
    // setup
    UserNetworkHelper network = UserNetworkHelper();
    // do
    await network.updatePassword(
        token, newUserName, "juan2345", "juan2345678910");

    // test
    expect(network.testOutput, true);
  });

  test('Testing logout', () async {
    // setup
    UserNetworkHelper network = UserNetworkHelper();
    // do
    await network.logout(token);

    // test
    expect(network.testOutput, true);
  });
}
