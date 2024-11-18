import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/services/utils.dart';
import 'package:weather_dashboard/widgets/text_widget.dart';

import '../controllers/MenuController.dart';

class EmailSubscriptionScreen extends StatefulWidget {
  const EmailSubscriptionScreen({super.key});

  @override
  State<EmailSubscriptionScreen> createState() =>
      _EmailSubscriptionScreenState();
}

class _EmailSubscriptionScreenState extends State<EmailSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _subscribe() async {
    if (await _checkEmailVerified()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          text:
              'Successfully subscribed, you will receive the latest weather updates from us.',
          color: Colors.white,
        ),
      ));
    } else if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: 'temporaryPassword123',
        );

        User? user = userCredential.user;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification email sent!')),
          );
        }
      } on FirebaseAuthException catch (e) {
        print(("Error when verify email: ${e.message}"));
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    const emailPattern = r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<bool> _checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    // Reload to get the latest user state
    await user?.reload();
    if (user != null && user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email has been verified!')),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent!')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Utils(context).color;
    return Scaffold(
      key: context.read<CustomMenuController>().getgridscaffoldKey,
      appBar: AppBar(
        title: TextWidget(
          text: "Subscribe to Notifications",
          isTitle: true,
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: color,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _subscribe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: TextWidget(
                      text: "Subscribe",
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
