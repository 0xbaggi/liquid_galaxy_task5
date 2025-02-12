import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:liquid_galaxy_ui_components/utils/constant.dart';

class AnimatedIconsPage extends StatefulWidget {
  const AnimatedIconsPage({super.key});

  @override
  _AnimatedIconsPageState createState() => _AnimatedIconsPageState();
}

class _AnimatedIconsPageState extends State<AnimatedIconsPage> {
  // - asset: The path to the .riv file (rive format)
  // - animation1: The first animation state
  // - animation2: The second animation state
  // - title: The label for the tile
  final List<Map<String, String>> riveAnimations = [
    {
      "asset": "assets/icons/speaker.riv",
      "animation1": "idle",
      "animation2": "active",
      "title": "Speaker"
    },
    {
      "asset": "assets/icons/update.riv",
      "animation1": "idle",
      "animation2": "active",
      "title": "Update"
    },
    {
      "asset": "assets/icons/settings.riv",
      "animation1": "idle",
      "animation2": "active",
      "title": "Settings"
    },
    {
      "asset": "assets/icons/search.riv",
      "animation1": "idle",
      "animation2": "active",
      "title": "Search"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemCount: riveAnimations.length,
              itemBuilder: (context, index) {
                final data = riveAnimations[index];
                return RiveAnimatedIconTile(
                  asset: data["asset"]!,
                  animation1: data["animation1"]!,
                  animation2: data["animation2"]!,
                  iconName: data["title"]!,
                );
              },
            )),
            const Spacer(),
            const Text(
              "Click on the list item to start the animation",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
        ));
  }
}

class RiveAnimatedIconTile extends StatefulWidget {
  final String asset;
  final String animation1;
  final String animation2;
  final String iconName;

  const RiveAnimatedIconTile({
    super.key,
    required this.asset,
    required this.animation1,
    required this.animation2,
    required this.iconName,
  });

  @override
  _RiveAnimatedIconTileState createState() => _RiveAnimatedIconTileState();
}

class _RiveAnimatedIconTileState extends State<RiveAnimatedIconTile> {
  late RiveAnimationController _controller;
  late String currentAnimation;
  bool isForward = true;

  @override
  void initState() {
    super.initState();
    currentAnimation = widget.animation1;
    _controller = SimpleAnimation(currentAnimation);
  }

  void _toggleAnimation() {
    setState(() {
      currentAnimation = isForward ? widget.animation2 : widget.animation1;
      _controller = SimpleAnimation(currentAnimation);
      isForward = !isForward;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 10.0,
      leading: SizedBox(
        width: 40.0,
        height: 40.0,
        child: RiveAnimation.asset(
          widget.asset,
          key: ValueKey(currentAnimation),
          controllers: [_controller],
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        widget.iconName,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: _toggleAnimation,
    );
  }
}
