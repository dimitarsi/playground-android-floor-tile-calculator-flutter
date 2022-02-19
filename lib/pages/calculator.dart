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

  CalculatorPageState() {
    viewByStep = {
      1: _stepOneRoomSize,
      2: _stepTwoTileSize,
      3: _stepThreeGapSize,
      4: _stepFourTotal
    };
  }

  final EdgeInsets _pagePadding = const EdgeInsets.only(left: 20, right: 20);

  @override
  Widget build(BuildContext context) {
    var currentStep = viewByStep[step]!;

    return Scaffold(
      body: Container(padding: _pagePadding, child: currentStep()),
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
          decoration: InputDecoration(label: Text("Room Width")),
        ),
        TextFormField(
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
          decoration: InputDecoration(label: Text("Tile Width")),
        ),
        TextFormField(
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
          decoration: InputDecoration(label: Text("Gap Width")),
        ),
        _renderButtonRows()
      ],
    );
  }

  Widget _stepFourTotal() {
    return Column(
      children: [
        _row("RoomArea", "2.5m x 2m", "5m2"),
        _row("TileSize", "37cm x 37 cm", "5m2"),
        _row("Gap", "", "8mm"),
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
}
