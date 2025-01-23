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
  late AnimationController _disappearController;
  final int _sections = 4;
  late TweenSequence<Color?> _colorTweenSequence;

  @override
  void initState() {
    super.initState();

    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _disappearController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _colorTweenSequence = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.green),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.green, end: Colors.blue),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.blue, end: Colors.purple),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.purple, end: Colors.red),
        weight: 1,
      ),
    ]);
  }

  @override
  void dispose() {
    _appearController.dispose();
    _disappearController.dispose();
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
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            height: 200,
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
                AnimatedBuilder(
                  animation: _disappearController,
                  builder: (context, child) {
                    return Container(
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: List.generate(_sections, (index) {
                            return _colorTweenSequence.evaluate(
                                AlwaysStoppedAnimation(
                                    (_disappearController.value + index * 0.1) %
                                        1))!;
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
