import 'package:firebase_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth_bloc/repositories/auth_repository.dart';
import 'package:firebase_auth_bloc/views/profile_screen.dart';
import 'package:firebase_auth_bloc/views/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Home"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ));
              },
              icon: Icon(Icons.account_circle),
            ),
            IconButton(
              onPressed: () async {
                context.read<AuthBloc>().add(SignoutRequestedEvent());
                // Navigator.pushNamed(context, SignInScreen.routeName);
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bloc_logo_full.png',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Bloc is awesome\nstate management library\nfor flutter!',
              style: TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        )),
      ),
    );
  }
}
