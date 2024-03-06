import 'package:flutter/material.dart';

class StepProgressView extends StatelessWidget {
  const StepProgressView(
    List<String> stepsText,
    int curStep,
    double height,
    double width,
    double dotRadius,
    Color activeColor,
    Color inactiveColor,
    TextStyle stepsStyle, {
    super.key,
    required this.decoration,
    required this.padding,
    this.lineHeight = 2.0,
  })  : _stepsText = stepsText,
        _curStep = curStep,
        _height = height,
        _width = width,
        _dotRadius = dotRadius,
        _activeColor = activeColor,
        _inactiveColor = inactiveColor,
        _stepStyle = stepsStyle,
        assert(curStep > 0 == true && curStep <= stepsText.length),
        assert(width > 0),
        assert(height >= 2 * dotRadius),
        assert(width >= dotRadius * 2 * stepsText.length);

  //height of the container
  final double _height;

  //width of the container
  final double _width;

  //container decoration
  final BoxDecoration decoration;

  //list of texts to be shown for each step
  final List<String> _stepsText;

  //cur step identifier
  final int _curStep;

  //active color
  final Color _activeColor;

  //in-active color
  final Color _inactiveColor;

  //dot radius
  final double _dotRadius;

  //container padding
  final EdgeInsets padding;

  //line height
  final double lineHeight;

  //steps text
  final TextStyle _stepStyle;

  List<Widget> _buildDots() {
    var dots = <Widget>[];
    _stepsText.asMap().forEach((i, text) {
      var circleColor = (_curStep >= i + 1) ? _activeColor : _inactiveColor;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;

      dots.add(CircleAvatar(
        radius: _dotRadius,
        backgroundColor: circleColor,
      ));
      if (i != _stepsText.length - 1) {
        dots.add(
          Expanded(
            child: Container(
              height: lineHeight,
              color: lineColor,
            ),
          ),
        );
      }
    });

    return dots;
  }

  List<Widget> _buildText() {
    var widgets = <Widget>[];
    _stepsText.asMap().forEach((i, text) {
      widgets.add(Text(text, style: _stepStyle));
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: _height,
      // height: 60,
      width: _width,
      decoration: decoration,
      child: Column(
        children: <Widget>[
          Row(
            children: _buildDots(),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildText(),
          ),
        ],
      ),
    );
  }
}
