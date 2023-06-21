import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../network_helper/user_network_helper.dart';
import '../model/user_model.dart';
import 'home.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(
      {super.key,
      required this.title,
      required this.token,
      required this.username,
      required this.loggedusername});
  final String title;
  final String token;
  final String username;
  final String loggedusername;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserNetworkHelper network = UserNetworkHelper();
  late Future<User> userDetails;
  final TextEditingController _editFN = TextEditingController();
  final TextEditingController _editLN = TextEditingController();
  final TextEditingController _newPw = TextEditingController();
  final TextEditingController _newPw2 = TextEditingController();
  final TextEditingController _pw2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String newEditValue = ""; // for handling the edit text field
  String editFirstName = ""; // for handling the edit text field
  String editLastName = ""; // for handling the edit text field
  String password = ""; // for handling the edit text field
  final bool _validate = false; //used for validation of input
  String userError = "";
  String fullname = "";

  /*
  Desc: called once when this Stateful Widget is inserted in the widget tree
  Params: none
  Return type: void
  */
  @override
  void initState() {
    super.initState();
    userDetails = network.viewprofile(widget.token, widget.username);
  }

  /*
  Desc: Describes the signup page and functionalities
  Params:
  - context: a BuildContext to handle the location in the widget tree
  Return type: widget (Scaffold)
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        leading: const Icon(Icons.graphic_eq_rounded,
            color: Color.fromARGB(255, 255, 255, 255)),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            title: "Home",
                            token: widget.token,
                            username: widget.loggedusername,
                          )));
            },
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () async {
              await network.logout(widget.token);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage(title: "Social Media App")));
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body:
          // each part/section (some are just Text, some in container) in My Profile is a child in this list view
          Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/bg2.jpg"),
          fit: BoxFit.fill,
        )),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color.fromARGB(0, 255, 255, 255),
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(children: <Widget>[
                    const Text(
                      "NAME",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 85, 9, 4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Use container to modify the margin
                    Container(
                      child: FutureBuilder<User>(
                          future: userDetails,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              fullname = snapshot.data!.firstName +
                                  " " +
                                  snapshot.data!.lastName;
                              return Text(
                                fullname,
                                // snapshot.data!.firstName + " " + snapshot.data!.lastName,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Text("....");
                          }),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "DATE CREATED",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 85, 9, 4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: FutureBuilder<User>(
                          future: userDetails,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                getDate(snapshot.data!.date).toString(),
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Text("....");
                          }),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "DATE UPDATED",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 85, 9, 4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: FutureBuilder<User>(
                          future: userDetails,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                getDate(snapshot.data!.updated).toString(),
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return Text("....");
                          }),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              widget.username == widget.loggedusername
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 38, 35, 235),
                              decoration: TextDecoration.underline,
                            ),
                            children: [
                              TextSpan(
                                  text: "Edit Name",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        (editNameModal(context, "Edit Name"))),
                            ],
                          ),
                        )),
                        Text("   |   "),
                        Container(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 38, 35, 235),
                                decoration: TextDecoration.underline,
                              ),
                              children: [
                                TextSpan(
                                    text: "Edit Password",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => (editPasswordModal(
                                          context, "Edit Password"))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ]),
          ),
        ),
      ),
    );
  }

  /*
  Desc: creates the modal/dialog for name editing
  Params:
  - context: a BuildContext to handle the location in the widget tree
  - title: a String title for the modal
  Return type: Future<void>
  */
  Future<void> editNameModal(BuildContext context, String title) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
              ],
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildTextField("Enter New Firstname", _editFN, false),
                    const SizedBox(height: 10),
                    buildTextField("Enter New Lastname", _editLN, false),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                  _editFN.clear();
                  _editLN.clear();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await network.updateName(
                        widget.token,
                        widget.loggedusername,
                        _editFN.text,
                        _editLN
                            .text); // update a user's name in the network (put request)

                    setState(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => this.widget));
                      // Navigator.pop(context);
                    });

                    await ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Updated Successfully!'),
                          duration: Duration(milliseconds: 500)),
                    );

                    _editFN.clear();
                    _editLN.clear();
                  }
                  // newEditValue = editFirstName;
                  // print(newEditValue);
                  // if (newEditValue != "") {
                  //   setState(() {
                  //     // update also the gui
                  //   });
                  // }
                },
              ),
            ],
          );
        });
  }

  /*
  Desc: creates the modal/dialog for password editing
  Params:
  - context: a BuildContext to handle the location in the widget tree
  - title: a String title for the modal
  Return type: Future<void>
  */
  Future<void> editPasswordModal(BuildContext context, String title) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title),
                  ],
                ),
                content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        buildTextField("Enter New Password", _newPw, true),
                        const SizedBox(height: 10),
                        buildTextField("Retype New Password", _newPw2, true),
                        const SizedBox(height: 10),
                        buildTextField("Enter Password", _pw2, true),
                        const SizedBox(height: 10),
                        userError != "success"
                            ? Text(userError,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 241, 3, 3),
                                ))
                            : Text(""),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });

                      _newPw.clear();
                      _newPw2.clear();
                      _pw2.clear();
                    },
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_newPw.text == _newPw2.text) {
                          String updatedPasswordUser = await network.updatePassword(
                              widget.token,
                              widget.loggedusername,
                              _pw2.text,
                              _newPw
                                  .text); // update a user's password in the network (put request)

                          if (updatedPasswordUser != "success") {
                            setState(() {
                              userError = updatedPasswordUser;
                            });
                          } else {
                            setState(() {
                              Navigator.pop(context);
                            });

                            await ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Updated Successfully!'),
                                  duration: Duration(milliseconds: 500)),
                            );

                            _newPw.clear();
                            _newPw2.clear();
                            _pw2.clear();
                          }
                        } else {
                          print("password not match");
                          setState(() {
                            userError = "New passwords do not match";
                          });
                        }
                      }
                      // newEditValue = editFirstName;
                      // print(newEditValue);
                      // if (newEditValue != "") {
                      //   setState(() {
                      //     // update also the gui
                      //   });
                      // }
                    },
                  ),
                ],
              );
            },
          );
        });
  }

  Widget buildTextField(
      String label, TextEditingController _controller, bool pw) {
    return TextFormField(
      obscureText: pw,
      enableSuggestions: false,
      autocorrect: false,
      controller: _controller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 22, 22, 22), width: 2),
              borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 87, 135, 238), width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          fillColor: const Color.fromARGB(43, 255, 255, 255),
          filled: true,
          labelText: label,
          errorText: _validate ? 'Value can\'t be empty' : null),
      validator: (value) {
        // validates if value in controller/textfield is not empty
        if (value == null || value.isEmpty) {
          return 'Please $label';
        }
        return null;
      },
    );
  }

  /*
  Desc: converts seconds to date
  Params:
  - timestamp: an int for the seconds to be converted
  Return type: String
  */
  String getDate(int timestamp) {
    String month =
        DateTime.fromMillisecondsSinceEpoch(timestamp).month.toString();
    String day = DateTime.fromMillisecondsSinceEpoch(timestamp).day.toString();
    String year =
        DateTime.fromMillisecondsSinceEpoch(timestamp).year.toString();
    String hour =
        DateTime.fromMillisecondsSinceEpoch(timestamp).hour.toString();
    String minute =
        DateTime.fromMillisecondsSinceEpoch(timestamp).minute.toString();

    return "$month/$day/$year $hour:$minute";
  }
}
