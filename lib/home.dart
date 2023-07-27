import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double value = 50;
  double actualValue = 50;
  double minValue = 0;
  double maxValue = 100;
  List<double> steps = [
    0,
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    60,
    70,
    80,
    90,
    100
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomSlider(
          minValue: minValue,
          maxValue: maxValue,
          value: value,
          majorTick: 6,
          minorTick: 2,
          labelValuePrecision: 0,
          tickValuePrecision: 0,
          onChanged: (val) => setState(() {
            value = val;
            actualValue =
                steps[(val / maxValue * (steps.length - 1)).ceil().toInt()];
            print('Slider value (linear): $value');
            print('Actual value (non-linear): $actualValue');
          }),
          activeColor: Colors.orange,
          inactiveColor: Colors.orange.shade50,
          linearStep: false,
          steps: steps,
        ),
      ),
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final int majorTick;
  final int minorTick;
  final Function(double)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final int labelValuePrecision;
  final int tickValuePrecision;
  final bool linearStep;
  final List<double>? steps;

  CustomSlider({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.majorTick,
    required this.minorTick,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.labelValuePrecision = 2,
    this.tickValuePrecision = 1,
    this.linearStep = true,
    this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final allocatedHeight = MediaQuery.of(context).size.height;
    final allocatedWidth = MediaQuery.of(context).size.width;
    final divisions = (majorTick - 1) * minorTick + majorTick;
    final double valueHeight =
        allocatedHeight * 0.05 < 41 ? 41 : allocatedHeight * 0.05;
    final double tickHeight =
        allocatedHeight * 0.025 < 20 ? 20 : allocatedHeight * 0.025;
    final labelOffset = allocatedWidth / divisions / 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: List.generate(
            divisions,
            (index) => Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: valueHeight,
                    child: index % (minorTick + 1) == 0
                        ? Text(
                            linearStep
                                ? (index / (divisions - 1) * maxValue)
                                    .toStringAsFixed(tickValuePrecision)
                                : '${(steps?[index])?.toStringAsFixed(tickValuePrecision)}',
                            style: TextStyle(
                              fontSize:
                                  (index / (divisions - 1)) * maxValue == value
                                      ? 18
                                      : 10,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : null,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: tickHeight,
                    child: VerticalDivider(
                      indent: index % (minorTick + 1) == 0 ? 2 : 6,
                      thickness: 1.2,
                      color: (index / (divisions - 1)) * maxValue == value
                          ? activeColor ?? Colors.orange
                          : Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: labelOffset),
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight:
                  allocatedHeight * 0.011 < 9 ? 9 : allocatedHeight * 0.011,
              activeTickMarkColor: activeColor ?? Colors.orange,
              inactiveTickMarkColor: inactiveColor ?? Colors.orange.shade50,
              activeTrackColor: activeColor ?? Colors.orange,
              inactiveTrackColor: inactiveColor ?? Colors.orange.shade50,
              thumbColor: activeColor ?? Colors.orange,
              overlayColor: activeColor == null
                  ? Colors.orange.withOpacity(0.1)
                  : activeColor!.withOpacity(0.1),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              trackShape: CustomTrackShape(),
              showValueIndicator: ShowValueIndicator.never,
              valueIndicatorTextStyle: const TextStyle(
                fontSize: 12,
              ),
            ),
            child: Slider(
              value: value,
              min: minValue,
              max: maxValue,
              divisions: divisions - 1,
              onChanged: onChanged,
              label: value.toStringAsFixed(labelValuePrecision),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
