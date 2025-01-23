import 'package:flutter/material.dart';
import 'package:liquid_galaxy_ui_components/tabs/animatedIcons.dart';
import 'package:liquid_galaxy_ui_components/tabs/gemini.dart';
import 'package:liquid_galaxy_ui_components/tabs/googleVoice.dart';
import 'package:liquid_galaxy_ui_components/tabs/progresBar.dart';
import 'package:liquid_galaxy_ui_components/utils/constant.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabTitle = [
    'Google Voice',
    'Gemini Button',
    'Progress Bar',
    'Animated Icons'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this, animationDuration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(_tabTitle[_tabController.index],
              style: const TextStyle(color: Colors.white)),
        ),
        bottomNavigationBar: Material(
          color: primaryColor,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            onTap: (index) {
              setState(() {
                _tabController.index = index;
              });
            },
            tabs: [
              const Tab(
                icon: Icon(
                  Icons.bubble_chart,
                  size: 20,
                  color: Colors.white,
                ),
                child: Text(
                  'Voice',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                icon: Image.asset('assets/images/gemini.png',
                    width: 20, height: 20, color: Colors.white),
                child: const Text(
                  'Gemini',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Tab(
                icon: Icon(Icons.check_circle_rounded, color: Colors.white),
                child: Text(
                  'Progress',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Tab(
                icon: Icon(Icons.animation, color: Colors.white),
                child: Text(
                  'Icons',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            GoogleVoiceUI(),
            GeminiLogoPage(),
            ProgressBarPage(),
            AnimatedIconsPage(),
          ],
        ),
      ),
    );
  }
}
