import 'package:flutter/material.dart';
import 'package:liquid_galaxy_ui_components/utils/constant.dart';

class ProgressBarPage extends StatefulWidget {
  const ProgressBarPage({Key? key}) : super(key: key);

  @override
  _ProgressBarPageState createState() => _ProgressBarPageState();
}

class _ProgressBarPageState extends State<ProgressBarPage> {
  int _currentStep = 0;

  final Color activeColor = Colors.lightGreen;
  final Color passedColor = Colors.green;
  final Color notPassedColor = Colors.grey;
  final List<String> steps = ['Cart', 'Address', 'Payment', 'Checkout', 'Done'];

  static const double maxCircleSize = 35;
  static const double lineWidth = 25;
  static const double inactiveCircleSize = 30;

  void _goToNextStep() {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                SizedBox(
                  width: maxCircleSize,
                  height: maxCircleSize,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: (i == _currentStep)
                          ? maxCircleSize
                          : inactiveCircleSize,
                      height: (i == _currentStep)
                          ? maxCircleSize
                          : inactiveCircleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getCircleColor(i),
                      ),
                      child: (i == _currentStep)
                          ? const Icon(Icons.check, color: Colors.white)
                          : Center(
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                  ),
                ),
                if (i < steps.length - 1) ...[
                  const SizedBox(width: 10),
                  Container(
                    width: lineWidth,
                    height: 3,
                    color: _getLineColor(i),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                SizedBox(
                  width: maxCircleSize + 20 + lineWidth,
                  child: Text(
                    steps[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: (i == _currentStep)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _goToPreviousStep,
                  child: const Text('Previous'),
                ),
                Text(
                  "Step ${_currentStep + 1} of ${steps.length}",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _goToNextStep,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Color _getCircleColor(int index) {
    if (index == _currentStep) {
      return activeColor;
    } else if (index < _currentStep) {
      return passedColor;
    } else {
      return notPassedColor;
    }
  }

  Color _getLineColor(int index) {
    return (_currentStep > index) ? passedColor : notPassedColor;
  }
}
