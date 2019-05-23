import 'package:flutter/material.dart';
import 'package:flutter_posy/bloc/bloc_provider.dart';
import 'package:flutter_posy/pages/calculator/calculator_bloc.dart';

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CalculatorBloc _calculatorBloc = BlocProvider.of(context);
    TextEditingController _maxRiskTc =
        initialValue("${CalculatorBloc.defaultMaxRisk}");
    TextEditingController _positionSizeTc =
        initialValue("${CalculatorBloc.defaultPositionSize}");
    TextEditingController _entryPriceTc =
        initialValue("${CalculatorBloc.defaultEntryPrice.toStringAsFixed(8)}");
    TextEditingController _stopPriceTc =
        initialValue("${CalculatorBloc.defaultStopPrice.toStringAsFixed(8)}");
    TextEditingController _targetPriceTc =
        initialValue("${CalculatorBloc.defaultTargetPrice.toStringAsFixed(8)}");

    return Scaffold(
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _calculatorBloc.maxRisk,
              builder: (context, snapshot) {
                return TextField(
                  controller: _maxRiskTc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Max Risk %',
                  ),
                  onChanged: (value) {
                    _calculatorBloc.changeMaxRisk(int.parse(value));
                  },
                  autofocus: true,
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _calculatorBloc.positionSize,
              initialData: 1,
              builder: (context, snapshot) {
                return TextField(
                  controller: _positionSizeTc,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Position Size',
                  ),
                  onChanged: (value) {
                    _calculatorBloc.changePositionSize(double.parse(value));
                  },
                  autofocus: true,
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _calculatorBloc.entryPrice,
              builder: (context, snapshot) {
                return TextField(
                  controller: _entryPriceTc,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Entry Price',
                  ),
                  onChanged: (value) {
                    _calculatorBloc.changeEntryPrice(double.parse(value));
                  },
                  autofocus: true,
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _calculatorBloc.stopPrice,
              builder: (context, snapshot) {
                return TextField(
                  controller: _stopPriceTc,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Stop Price',
                  ),
                  onChanged: (value) {
                    _calculatorBloc.changeStopPrice(double.parse(value));
                  },
                  autofocus: true,
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: _calculatorBloc.targetPrice,
              builder: (context, snapshot) {
                return TextField(
                  controller: _targetPriceTc,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Target Price',
                  ),
                  onChanged: (value) {
                    _calculatorBloc.changeTargetPrice(double.parse(value));
                  },
                  autofocus: true,
                );
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send, color: Colors.white),
          onPressed: () {
            _calculatorBloc.calculate();
            goToDialog(context, _calculatorBloc);
          }),
    );
  }

  initialValue(val) {
    return TextEditingController(text: val);
  }

  goToDialog(context, calculatorBloc) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successTicket(calculatorBloc),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  successTicket(CalculatorBloc calculatorBloc) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListTile(
                  title: Text("Suggessted Quantity"),
                  trailing: Text("${calculatorBloc.unitsToBuy} units"),
                ),
                ListTile(
                  title: Text("Position Cost"),
                  trailing: Text("${calculatorBloc.positionCost}"),
                ),
                ListTile(
                  title: Text("Position Risk"),
                  trailing: Text("${calculatorBloc.positionRisk}"),
                ),
                ListTile(
                  title: Text("Target Gain"),
                  trailing: Text("${calculatorBloc.targetGain} (${calculatorBloc.gainPercent}%)"),
                ),
              ],
            ),
          ),
        ),
      );
}
