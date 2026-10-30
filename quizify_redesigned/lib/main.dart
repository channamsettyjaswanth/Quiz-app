
import 'package:flutter/material.dart';

void main() => runApp(const QuizifyApp());

const bg = Color(0xFF101225);
const panel = Color(0xFF20223B);
const purple = Color(0xFF9585FF);

class QuizifyApp extends StatelessWidget {
  const QuizifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const QuizHomePage(),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int answer;
  final String explanation;

  const QuizQuestion(this.question, this.options, this.answer, this.explanation);
}

const Map<String, List<QuizQuestion>> quizData = {
  'Flutter': [
    QuizQuestion('What language is used in Flutter?',
        ['Java', 'Dart', 'Python', 'C++'], 1, 'Flutter uses Dart as its primary programming language.'),
    QuizQuestion('Which widget arranges items vertically?',
        ['Row', 'Stack', 'Column', 'Container'], 2, 'Column arranges its children vertically.'),
    QuizQuestion('What is the entry point of Dart?',
        ['main()', 'run()', 'start()', 'init()'], 0, 'Dart starts execution from main().'),
    QuizQuestion('Which widget does not hold mutable state?',
        ['StatefulWidget', 'StatelessWidget', 'StreamBuilder', 'FutureBuilder'], 1,
        'A StatelessWidget does not manage mutable state.'),
    QuizQuestion('Which widget provides a basic Material page structure?',
        ['Scaffold', 'Text', 'Icon', 'Padding'], 0,
        'Scaffold provides the standard Material page layout.'),
  ],
  'Java': [
    QuizQuestion('Which keyword creates an object?',
        ['class', 'new', 'this', 'static'], 1, 'The new keyword creates objects.'),
    QuizQuestion('Which is the entry point of Java?',
        ['start()', 'run()', 'main()', 'init()'], 2, 'Java applications start from main().'),
    QuizQuestion('Which concept supports code reuse?',
        ['Inheritance', 'Compilation', 'Casting', 'Looping'], 0,
        'Inheritance allows a class to reuse another class’s properties.'),
    QuizQuestion('Which type stores true or false?',
        ['int', 'char', 'boolean', 'float'], 2, 'boolean stores true or false.'),
    QuizQuestion('Which collection stores unique elements?',
        ['ArrayList', 'HashSet', 'LinkedList', 'Vector'], 1,
        'HashSet stores unique elements.'),
  ],
  'Python': [
    QuizQuestion('Which symbol starts a comment?',
        ['//', '#', '/*', '--'], 1, 'Python comments start with #.'),
    QuizQuestion('Which function displays output?',
        ['input()', 'print()', 'show()', 'display()'], 1, 'print() displays output.'),
    QuizQuestion('Which data type stores key-value pairs?',
        ['List', 'Tuple', 'Dictionary', 'Set'], 2, 'Dictionaries store key-value pairs.'),
    QuizQuestion('How do you define a function?',
        ['func', 'define', 'def', 'function'], 2, 'Python uses def to define functions.'),
    QuizQuestion('Which is a mutable collection?',
        ['Tuple', 'String', 'List', 'Integer'], 2,
        'Lists can be modified after creation.'),
  ],
  'General Knowledge': [
    QuizQuestion('Which is the largest planet?',
        ['Earth', 'Mars', 'Jupiter', 'Venus'], 2, 'Jupiter is the largest planet.'),
    QuizQuestion('What is the capital of India?',
        ['Mumbai', 'New Delhi', 'Hyderabad', 'Chennai'], 1,
        'New Delhi is the capital of India.'),
    QuizQuestion('How many continents are there?',
        ['Five', 'Six', 'Seven', 'Eight'], 2, 'There are seven continents.'),
    QuizQuestion('Which gas do plants absorb?',
        ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen'], 2,
        'Plants absorb carbon dioxide during photosynthesis.'),
    QuizQuestion('Which is the fastest land animal?',
        ['Lion', 'Cheetah', 'Tiger', 'Horse'], 1,
        'The cheetah is the fastest land animal.'),
  ],
};

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  String selectedCategory = 'Flutter';
  int currentIndex = 0;
  final Map<int, int> answers = {};
  bool showResult = false;

  List<QuizQuestion> get questions => quizData[selectedCategory]!;
  int get score => questions.asMap().entries
      .where((entry) => answers[entry.key] == entry.value.answer)
      .length;

  void startQuiz() {
    setState(() {
      currentIndex = 0;
      answers.clear();
      showResult = false;
    });
  }

  void selectAnswer(int index) {
    if (answers.containsKey(currentIndex)) return;
    setState(() => answers[currentIndex] = index);
  }

  void nextQuestion() {
    if (currentIndex == questions.length - 1) {
      setState(() => showResult = true);
    } else {
      setState(() => currentIndex++);
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) setState(() => currentIndex--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: showResult
              ? _buildResult()
              : answers.isNotEmpty || currentIndex > 0
                  ? _buildQuiz()
                  : _buildHome(),
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF7866F5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.psychology_alt_rounded,
                color: Colors.white, size: 27),
          ),
          const SizedBox(width: 11),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('QUIZIFY',
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2)),
              Text('LEARN  •  PLAY  •  GROW',
                  style: TextStyle(fontSize: 9, color: Color(0xFFA9A8C3))),
            ],
          ),
          const Spacer(),
          const Icon(Icons.bolt_rounded, color: purple),
          const SizedBox(width: 5),
          const Text('STUDENT', style: TextStyle(color: purple, fontSize: 11)),
        ],
      );

  Widget _buildHome() {
    final categories = [
      ('Flutter', 'Mobile app development', '📱', const Color(0xFF6355C9)),
      ('Java', 'Object oriented programming', '☕', const Color(0xFFA65D39)),
      ('Python', 'Programming fundamentals', '🐍', const Color(0xFF337C69)),
      ('General Knowledge', 'Test your awareness', '🌎', const Color(0xFFA17B35)),
    ];

    return ListView(
      key: const ValueKey('home'),
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeader(),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF383365), Color(0xFF242442)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('WELCOME BACK 👋',
                  style: TextStyle(color: Color(0xFFB8B3FF), fontSize: 11,
                      fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 12),
              const Text('Challenge your knowledge.',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Choose your favourite subject and test what you know.',
                  style: TextStyle(color: Color(0xFFC5C3DB), height: 1.4)),
              const SizedBox(height: 22),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Stat(value: '04', label: 'Categories'),
                  _Stat(value: '20', label: 'Questions'),
                  _Stat(value: '05', label: 'Per quiz'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Text('Choose a category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        const Text('SELECT ONE TO CONTINUE',
            style: TextStyle(color: Color(0xFFA9A8C3), fontSize: 10,
                letterSpacing: 1)),
        const SizedBox(height: 14),
        ...categories.map((item) {
          final isSelected = selectedCategory == item.$1;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = item.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 11),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF302D56) : panel,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: isSelected ? purple : const Color(0xFF30314A),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 49,
                    width: 49,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: item.$4,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(item.$3, style: const TextStyle(fontSize: 25)),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.$1,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text(item.$2,
                            style: const TextStyle(
                                color: Color(0xFFA9A8C3), fontSize: 11)),
                        const SizedBox(height: 4),
                        const Text('5 questions  ·  Beginner',
                            style: TextStyle(color: purple, fontSize: 10)),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: isSelected ? purple : const Color(0xFF696985),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF292448),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('YOUR SELECTED QUIZ',
                  style: TextStyle(color: Color(0xFFC9BCFF), fontSize: 10)),
              const SizedBox(height: 5),
              Text(selectedCategory,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('5 questions  ·  No negative marking  ·  Instant feedback',
                  style: TextStyle(color: Color(0xFFB9B4D0), fontSize: 10)),
            ],
          ),
        ),
        const SizedBox(height: 17),
        FilledButton.icon(
          onPressed: () {
            startQuiz();
            setState(() => currentIndex = 0);
            // The dedicated flag ensures the first question opens immediately.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuizPlayPage(
                  category: selectedCategory,
                  questions: questions,
                ),
              ),
            );
          },
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Start Quiz'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF7866F5),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(55),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text('Made for learning. Designed for fun.',
              style: TextStyle(color: Color(0xFF8889A8), fontSize: 10)),
        ),
      ],
    );
  }

  Widget _buildQuiz() {
    final q = questions[currentIndex];
    final selected = answers[currentIndex];
    return _quizLayout(q, selected);
  }

  Widget _quizLayout(QuizQuestion q, int? selected) {
    return const SizedBox.shrink();
  }

  Widget _buildResult() => const SizedBox.shrink();
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Color(0xFFB8B6D0), fontSize: 10)),
        ],
      );
}

class QuizPlayPage extends StatefulWidget {
  final String category;
  final List<QuizQuestion> questions;
  const QuizPlayPage({super.key, required this.category, required this.questions});

  @override
  State<QuizPlayPage> createState() => _QuizPlayPageState();
}

class _QuizPlayPageState extends State<QuizPlayPage> {
  int index = 0;
  final Map<int, int> answers = {};
  bool result = false;

  int get score => widget.questions.asMap().entries
      .where((e) => answers[e.key] == e.value.answer).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: result ? _resultView() : _questionView(),
      ),
    );
  }

  Widget _questionView() {
    final q = widget.questions[index];
    final chosen = answers[index];
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Exit quiz'),
            ),
            const Spacer(),
            Chip(
              label: Text(widget.category),
              backgroundColor: const Color(0xFF302D56),
              side: BorderSide.none,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
              color: const Color(0xFF22243E),
              borderRadius: BorderRadius.circular(18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('YOUR PROGRESS',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('${index + 1} / ${widget.questions.length}',
                      style: const TextStyle(color: purple)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (index + 1) / widget.questions.length,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF41415E),
                  color: purple,
                ),
              ),
              const SizedBox(height: 9),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Question ${index + 1}',
                      style: const TextStyle(color: Colors.white60, fontSize: 11)),
                  Text('Score: $score',
                      style: const TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('QUESTION ${index + 1}',
            style: const TextStyle(
                color: purple, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 12),
        Text(q.question,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 9),
        const Text('Select the correct answer below.',
            style: TextStyle(color: Color(0xFFA9A8C3))),
        const SizedBox(height: 23),
        ...List.generate(q.options.length, (i) {
          final isCorrect = i == q.answer;
          final isChosen = chosen == i;
          Color tileColor = panel;
          Color borderColor = const Color(0xFF393B58);
          if (chosen != null && isCorrect) {
            tileColor = const Color(0xFF194638);
            borderColor = const Color(0xFF49CA92);
          } else if (isChosen) {
            tileColor = const Color(0xFF512B3A);
            borderColor = const Color(0xFFF17D8C);
          }
          return GestureDetector(
            onTap: chosen == null
                ? () => setState(() => answers[index] = i)
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: borderColor,
                    width: chosen != null && (isCorrect || isChosen) ? 2 : 1),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF363451),
                    child: Text(String.fromCharCode(65 + i),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 13),
                  Expanded(child: Text(q.options[i],
                      style: const TextStyle(fontWeight: FontWeight.w600))),
                  if (chosen != null && isCorrect)
                    const Icon(Icons.check_circle, color: Color(0xFF49CA92))
                  else if (isChosen)
                    const Icon(Icons.cancel, color: Color(0xFFF17D8C)),
                ],
              ),
            ),
          );
        }),
        if (chosen != null) ...[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF292A43),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  chosen == q.answer ? Icons.check_circle : Icons.info_outline,
                  color: chosen == q.answer
                      ? const Color(0xFF49CA92)
                      : const Color(0xFFF3B76C),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chosen == q.answer ? 'Correct answer!' : 'Incorrect answer',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(q.explanation,
                          style: const TextStyle(
                              color: Color(0xFFC7C6DA), height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: index == 0 ? null : () => setState(() => index--),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                child: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: chosen == null
                    ? null
                    : () => setState(() {
                          if (index == widget.questions.length - 1) {
                            result = true;
                          } else {
                            index++;
                          }
                        }),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7866F5),
                  minimumSize: const Size.fromHeight(52),
                ),
                child: Text(index == widget.questions.length - 1
                    ? 'Finish Quiz'
                    : 'Next Question'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _resultView() {
    final percent = (score / widget.questions.length * 100).round();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 15),
            const Text('QUIZ COMPLETED',
                style: TextStyle(color: purple, letterSpacing: 1.5,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Amazing effort!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('You completed the ${widget.category} quiz.',
                style: const TextStyle(color: Colors.white60)),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  color: const Color(0xFF262543),
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  const Text('YOUR FINAL SCORE',
                      style: TextStyle(color: Colors.white60, fontSize: 11)),
                  const SizedBox(height: 10),
                  Text('$score/${widget.questions.length}',
                      style: const TextStyle(
                          color: Color(0xFFB5A7FF),
                          fontSize: 48,
                          fontWeight: FontWeight.bold)),
                  Text('$percent%',
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: score / widget.questions.length,
                      minHeight: 9,
                      backgroundColor: const Color(0xFF41415E),
                      color: purple,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    score == 5
                        ? 'Perfect! You mastered this quiz.'
                        : score >= 3
                            ? 'Good work! Keep improving.'
                            : 'Practice makes progress. Try again!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFFC5C2D9)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _resultStat('$score', 'Correct',
                      const Color(0xFF194638), const Color(0xFF65D9A7)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _resultStat('${widget.questions.length - score}',
                      'Incorrect', const Color(0xFF512B3A),
                      const Color(0xFFF18B9B)),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: FilledButton.icon(
                onPressed: () => setState(() {
                  index = 0;
                  answers.clear();
                  result = false;
                }),
                icon: const Icon(Icons.refresh),
                label: const Text('Play Again'),
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7866F5)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 53,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultStat(String value, String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: textColor, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
