import 'package:flutter/material.dart';
import '../network_helper/user_network_helper.dart';
import '../model/user_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});
  final String title;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // controllers for inputs
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _password2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final bool _validate = false; //used for validation of input
  String userError = "none";

  UserNetworkHelper network = UserNetworkHelper();

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
        ),
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("images/bg2.jpg"),
              fit: BoxFit.fill,
            )),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildTextField('Enter firstname', _firstName, false),
                      const SizedBox(height: 10), // just add space in between
                      buildTextField('Enter lastname', _lastName, false),
                      const SizedBox(height: 10),
                      buildTextField('Enter username', _username, false),
                      const SizedBox(height: 10),
                      buildTextField('Enter password', _password, true),
                      const SizedBox(height: 10),
                      buildTextField('Retype password', _password2, true),
                      const SizedBox(height: 10),
                      userError == "mismatch"
                          ? Text("Passwords do not match",
                              style: TextStyle(
                                color: Color.fromARGB(255, 241, 3, 3),
                              ))
                          : userError == "exists"
                              ? Text("User already exists",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 241, 3, 3),
                                  ))
                              : Text(""),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildRegisterButton(),
                          buildCancelButton(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  /*
  Desc: creates a textfield widget that will be used to get user details
  Params: 
    - label: a String type used to determine the label of the input field
    - _controller: a TextEditingController type to handle user inputs in the texfields
    - pw: a bool type used to determine if the textfield is for the passwords or not (if true, the text will be obscured)
  Return type: widget (TextFormField)
  */
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
  Desc: Creates the register button
  Params: None
  Return type: widget (ElevatedButton)
  */
  Widget buildRegisterButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: const Color.fromARGB(221, 0, 0, 0),
            primary: const Color.fromARGB(255, 255, 255, 255),
            minimumSize: const Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16)),
        child: const Text(
          'REGISTER',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_password.text == _password2.text) {
              User data = await network.signup(_username.text, _password.text,
                  _firstName.text, _lastName.text);
              print(data.firstName);

              if (data.firstName == "") {
                setState(() {
                  userError = "exists";
                });
              } else {
                setState(() {
                  userError = "none";
                });
                await ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Registered Successfully!'),
                      duration: Duration(milliseconds: 500)),
                );
                // clear texts on controllers after successful insert of data to database
                _firstName.clear();
                _lastName.clear();
                _username.clear();
                _password.clear();
                _password2.clear();
                FocusScope.of(context).unfocus(); // unfocus input fields
                Navigator.of(context).pop();
              }
            } else {
              print("password not match");
              setState(() {
                userError = "mismatch";
              });
            }
          }
        });
  }

  /*
  Desc: Creates the cancel button (cancel signup)
  Params: None
  Return type: widget (ElevatedButton)
  */
  Widget buildCancelButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          onPrimary: const Color.fromARGB(221, 0, 0, 0),
          primary: const Color.fromARGB(255, 255, 255, 255),
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16)),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        "CANCEL",
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }
}
