import 'package:flutter/material.dart';
import 'signup.dart';
import '../network_helper/user_network_helper.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username =
      TextEditingController(); // controller for getting username
  final TextEditingController _password =
      TextEditingController(); // controller for getting password
  final _formKey = GlobalKey<FormState>();

  final bool _validate = false; // used for validation of input
  bool userError = false;

  UserNetworkHelper network = UserNetworkHelper();

  /*
  Desc: Describes the login page and functionalities
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
                      buildTextField('Enter username', _username, false),
                      const SizedBox(height: 10), // just add space in between
                      buildTextField('Enter password', _password, true),
                      const SizedBox(height: 10),
                      userError
                          ? Text("Incorrect username or password",
                              style: TextStyle(
                                color: Color.fromARGB(255, 241, 3, 3),
                              ))
                          : Text(""),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildLoginButton(),
                          buildSignupButton(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  /*
  Desc: creates a textfield widget that will be used to get username and passsword
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
  Desc: Creates the login button
  Params: None
  Return type: widget (ElevatedButton)
  */
  Widget buildLoginButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: const Color.fromARGB(221, 0, 0, 0),
            primary: const Color.fromARGB(255, 255, 255, 255),
            minimumSize: const Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 16)),
        child: const Text(
          'LOGIN',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var data = await network.login(_username.text, _password.text);

            if (data == "user doesn't exists" ||
                data == "password is incorrect") {
              setState(() {
                userError = true;
              });
            } else {
              setState(() {
                userError = false;
              });
              await ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Loggedin Successfully!'),
                    duration: Duration(milliseconds: 500)),
              );

              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                          title: "Home",
                          token: data,
                          username: _username.text)));

              //clear text on controllers after successful insert of data to database
              _username.clear();
              _password.clear();

              FocusScope.of(context).unfocus(); // unfocus input fields
            }
          }
        });
  }

  /*
  Desc: creates the signup button
  Params: None
  Return type: widget (ElevatedButton)
  */
  Widget buildSignupButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          onPrimary: const Color.fromARGB(221, 0, 0, 0),
          primary: const Color.fromARGB(255, 255, 255, 255),
          minimumSize: const Size(88, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16)),
      onPressed: () {
        // // navigate to ShowTasksPage that contains list of tasks from the database
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const SignupPage(title: "Register New User")));
      },
      child: const Text(
        "SIGNUP",
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }
}
