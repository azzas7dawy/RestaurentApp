import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/screens/auth/logic/cubit/auth_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String id = 'Home';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().signOut(context);
            },
            child: const Text('log out', style: TextStyle(color: Colors.white),),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().deleteAccount(context);
            },
            child: const Text('delete account', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}