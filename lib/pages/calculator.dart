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
  Map<String, String?> textErrors = {};

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
          child: Container(
              padding: _pagePadding,
              child: IndexedStack(
                index: step - 1,
                children: [
                  viewByStep[1]!(),
                  viewByStep[2]!(),
                  viewByStep[3]!(),
                  viewByStep[4]!()
                ],
              ))),
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
        const SizedBox(height: 80),
        TextFormField(
          key: Key("roomWidth"),
          controller: controllers["roomWidth"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              label: Text("Room Width"), errorText: getErrorText("roomWidth")),
        ),
        TextFormField(
          key: Key("roomLength"),
          controller: controllers["roomLength"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              label: Text("Room Length"),
              errorText: getErrorText("roomLength")),
        ),
        _renderButtonRows()
      ],
    );
  }

  Widget _stepTwoTileSize() {
    return Column(
      children: [
        const SizedBox(height: 80),
        TextFormField(
          key: Key("tileWidth"),
          controller: controllers["tileWidth"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              label: Text("Tile Width"), errorText: getErrorText("tileWidth")),
        ),
        TextFormField(
          key: Key("tileLength"),
          controller: controllers["tileLength"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              label: Text("Tile Length"),
              errorText: getErrorText("tileLength")),
        ),
        _renderButtonRows()
      ],
    );
  }

  Widget _stepThreeGapSize() {
    return Column(
      children: [
        const SizedBox(height: 80),
        TextFormField(
          key: Key("gapSize"),
          controller: controllers["gapSize"],
          validator: _requiredInt,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              label: Text("Gap Width"), errorText: getErrorText("gapSize")),
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
        const SizedBox(height: 80),
        _row("Room Area", roomSize, "${roomSizeTotal}m2"),
        const SizedBox(height: 20),
        _row("Tile Size", tileSize, "${tileSizeTotal}m2"),
        const SizedBox(height: 20),
        _row("Gap", "", "${controllers["gapSize"]?.text ?? "0"}mm"),
        _renderButtonRows()
      ],
    );
  }

  String? getErrorText(String controllerKey) {
    return textErrors[controllerKey];
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
          TextButton(onPressed: goToNext(), child: Text("Next ${step + 1}"))
        ],
      );
    }

    if (step == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(onPressed: startNew, child: const Text("New")),
          TextButton(onPressed: goToPrev(), child: const Text("Save"))
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(onPressed: goToPrev(), child: const Text('Back')),
        TextButton(onPressed: goToNext(), child: const Text("Next")),
      ],
    );
  }

  goToStep(int nextStep) {
    return () {
      setState(() {
        bool hasError = false;

        if (step == 1 && nextStep > step) {
          textErrors["roomWidth"] =
              _requiredInt(controllers["roomWidth"]?.text);
          textErrors["roomLength"] =
              _requiredInt(controllers["roomLength"]?.text);

          hasError = textErrors["roomWidth"] != null ||
              textErrors["roomLength"] != null;
        }
        if (step == 2 && nextStep > step) {
          textErrors["tileWidth"] =
              _requiredInt(controllers["tileWidth"]?.text);
          textErrors["tileLength"] =
              _requiredInt(controllers["tileLength"]?.text);

          hasError = textErrors["tileWidth"] != null ||
              textErrors["tileLength"] != null;
        }
        if (step == 3 && nextStep > step) {
          textErrors["gapSize"] = _requiredInt(controllers["gapSize"]?.text);
          hasError = textErrors["gapSize"] != null;
        }

        if (!hasError) {
          step = max(1, min(4, nextStep));
        }
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
    controllers.forEach((key, controller) {
      controller.clear();
    });
    setState(() {
      step = 1;
    });
  }

  String? _requiredInt(String? inputValue) {
    if (inputValue?.isEmpty == true) {
      return "Please enter correct dimentions";
    }

    return null;
  }
}
