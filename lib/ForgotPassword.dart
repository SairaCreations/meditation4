import 'package:meditation4/Service/Auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meditation4/SignInPage.dart';
import 'package:meditation4/widgets/youtube_frame.dart';

import 'HomePage.dart';
import 'SignUpPage.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Saira Creations Concentration Videos'),
          //  actions: const [VideoPlaylistIconButton()],

          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              //onPressed: () => Navigator.of(context).pop())),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => SignInPage()),
                  (route) => false)),
        ),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      textItem("Email....", _emailController, false),
                      //textItem("Email....", _emailController, false),
                      const SizedBox(
                        height: 15,
                      ),

                      colorButton(),
                      const SizedBox(
                        height: 20,
                      ),
                    ]))));
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        try {
          await firebaseAuth.sendPasswordResetEmail(
              email: _emailController.text);

          setState(() {
            circular = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              //  MaterialPageRoute(builder: (builder) => HomePage()),
              MaterialPageRoute(builder: (builder) => SignInPage()),
              (route) => false);
        } catch (e) {
          /*
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });*/

          const snackbar = SnackBar(
              content: Text(
                  "If you entered a valid e-maill address and a user has registered with the entered e-mail address, a reset password link will be sent to that address"));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);

          Navigator.pushAndRemoveUntil(
              context,
              //  MaterialPageRoute(builder: (builder) => HomePage()),
              MaterialPageRoute(builder: (builder) => SignInPage()),
              (route) => false);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c)
          ]),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : const Text(
                  "Send E-mail to Reset Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }

  Widget textItem(
      String labeltext, TextEditingController controller, bool obscureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: labeltext,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
