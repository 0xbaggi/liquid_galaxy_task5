import 'dart:async';
import 'package:flutter/material.dart';
import 'package:liquid_galaxy_ui_components/utils/constant.dart';

class ProgressBarPage extends StatefulWidget {
  const ProgressBarPage({super.key});

  @override
  _ProgressBarPageState createState() => _ProgressBarPageState();
}

class _ProgressBarPageState extends State<ProgressBarPage> {
  int _currentStep = 0;
  late Timer _timer;

  final Color activeColor = Colors.lightGreen;
  final Color passedColor = Colors.green;
  final Color notPassedColor = Colors.grey;
  final steps = ['Cart', 'Address', 'Payment', 'Checkout', 'Done'];

  @override
  void initState() {
    super.initState();
    _startLoop();
  }

  void _startLoop() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentStep = (_currentStep + 1) % 5; // Loop through 0 to 4
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              bool isActive = index == _currentStep;
              bool isPassed = index < _currentStep;

              Color circleColor;
              if (isActive) {
                circleColor = activeColor;
              } else if (isPassed) {
                circleColor = passedColor;
              } else {
                circleColor = notPassedColor;
              }

              return Column(
                children: [
                  SizedBox(
                      height: 60,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 35 : 30,
                        height: isActive ? 35 : 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: circleColor,
                        ),
                        child: isActive
                            ? Center(
                                child: Icon(
                                Icons.check,
                                color: isActive
                                    ? Colors.white
                                    : Colors.transparent,
                              ))
                            : Center(
                                child: Text((index + 1).toString(),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                      )),
                  Text(
                    steps[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }),
          ),
          const Spacer(),
          Text(
            "Step ${_currentStep + 1} of 5",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
