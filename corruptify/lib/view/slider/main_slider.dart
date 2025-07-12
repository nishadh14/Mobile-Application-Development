import 'package:corruptify/view/login_type.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderScreen extends StatelessWidget {
  const SliderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SliderPage(),
    );
  }
}

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<SliderPage> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  final PageController _pageController = PageController();

  List<Map> slideImage = [
    {
      "img": "assets/images/corruption.png",
      'title': 'Welcome to Anti-Corruption App',
      'description':
          'Learn how to spot and fight corruption in your community.',
    },
    {
      "img": "assets/images/bribe.png",
      'title': 'Know the Signs',
      'description':
          'Understand common signs of corruption in public and private sectors.',
    },
    {
      "img": "assets/images/stop-corruption.png",
      'title': 'Make a Difference',
      'description': 'Report corruption and help create a better future.',
    },
    {
      "img": "assets/images/arrest.png",
      'title': 'Make a Difference',
      'description': 'Report corruption and help create a better future.',
    },
    {
      "img": "assets/images/corruption.png",
      'title': 'Make a Difference',
      'description': 'Report corruption and help create a better future.',
    },
  ];

  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Move to the next page
  void _nextPage() {
    if (_currentPageIndex < slideImage.length - 1) {
      _currentPageIndex++;
      _pageController.animateToPage(
        _currentPageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginChoiceScreen()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFD3D3D3),
                Color.fromARGB(255, 154, 132, 196),
                Color(0xFFFFFFFF)

                // Color(0xff6a1b9a),
                //  Color(0xffab47bc),
                //Color(0xffce93d8),
                // Color(0xff000000),
                // Color(0xff000000),
              ],

              // colors: [
              //   Color(0xFFFF5F6D),
              //   Color(0xFFFFC371),
              // ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slideImage.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      const SizedBox(height: 80),
                      Image.asset(
                        slideImage[_currentPageIndex]['img'],
                        height: 250,
                        width: 230,
                      ),
                      Text(
                        "${slideImage[_currentPageIndex]['title']}",
                        style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: Color.fromRGBO(27, 35, 35, 1)),
                      ),
                      Expanded(
                        child: Text(
                          "${slideImage[_currentPageIndex]['description']}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(35, 40, 41, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(
                          width: 400,
                          child: Text(
                            " Corruption is the abuse of power for personal gain, undermining trust, fairness, and development. It harms economies, deepens inequality, and weakens institutions. Combating corruption promotes transparency, justice, and sustainable progress for all.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(27, 33, 33, 1)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 45,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          onPressed: () => _nextPage(),
                          child: const Text(
                            "NEXT",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(65),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: slideImage.length,
                  axisDirection: Axis.horizontal,
                  effect: const WormEffect(),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
