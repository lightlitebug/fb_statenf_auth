import 'package:fb_statenf_auth/models/custom_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../providers/providers.dart';
import '../utils/error_dialog.dart';
import 'signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);
  static const String routeName = '/signin';

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;
  // late final SigninProvider signinProv;
  // late final void Function() removeListener;

  // @override
  // void initState() {
  //   super.initState();
  //   // signinProv = context.read<SigninProvider>();
  //   print('Signin initState');
  //   if (context.read<SigninProvider>().hasListeners) {
  //     print('Have registered listeners');
  //   }
  //   if (!context.read<SigninProvider>().hasListeners) {
  //     removeListener = context.read<SigninProvider>().addListener((state) {
  //       print('Signin Status: ${state.signinStatus}');
  //       if (state.signinStatus == SigninStatus.error) {
  //         print('Signin Error');
  //         errorDialog(context, state.error);
  //       }
  //       print('end');
  //     });
  //   }
  // }

  // @override
  // void dispose() {
  //   print('Singin dispose');
  //   removeListener();
  //   super.dispose();
  // }

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('email: $_email, password: $_password');

    try {
      await context
          .read<SigninProvider>()
          .signin(email: _email!, password: _password!);
    } on CustomError catch (e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signinState = context.watch<SigninState>();

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset(
                      'assets/images/flutter_logo.png',
                      width: 250,
                      height: 250,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email required';
                        }
                        if (!isEmail(value.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _email = value;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password required';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _password = value;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : _submit,
                      child: Text(
                          signinState.signinStatus == SigninStatus.submitting
                              ? 'Loading...'
                              : 'Sign In'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextButton(
                      onPressed:
                          signinState.signinStatus == SigninStatus.submitting
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, SignupPage.routeName);
                                },
                      child: Text('Not a member? Sign up!'),
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
