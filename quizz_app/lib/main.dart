import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizApp(),
    );
  }
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State createState() => _QuizAppState();
}

class _QuizAppState extends State {
  List<Map> quizContent = [
    {
      "questions": "Who is the founder of Oracle?",
      "options": [
        "Christ Lamb",
        "James Carter",
        "Larry Ellison",
        "Henry Smith"
      ],
      "correctans": 2
    },
    {
      "questions": "What is the parent company of Google?",
      "options": [
        "Microsoft Corporation",
        "Alphabet Inc",
        "Oracle Corporation",
        "Apple Inc."
      ],
      "correctans": 1
    },
    {
      "questions": "Which language is commonly used for web development?",
      "options": ["Python", "Java", "C++", "JavaScript"],
      "correctans": 3
    },
    {
      "questions": "What does 'HTTP' stand for?",
      "options": [
        "HyperText Transfer Protocol",
        "High Text Transfer Protocol",
        "Hyper Tech Transmission Protocol",
        "High Transfer Text Protocol"
      ],
      "correctans": 0
    },
    {
      "questions": "Who is the founder of Microsoft?",
      "options": ["C.V. Raman", "Bill Gates", "Steve Henry", "Andrew Wilson"],
      "correctans": 1
    },
    {
      "questions": "Who is the founder of Apple?",
      "options": ["Steve jobs", "Bill Gates", "Steve Henry", "Andrew Wilson"],
      "correctans": 0
    }
  ];
  int countIndex = 0;
  int selectedIndex = -1;
  bool setScreen = false;

  int score = 0;

  WidgetStateProperty<Color?> checkColor(int currentIndex) {
    if (selectedIndex != -1) {
      if (currentIndex == quizContent[countIndex]["correctans"]) {
        return const WidgetStatePropertyAll(Colors.green);
      } else if (selectedIndex == currentIndex) {
        return const WidgetStatePropertyAll(Colors.red);
      } else {
        return const WidgetStatePropertyAll(null);
      }
    } else {
      return const WidgetStatePropertyAll(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return screens();
  }

  Scaffold screens() {
    if (setScreen == false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Quiz App",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 238, 86, 255),
        ),
        body: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                const SizedBox(
                  width: 120,
                ),
                Text(
                  "Questions : ${countIndex + 1} / ${quizContent.length}",
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                    height: 60,
                    width: 360,
                    child: Center(
                      child: Text(
                        quizContent[countIndex]["questions"],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(201, 105, 3, 146)),
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                SizedBox(
                    height: 60,
                    width: 350,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: checkColor(0)),
                        onPressed: () => {
                              selectedIndex = 0,
                              if (selectedIndex ==
                                  quizContent[countIndex]["correctans"])
                                {
                                  score += 1,
                                },
                              setState(() {}),
                            },
                        child: Text(
                          "A. ${quizContent[countIndex]["options"][0]}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ))),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 60,
                    width: 350,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: checkColor(1)),
                        onPressed: () => {
                              selectedIndex = 1,
                              if (selectedIndex ==
                                  quizContent[countIndex]["correctans"])
                                {
                                  score += 1,
                                },
                              setState(() {}),
                            },
                        child: Text(
                          "B. ${quizContent[countIndex]["options"][1]}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ))),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 60,
                    width: 350,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: checkColor(2)),
                        onPressed: () => {
                              selectedIndex = 2,
                              if (selectedIndex ==
                                  quizContent[countIndex]["correctans"])
                                {
                                  score += 1,
                                },
                              setState(() {}),
                            },
                        child: Text(
                          "C. ${quizContent[countIndex]["options"][2]}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ))),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 60,
                    width: 350,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: checkColor(3)),
                        onPressed: () => {
                              selectedIndex = 3,
                              if (selectedIndex ==
                                  quizContent[countIndex]["correctans"])
                                {
                                  score += 1,
                                },
                              setState(() {}),
                            },
                        child: Text(
                          "D. ${quizContent[countIndex]["options"][3]}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ))),
                const SizedBox(
                  height: 30,
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 246, 116, 255),
            onPressed: () => {
                  if (countIndex < quizContent.length - 1)
                    {
                      if (selectedIndex > -1)
                        {countIndex++, selectedIndex = -1, setState(() {})}
                    }
                  else
                    {
                      setScreen = true,
                      setState(() {}),
                    }
                },
            child: const Icon(
              Icons.forward,
              color: Colors.white,
            )),
        backgroundColor: const Color.fromARGB(255, 255, 203, 241),
      );
    } else {
      return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 203, 241),
          appBar: AppBar(
            title: const Text("Quiz App",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 238, 86, 255),
          ),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(
                      "https://cdn.dribbble.com/users/7421625/screenshots/18722898/media/9dc2ccd128c89b19dddd55447ba5e1d0.gif")),
              const Text(
                "Congratulations",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Score : $score / ${quizContent.length} ",
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 246, 116, 255))),
                  onPressed: () => {
                    countIndex = 0,
                    selectedIndex = -1,
                    setScreen = false,
                    score = 0,
                    setState(() {})
                  },
                  child: const Text(
                    "Restart",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          )));
    }
  }
}
