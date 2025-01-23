import 'package:flutter/material.dart';
import 'package:liquid_galaxy_ui_components/utils/constant.dart';

class AnimatedIconsPage extends StatefulWidget {
  const AnimatedIconsPage({super.key});

  @override
  _AnimatedIconsPageState createState() => _AnimatedIconsPageState();
}

class _AnimatedIconsPageState extends State<AnimatedIconsPage> {
  // Animated Icons documentation: https://api.flutter.dev/flutter/material/AnimatedIcons-class.html
  final List<AnimatedIconData> icons = [
    AnimatedIcons.play_pause,
    AnimatedIcons.menu_close,
    AnimatedIcons.ellipsis_search,
    AnimatedIcons.view_list,
    AnimatedIcons.add_event,
  ];

  final List<String> iconsName = [
    "Play/Pause",
    "Menu/Close",
    "Ellipsis/Search",
    "List/Grid",
    "Add Event",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView.builder(
        itemCount: icons.length,
        itemBuilder: (context, index) {
          final icon = icons[index];
          return AnimatedIconTile(
              animatedIcon: icon, iconName: iconsName[index]);
        },
      ),
    );
  }
}

class AnimatedIconTile extends StatefulWidget {
  final AnimatedIconData animatedIcon;
  final String iconName;

  const AnimatedIconTile(
      {super.key, required this.animatedIcon, required this.iconName});

  @override
  _AnimatedIconTileState createState() => _AnimatedIconTileState();
}

class _AnimatedIconTileState extends State<AnimatedIconTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isForward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AnimatedIcon(
        icon: widget.animatedIcon,
        color: Colors.white,
        progress: _animation,
        size: 36.0,
      ),
      title: Text(widget.iconName, style: const TextStyle(color: Colors.white)),
      onTap: () {
        setState(() {
          if (isForward) {
            _controller.forward(from: 0.0);
          } else {
            _controller.reverse(from: 1.0);
          }
          isForward = !isForward;
        });
      },
    );
  }
}
