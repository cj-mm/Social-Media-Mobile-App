import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../network_helper/post_network_helper.dart';
import '../network_helper/user_network_helper.dart';
import '../model/post_model.dart';
import '../model/user_model.dart';
import 'profile.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {Key? key,
      required this.title,
      required this.token,
      required this.username})
      : super(key: key);
  final String title;
  final String token;
  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _postcreate =
      TextEditingController(); //controller for getting created post
  final TextEditingController _edit =
      TextEditingController(); //controller for getting edited post
  final _formKey = GlobalKey<FormState>();
  String newEditValue = ""; // will hold the updated post
  String editTextFieldValue = ""; // for handling the edit text field
  final bool _validate = false; //used for validation of input

  var tempPublicityCreate = "Public";
  var tempPublicityUpdate = "Public";
  var publicityOptions = ["Public", "Friends"]; // publicity options

  // create helper objects to access network functions
  late PostNetworkHelper network = PostNetworkHelper(widget.token);
  late UserNetworkHelper network2 = UserNetworkHelper();

  // create a future list of posts that will store all the post data from the network
  late Future<List<Post>> myPost;
  late Future<User> userDetails;

  /*
  Desc: called once when this Stateful Widget is inserted in the widget tree
  Params: none
  Return type: void
  */
  @override
  void initState() {
    super.initState();

    // initialize myPost list by getting data from the network
    myPost = network.posts();
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
              icon: const Icon(Icons.account_circle_rounded,
                  color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                            title: "Profile",
                            token: widget.token,
                            username: widget.username,
                            loggedusername: widget.username)));
              },
              tooltip: 'Profile',
            ),
            IconButton(
              icon: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () async {
                await network2.logout(widget.token);

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
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/bg2.jpg"),
              fit: BoxFit.cover,
            )),
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Flexible(
                            child: buildTextField(
                                'What\'s on your mind?', _postcreate)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildPublicDropdown(15, true, tempPublicityCreate),
                            buildPostButton(),
                          ],
                        ),
                      ],
                    ),
                    myPostList(), // list of Posts
                  ],
                ),
              ),
            )));
  }

  /*
  Desc: creates a textfield widgets that will be used to get input/edited post
  Params: 
    - label: a String type used to determine the label of the input field
    - _controller: a TextEditingController type to handle user inputs in the texfields
  Return type: widget (TextFormField)
  */
  Widget buildTextField(String label, TextEditingController _controller) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 27.0, horizontal: 10.0),
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
        //validates if value in controller/textfield is not empty
        if (value == null || value.isEmpty) {
          return 'Please do not leave the textfield empty';
        }
        return null;
      },
    );
  }

  /*
  Desc: Creates the post button (for adding a post)
  Params: None
  Return type: widget (ElevatedButton)
  */
  Widget buildPostButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: const Color.fromARGB(221, 0, 0, 0),
          primary: Color.fromARGB(255, 214, 134, 134),
          minimumSize: const Size(80, 30),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        child: const Text(
          'POST',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final List postsList = await myPost;
            var newPost = await network.createPost(
                _postcreate.text, tempPublicityCreate == "Public");

            setState(() {
              // update the gui
              postsList.insert(
                  0,
                  Post(
                      id: newPost.id,
                      text: newPost.text,
                      username: newPost.username,
                      public: newPost.public,
                      date: newPost.date,
                      updated: newPost.updated));
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Processing Data'),
                  duration: Duration(milliseconds: 500)),
            );
            // clear text on controllers after successful insert of data to database
            _postcreate.clear();
            FocusScope.of(context).unfocus(); // unfocus input fields
          }
        });
  }

  /*
  Desc: creates a dropdown for post publicity (Public or Friends)
  Params: 
  - fontSize: a double the determines the fontsize of the labels
  - newPost: a bool to determine if the dropdown is for creating post or editing post (they have different styles)
  - initVal: a String that serves as the default value of the dropdown
  Return type: widget (DropdownButton)
  */
  Widget buildPublicDropdown(double fontSize, bool newPost, String initVal) {
    return DropdownButton(
      value: initVal,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: publicityOptions.map((String sz) {
        return DropdownMenuItem(
          value: sz,
          child: Text(
            sz,
            style: TextStyle(
                color: Color.fromARGB(255, 48, 46, 46),
                fontSize: fontSize,
                fontWeight: FontWeight.w600),
          ),
        );
      }).toList(),
      onChanged: (String? newPublicity) {
        // use tempPublicity for it to be displayed only in the size section and not in the order summary
        setState(() {
          if (newPost) {
            tempPublicityCreate = newPublicity!;
          } else {
            tempPublicityUpdate = newPublicity!;
          }
        });
      },
    );
  }

  /*
  Desc: gets the list of posts from a future
  Params: None
  Return type: widget (Expanded) 
  */
  Widget myPostList() {
    return Expanded(
      child: FutureBuilder(
          future: myPost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildText(snapshot.data as List<Post>);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(
                child:
                    CircularProgressIndicator(value: null, strokeWidth: 7.0));
          }),
    );
  }

  /*
  Desc: creates the modal used for editing a post
  Params:
  - context: a BuildContext to handle the location in the widget tree
  - postIdx: an int to determine the id of the post to be edited
  Return type: Future<void>
  */
  Future<void> editModal(BuildContext context, int postIdx) async {
    final List postsList = await myPost; // get the list of postss
    tempPublicityUpdate = postsList[postIdx].public ? "Public" : "Friends";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Post'),
                buildPublicDropdown(10, false, tempPublicityUpdate),
              ],
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  editTextFieldValue = value;
                });
              },
              controller: _edit
                ..text = postsList[postIdx]
                    .text, // the initial value is the original post title
              decoration: const InputDecoration(hintText: "Edit Post"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  newEditValue = editTextFieldValue;
                  print(newEditValue);
                  if (newEditValue != "") {
                    var updatedPost = await network.updatePost(
                        newEditValue,
                        tempPublicityUpdate == "Public",
                        postsList[postIdx]
                            .id); // update a post in the network (put request)
                    setState(() {
                      // update also the gui
                      postsList[postIdx] = Post(
                          id: updatedPost.id,
                          text: newEditValue,
                          username: updatedPost.username,
                          public: tempPublicityUpdate == "Public",
                          date: updatedPost.date,
                          updated: updatedPost.updated);
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  /*
  Desc: creates listview of myPost (List of Post) data
  Params:
  - myPost: a List<Post> containing all the public and user posts
  Return type: widget (ListView.builder)
  */
  Widget buildText(List<Post> myPost) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: myPost.length,
      itemBuilder: (context, int index) {
        userDetails =
            network2.viewprofile(widget.token, myPost[index].username);

        bool _checked = myPost[index].public;
        return (myPost[index].username == widget.username || _checked)
            ? Center(
                child: Card(
                  // wrap in card for styling
                  margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color.fromARGB(144, 255, 255, 255),
                  child: ListTile(
                    selected: _checked,
                    contentPadding: const EdgeInsets.only(left: 10),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FutureBuilder<User>(
                                  future: userDetails,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(
                                                  255, 44, 43, 43)),
                                          children: [
                                            TextSpan(
                                                text: snapshot.data!.firstName +
                                                    " " +
                                                    snapshot.data!.lastName,
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProfilePage(
                                                                  title:
                                                                      "Profile",
                                                                  token: widget
                                                                      .token,
                                                                  username: myPost[
                                                                          index]
                                                                      .username,
                                                                  loggedusername:
                                                                      widget
                                                                          .username)))),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('${snapshot.error}');
                                    }
                                    return Text("....");
                                  }),
                              Text(
                                  getDate(myPost[index].date) +
                                      (myPost[index].public
                                          ? " | Public"
                                          : " | Friends"),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 97, 96, 96))),
                            ]),
                        Wrap(
                          spacing: -18, // space between edit and delete icons
                          children: myPost[index].username == widget.username
                              ? <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color:
                                            Color.fromARGB(255, 79, 65, 204)),
                                    onPressed: () {
                                      editModal(context, index);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color:
                                            Color.fromARGB(255, 167, 46, 38)),
                                    onPressed: () async {
                                      await network
                                          .deletePost(myPost[index].id);
                                      setState(() {
                                        // delete also from the gui
                                        myPost.removeAt(
                                            index); // remove post in the UI without reloading
                                      });
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Successfully Deleted"),
                                              duration:
                                                  Duration(milliseconds: 500)));
                                    },
                                  ),
                                ]
                              : <Widget>[],
                        ),
                      ],
                    ),
                    subtitle: Text(myPost[index].text,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0))),
                  ),
                ),
              )
            : Center();
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
