import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_galaxy_ui_components/utils/constant.dart';

class GoogleVoiceUI extends StatefulWidget {
  const GoogleVoiceUI({super.key});

  @override
  _GoogleVoiceUIState createState() => _GoogleVoiceUIState();
}

class _GoogleVoiceUIState extends State<GoogleVoiceUI>
    with TickerProviderStateMixin {
  late AnimationController _appearController;
  late AnimationController _rectanglesController;

  @override
  void initState() {
    super.initState();

    // Controller for the text "reveal" animation.
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Controller for the rectangles animation.
    _rectanglesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _appearController.dispose();
    _rectanglesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 220,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.bubble_chart, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                const Text(
                  'Hi, how can I help?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _appearController,
                  builder: (context, child) {
                    const text = 'Remind me to buy new shoes this weekend';
                    final words = text.split(' ');
                    final wordCount = words.length;
                    final currentWordIndex =
                        (_appearController.value * wordCount).floor() %
                            wordCount;
                    final displayText =
                        words.sublist(0, currentWordIndex + 1).join(' ');
                    return Text(
                      displayText,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    );
                  },
                ),
                const Spacer(),
                // The continuously looping animated rectangles.
                _AnimatedRectangles(controller: _rectanglesController),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedRectangles extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedRectangles({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: 30,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          double t = controller.value;
          const double amplitude = 0.3;

          List<double> pulses = List.generate(4, (index) {
            double phase = index / 4.0; // 0, 0.25, 0.5, 0.75
            return 1.0 + amplitude * sin(2 * pi * (t + phase));
          });

          double sumPulses = pulses.fold(0.0, (prev, value) => prev + value);
          List<double> widths =
              pulses.map((pulse) => (pulse / sumPulses) * screenWidth).toList();

          return Row(
            children: List.generate(4, (index) {
              return Container(
                width: widths[index],
                height: 10,
                decoration: BoxDecoration(
                  color: _getColor(index),
                  boxShadow: [
                    BoxShadow(
                      color: _getColor(index).withAlpha((160).toInt()),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(0, -3.5),
                    )
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // Rectangle colors.
  Color _getColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.white;
    }
  }
}
