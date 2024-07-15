import 'package:firebase_auth_bloc/blocs/cubits/signin/signin_cubit.dart';
import 'package:firebase_auth_bloc/utils/error_dialog.dart';
import 'package:firebase_auth_bloc/views/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? email, password;

  void _submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = key.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    print('Email: $email, Password: $password');
    context.read<SigninCubit>().signIn(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus,
        child:
            BlocConsumer<SigninCubit, SigninState>(listener: (context, state) {
          if (state.signinStatus == SigninStatus.error) {
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
                    ElevatedButton(
                      onPressed: state.signinStatus == SigninStatus.submitting
                          ? null
                          : _submit,
                      child: state.signinStatus == SigninStatus.submitting
                          ? Text('Loading')
                          : Text('Sign in'),
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
                      onPressed: state.signinStatus == SigninStatus.submitting
                          ? null
                          : () {
                              Navigator.pushNamed(
                                  context, SignUpScreen.routeName);
                            },
                      child: Text(
                        'Not a member? Sign up!',
                        style: TextStyle(
                            fontSize: 20, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        }),
      ),
    );
  }
}
