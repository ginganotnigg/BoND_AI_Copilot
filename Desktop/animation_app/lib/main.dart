import 'package:flutter/material.dart';
import 'screen/material_motion.dart';

void main() {
  runApp(const AnimationApp());
}

class AnimationApp extends StatelessWidget {
  const AnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation Comparison',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIdx = 0;
  bool _useBuiltIn = true;

  List<Widget> _screens = [
    MaterialMotionScreen(useBuiltIn: true),
    //PreBuiltEffectsScreen(useBuiltIn: true),
    //ComplexLoadingScreen(useBuiltIn: true),
    //ButtonPressScreen(useBuiltIn: true),
  ];

  void navigateBar(int idx) {
    setState(() {
      _selectedIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIdx,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedFontSize: 8,
        unselectedFontSize: 0,
        selectedItemColor: Colors.cyan[600],
        unselectedItemColor: const Color(0xFF7FC4CD),
        currentIndex: _selectedIdx,
        onTap: navigateBar,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.motion_photos_auto_outlined),
              label: 'Material Motion'),
          BottomNavigationBarItem(
              icon: Icon(Icons.build_circle_outlined),
              label: 'Pre-built Effects'),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_circle_down), label: 'Complex Loading'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ads_click), label: 'Button Press'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[600],
        onPressed: () {
          setState(() {
            _useBuiltIn = !_useBuiltIn;
            _screens[_selectedIdx] = _selectedIdx == 0
                ? MaterialMotionScreen(useBuiltIn: _useBuiltIn)
                : _selectedIdx == 1
                    ? MaterialMotionScreen(
                        useBuiltIn:
                            _useBuiltIn) // Must fixed to PreBuiltEffectsScreen
                    : _selectedIdx == 2
                        ? MaterialMotionScreen(
                            useBuiltIn:
                                _useBuiltIn) // Must fixed to ComplexLoadingScreen
                        : MaterialMotionScreen(
                            useBuiltIn:
                                _useBuiltIn); // Must fixed to ButtonPressScreen
          });
        },
        tooltip: 'Switch Animations',
        child: Icon(
          (_useBuiltIn) ? Icons.animation : Icons.extension,
          color: Colors.white70,
        ),
      ),
    );
  }
}
