import 'package:flutter/material.dart';
import 'package:flutter_posy/bloc/bloc_provider.dart';
import 'package:flutter_posy/pages/home/home.dart';
import 'package:flutter_posy/pages/home/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/pref/pref_helper.dart';

void main() async {
  PrefHelper.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            accentColor: Colors.orange, primaryColor: const Color(0xFFDE4435)),
        home: BlocProvider(
          bloc: HomeBloc(),
          child: HomePage(),
        ));
  }
}
