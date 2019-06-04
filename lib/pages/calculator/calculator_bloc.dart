import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_posy/bloc/bloc_provider.dart';
import 'package:flutter_posy/data/pref/pref_helper.dart';
import 'package:rxdart/rxdart.dart';

class CalculatorBloc implements BlocBase {
  static final double defaultMaxRisk = 2;

  static final double defaultPositionSize = PrefHelper().getPositionSize();

  static final double defaultEntryPrice = 0.00000100;

  static final double defaultStopPrice = 0.00000090;

  static final double defaultTargetPrice = 0.00000110;

  //* Replacing above Dart StreamController with RxDart BehaviourSubject (which is a broadcast stream by default)
  //NOTE: We are leveraging the additional functionality from BehaviorSubject to go back in time and retrieve the lastest value of the streams for form submission
  //NOTE: Dart StreamController doesn't have such functionality
  final _maxRiskController = BehaviorSubject<double>(seedValue: defaultMaxRisk);

  // Add data to stream
  Stream<double> get maxRisk => _maxRiskController.stream;

  Function(double) get changeMaxRisk => _maxRiskController.sink.add;

  final _positionSizeController = BehaviorSubject<double>();

  Stream<double> get positionSize => _positionSizeController.stream;

  Function(double) get changePositionSize => _positionSizeController.sink.add;

  final _entryPriceController =
      BehaviorSubject<double>(seedValue: defaultEntryPrice);

  Stream<double> get entryPrice => _entryPriceController.stream;

  Function(double) get changeEntryPrice => _entryPriceController.sink.add;

  final _stopPriceController =
      BehaviorSubject<double>(seedValue: defaultStopPrice);

  Stream<double> get stopPrice => _stopPriceController.stream;

  Function(double) get changeStopPrice => _stopPriceController.sink.add;

  final _targetPriceController =
      BehaviorSubject<double>(seedValue: defaultTargetPrice);

  Stream<double> get targetPrice => _targetPriceController.stream;

  Function(double) get changeTargetPrice => _targetPriceController.sink.add;

  final _errorMsgController = BehaviorSubject<String>();

  Stream<String> get errorMsg => _errorMsgController.stream;

  Stream<bool> get priceValid =>
      Observable.combineLatest3(entryPrice, stopPrice, targetPrice,
          (entryPrice, stopPrice, targetPrice) {
        if (targetPrice <= entryPrice) {
          _errorMsgController
              .addError("Entry price must lower than target price");
        }

        if (stopPrice >= entryPrice) {
          _errorMsgController
              .addError("Entry price must higher than stop price");
        }
        if (entryPrice > stopPrice && entryPrice < targetPrice) {
          _errorMsgController.add("success");
        }
        return entryPrice > stopPrice && entryPrice < targetPrice;
      });

  Decimal unitsToBuy;
  Decimal positionCost;
  Decimal positionRisk;
  Decimal targetGain;
  Decimal lostPercent;
  Decimal gainPercent;
  Decimal rr;

  calculate() async {
    print(_maxRiskController.value);
    print(_positionSizeController.value);
    print(_entryPriceController.value);
    print(_stopPriceController.value);
    print(_targetPriceController.value);

    Decimal riskPercentage =
        Decimal.parse(_maxRiskController.value.toString()) /
            Decimal.fromInt(100);
    Decimal positionSize =
        Decimal.parse(_positionSizeController.value.toString());
    Decimal entryPrice = Decimal.parse(_entryPriceController.value.toString());
    Decimal targetPrice =
        Decimal.parse(_targetPriceController.value.toString());
    Decimal stopPrice = Decimal.parse(_stopPriceController.value.toString());

    unitsToBuy = riskPercentage * positionSize / (entryPrice - stopPrice);
    positionCost = unitsToBuy * entryPrice;
    positionRisk = riskPercentage * positionSize;
    targetGain = unitsToBuy * (targetPrice - entryPrice);
    lostPercent = (positionRisk / positionCost) * Decimal.fromInt(100);
    gainPercent = (targetGain / positionCost) * Decimal.fromInt(100);
    rr = (gainPercent / lostPercent);
    print(unitsToBuy);
    print(positionCost);
    print(positionRisk);
    print(targetGain);
    print(gainPercent);
  }

  CalculatorBloc() {
    changePositionSize(PrefHelper().getPositionSize());
    _positionSizeController.stream.debounce(Duration(microseconds: 1000)).listen((data) async{
      await PrefHelper().setPositionSize(_positionSizeController.value.toString());
    });
  }

  @override
  void dispose() async {
    _maxRiskController.close();
    _positionSizeController.close();
    _stopPriceController.close();
    _targetPriceController.close();
    _entryPriceController.close();
  }
}
