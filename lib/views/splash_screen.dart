import 'package:firebase_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth_bloc/views/home_screen.dart';
import 'package:firebase_auth_bloc/views/sign_in_screen.dart';
import 'package:firebase_auth_bloc/views/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        print("Builder: $state");
        return Scaffold(
          body: CircularProgressIndicator(),
        );
      },
      listener: (context, state) {
        print("Listener: $state");
        if (state.authStatus == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName,
              (route) {
            print("route.settings.name: ${route.settings.name}");
            print(
                "route.settings.name: ${ModalRoute.of(context)!.settings.name}");
            return route.settings.name == ModalRoute.of(context)!.settings.name
                ? true
                : false;
          });
        } else if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.pushNamed(context, SignInScreen.routeName);
        }
      },
    );
  }
}
