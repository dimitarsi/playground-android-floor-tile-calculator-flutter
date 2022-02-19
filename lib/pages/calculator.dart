import 'dart:math';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculatorPageState();
  }
}

class CalculatorPageState extends State<CalculatorPage> {
  int step = 1;
  Map<int, Widget Function()> viewByStep = {};
  Map<String, TextEditingController> controllers = {};

  CalculatorPageState() {
    viewByStep = {
      1: _stepOneRoomSize,
      2: _stepTwoTileSize,
      3: _stepThreeGapSize,
      4: _stepFourTotal
    };
    controllers['roomWidth'] = TextEditingController();
    controllers['roomLength'] = TextEditingController();
    controllers['tileWidth'] = TextEditingController();
    controllers['tileLength'] = TextEditingController();
    controllers['gapSize'] = TextEditingController();
  }
  final _formKey = GlobalKey<FormState>();
  final EdgeInsets _pagePadding = const EdgeInsets.only(left: 20, right: 20);

  @override
  Widget build(BuildContext context) {
    var currentStep = viewByStep[step]!;

    return Scaffold(
      body: Form(
          key: _formKey,
          child: Container(padding: _pagePadding, child: currentStep())),
    );
  }

  _row(String mainText, String additionalText, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(mainText,
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6 //TextStyle(fontSize: 14),
                ),
            Text(additionalText, style: Theme.of(context).textTheme.bodyText2)
          ],
        ),
        Text(
          val,
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget _stepOneRoomSize() {
    return Column(
      children: [
        Text("Step: $step"),
        TextFormField(
          key: Key("roomWidth"),
          controller: controllers["roomWidth"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(label: Text("Room Width")),
        ),
        TextFormField(
          key: Key("roomLength"),
          controller: controllers["roomLength"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(label: Text("Room Length")),
        ),
        _renderButtonRows()
      ],
    );
  }

  Widget _stepTwoTileSize() {
    return Column(
      children: [
        Text("Step: $step"),
        TextFormField(
          key: Key("tileWidth"),
          controller: controllers["tileWidth"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(label: Text("Tile Width")),
        ),
        TextFormField(
          key: Key("tileLength"),
          controller: controllers["tileLength"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(label: Text("Tile Length")),
        ),
        _renderButtonRows()
      ],
    );
  }

  Widget _stepThreeGapSize() {
    return Column(
      children: [
        Text("Step: $step"),
        TextFormField(
          key: Key("gapSize"),
          controller: controllers["gapSize"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(label: Text("Gap Width")),
        ),
        _renderButtonRows()
      ],
    );
  }

  Widget _stepFourTotal() {
    String roomSize =
        "${controllers["roomWidth"]?.text} x ${controllers["roomLength"]?.text}";

    int roomSizeTotal =
        (int.tryParse(controllers["roomWidth"]?.text ?? "0") ?? 0) *
            (int.tryParse(controllers["roomLength"]?.text ?? "0") ?? 0);

    int tileSizeTotal =
        (int.tryParse(controllers["tileWidth"]?.text ?? "0") ?? 0) *
            (int.tryParse(controllers["tileLength"]?.text ?? "0") ?? 0);

    String tileSize =
        "${controllers["tileWidth"]?.text} x ${controllers["tileLength"]?.text}";

    return Column(
      children: [
        _row("Room Area", roomSize, "${roomSizeTotal}m2"),
        _row("Tile Size", tileSize, "${tileSizeTotal}m2"),
        _row("Gap", "", "${controllers["gapSize"]?.text ?? "0"}mm"),
        _renderButtonRows()
      ],
    );
  }

  _renderButtonRows() {
    return Container(
      child: _renderButtons(),
      padding: const EdgeInsets.only(top: 50),
    );
  }

  _renderButtons() {
    if (step == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed: goToNext(), child: Text("Next ${step + 1}"))
        ],
      );
    }

    if (step == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(onPressed: goToStep(1), child: const Text("New")),
          ElevatedButton(onPressed: goToStep(4), child: const Text("Save"))
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(onPressed: goToPrev(), child: const Text('Back')),
        ElevatedButton(onPressed: goToNext(), child: const Text("Next")),
      ],
    );
  }

  goToStep(int nextStep) {
    return () {
      if (nextStep > step) {
        var valid = _formKey.currentState?.validate();

        if (valid == null || !valid) {
          return;
        }
      }

      setState(() {
        step = max(1, min(4, nextStep));
      });
    };
  }

  goToPrev() {
    return goToStep(step - 1);
  }

  goToNext() {
    return goToStep(step + 1);
  }

  startNew() {
    setState(() {
      step = 1;
    });
  }

  String? _requiredInt(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return "Please enter correct dimentions";
    }

    return null;
  }
}
