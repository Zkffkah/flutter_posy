import 'package:flutter/material.dart';
import 'package:flutter_posy/bloc/bloc_provider.dart';
import 'package:flutter_posy/pages/calculator/calculator.dart';
import 'package:flutter_posy/pages/calculator/calculator_bloc.dart';

import 'home_bloc.dart';

class HomePage extends StatelessWidget {
  final CalculatorBloc _calculatorBloc = CalculatorBloc();

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Posy"),
    ),
      body: BlocProvider(
        bloc: _calculatorBloc,
        child: Calculator(),
      ),
    );
  }
}