import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth_bloc/blocs/cubits/profile/profile_cubit.dart';
import 'package:firebase_auth_bloc/blocs/cubits/signin/signin_cubit.dart';
import 'package:firebase_auth_bloc/blocs/cubits/signup/signup_cubit.dart';
import 'package:firebase_auth_bloc/repositories/auth_repository.dart';
import 'package:firebase_auth_bloc/repositories/profile_repository.dart';
import 'package:firebase_auth_bloc/views/home_screen.dart';
import 'package:firebase_auth_bloc/views/sign_in_screen.dart';
import 'package:firebase_auth_bloc/views/sign_up_screen.dart';
import 'package:firebase_auth_bloc/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: FirebaseAuth.instance),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SigninCubit>(
            create: (context) => SigninCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SignupCubit>(
            create: (context) => SignupCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: SplashScreen(),
          ),
          routes: {
            SignUpScreen.routeName: (context) => SignUpScreen(),
            SignInScreen.routeName: (context) => SignInScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
          },
        ),
      ),
    );
  }
}
