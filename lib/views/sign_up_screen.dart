import 'package:firebase_auth_bloc/blocs/cubits/signup/signup_cubit.dart';
import 'package:firebase_auth_bloc/utils/error_dialog.dart';
import 'package:firebase_auth_bloc/views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password, name;
  final passwordController = TextEditingController();

  void _submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = key.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    print('Name: $name,Email: $email, Password: $password');
    context
        .read<SignupCubit>()
        .signUp(name: name!, email: email!, password: password!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: BlocConsumer<SignupCubit, SignupState>(listener: (context, state) {
        if (state.signupStatus == SignupStatus.error) {
          errorDialog(context, state.error);
        }
      }, builder: (context, state) {
        return Scaffold(
          body: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: key,
              autovalidateMode: autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                reverse: true,
                children: [
                  Image.asset(
                    'assets/images/flutter_logo.png',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.account_box),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      name = newValue;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!isEmail(value.trim())) {
                        return 'Enter a valid email';
                      }

                      return null;
                    },
                    onSaved: (newValue) {
                      email = newValue;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      password = newValue;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (passwordController.text != value) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      password = newValue;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: state.signupStatus == SignupStatus.submitting
                        ? null
                        : _submit,
                    child: state.signupStatus == SignupStatus.submitting
                        ? Text('Loading')
                        : Text('Sign up'),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: state.signupStatus == SignupStatus.submitting
                        ? null
                        : () {
                            Navigator.pushNamed(
                                context, SignInScreen.routeName);
                          },
                    child: Text(
                      'Already have account? Sign in!',
                      style: TextStyle(
                          fontSize: 20, decoration: TextDecoration.underline),
                    ),
                  ),
                ].reversed.toList(),
              ),
            ),
          )),
        );
      }),
    );
  }
}
