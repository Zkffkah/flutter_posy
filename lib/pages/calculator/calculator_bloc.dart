import 'dart:async';

import 'package:flutter_posy/bloc/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:decimal/decimal.dart';


class CalculatorBloc implements BlocBase {
  static final int defaultMaxRisk = 2;

  static final double defaultPositionSize = 1;

  static final double defaultEntryPrice = 0.00000100;

  static final double defaultStopPrice = 0.00000090;

  static final double defaultTargetPrice = 0.00000110;

  //* Replacing above Dart StreamController with RxDart BehaviourSubject (which is a broadcast stream by default)
  //NOTE: We are leveraging the additional functionality from BehaviorSubject to go back in time and retrieve the lastest value of the streams for form submission
  //NOTE: Dart StreamController doesn't have such functionality
  final _maxRiskController = BehaviorSubject<int>(seedValue: defaultMaxRisk);

  // Add data to stream
  Stream<int> get maxRisk => _maxRiskController.stream;

  Function(int) get changeMaxRisk => _maxRiskController.sink.add;

  final _positionSizeController = BehaviorSubject<double>(
      seedValue: defaultPositionSize);

  Stream<double> get positionSize => _positionSizeController.stream;

  Function(double) get changePositionSize => _positionSizeController.sink.add;


  final _entryPriceController = BehaviorSubject<double>(
      seedValue: defaultEntryPrice);

  Stream<double> get entryPrice => _entryPriceController.stream;

  Function(double) get changeEntryPrice => _entryPriceController.sink.add;


  final _stopPriceController = BehaviorSubject<double>(
      seedValue: defaultStopPrice);

  Stream<double> get stopPrice => _stopPriceController.stream;

  Function(double) get changeStopPrice => _stopPriceController.sink.add;


  final _targetPriceController = BehaviorSubject<double>(
      seedValue: defaultTargetPrice);

  Stream<double> get targetPrice => _targetPriceController.stream;

  Function(double) get changeTargetPrice => _targetPriceController.sink.add;

  Decimal unitsToBuy;
  Decimal positionCost;
  Decimal positionRisk;
  Decimal targetGain;
  Decimal gainPercent;

  calculate() {
    print(_maxRiskController.value);
    print(_positionSizeController.value);
    print(_entryPriceController.value);
    print(_stopPriceController.value);
    print(_targetPriceController.value);

    Decimal riskPercentage = Decimal.parse(_maxRiskController.value.toString()) / Decimal.fromInt(100);
    Decimal positionSize = Decimal.parse(_positionSizeController.value.toString());
    Decimal entryPrice = Decimal.parse(_entryPriceController.value.toString());
    Decimal targetPrice = Decimal.parse(_targetPriceController.value.toString());
    Decimal stopPrice = Decimal.parse(_stopPriceController.value.toString());

    unitsToBuy = riskPercentage * positionSize / (entryPrice - stopPrice);
    positionCost = unitsToBuy * entryPrice;
    positionRisk = riskPercentage * positionSize;
    targetGain = unitsToBuy * (targetPrice - entryPrice);
    gainPercent = (targetGain / positionCost)*Decimal.fromInt(100);
    print(unitsToBuy);
    print(positionCost);
    print(positionRisk);
    print(targetGain);
    print(gainPercent);

  }

  CalculatorBloc() {
  }

  @override
  void dispose() {
    _maxRiskController.close();
    _positionSizeController.close();
    _stopPriceController.close();
    _targetPriceController.close();
    _maxRiskController.close();
  }


}
