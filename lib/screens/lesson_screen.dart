import 'package:flutter/material.dart';

import '../models/lesson_content.dart';
import '../widgets/app_scope.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.lesson});

  final LessonContent lesson;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentQuestion = 0;
  final Map<int, int> _answers = <int, int>{};
  bool _showResult = false;
  int _score = 0;
  bool _alreadyCompletedBeforeSubmit = false;

  void _selectAnswer(int index) {
    setState(() {
      _answers[_currentQuestion] = index;
    });
  }

  Future<void> _goNext() async {
    if (_currentQuestion == widget.lesson.questions.length - 1) {
      final appState = AppScope.of(context);
      final score = _calculateScore();
      final alreadyCompleted = appState.isLessonCompleted(widget.lesson.id);
      await appState.saveQuizResult(
        lessonId: widget.lesson.id,
        earnedPoints: score,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _score = score;
        _showResult = true;
        _alreadyCompletedBeforeSubmit = alreadyCompleted;
      });
      return;
    }

    setState(() {
      _currentQuestion += 1;
    });
  }

  int _calculateScore() {
    var score = 0;
    for (var i = 0; i < widget.lesson.questions.length; i++) {
      final answer = _answers[i];
      if (answer == widget.lesson.questions[i].correctIndex) {
        score += 1;
      }
    }
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final accent = Color(lesson.accentColor);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _showResult
            ? _LessonResult(
                lesson: lesson,
                score: _score,
                isAlreadyCompleted: _alreadyCompletedBeforeSubmit,
              )
            : _LessonFlow(
                lesson: lesson,
                currentQuestion: _currentQuestion,
                selectedAnswer: _answers[_currentQuestion],
                onSelect: _selectAnswer,
                onNext: _goNext,
                accent: accent,
              ),
      ),
    );
  }
}

class _LessonFlow extends StatelessWidget {
  const _LessonFlow({
    required this.lesson,
    required this.currentQuestion,
    required this.selectedAnswer,
    required this.onSelect,
    required this.onNext,
    required this.accent,
  });

  final LessonContent lesson;
  final int currentQuestion;
  final int? selectedAnswer;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final question = lesson.questions[currentQuestion];
    final isIntro = currentQuestion == 0;

    return ListView(
      key: ValueKey('lesson-${lesson.id}-$currentQuestion'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accent, accent.withOpacity(0.72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.type == LessonType.video ? 'Video lesson' : 'Reading lesson',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lesson.contentTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                lesson.contentBody,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (isIntro)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              'Сначала ученик знакомится с материалом выше, затем отвечает на 10 вопросов. За каждый правильный ответ начисляется 1 очко.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF3F3A35),
                height: 1.4,
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text(
          'Вопрос ${currentQuestion + 1} из ${lesson.questions.length}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF615D58),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          question.prompt,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1C1A1A),
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(question.options.length, (index) {
          final isSelected = selectedAnswer == index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => onSelect(index),
              child: Ink(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected ? accent.withOpacity(0.12) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? accent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  question.options[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? accent : const Color(0xFF2F2A26),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: selectedAnswer == null ? null : onNext,
          child: Text(
            currentQuestion == lesson.questions.length - 1
                ? 'Завершить тест'
                : 'Следующий вопрос',
          ),
        ),
      ],
    );
  }
}

class _LessonResult extends StatelessWidget {
  const _LessonResult({
    required this.lesson,
    required this.score,
    required this.isAlreadyCompleted,
  });

  final LessonContent lesson;
  final int score;
  final bool isAlreadyCompleted;

  @override
  Widget build(BuildContext context) {
    final accent = Color(lesson.accentColor);

    return Center(
      key: ValueKey('result-${lesson.id}'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.emoji_events_rounded, size: 58, color: accent),
            ),
            const SizedBox(height: 20),
            const Text(
              'Тест завершен',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Правильных ответов: $score из 10',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isAlreadyCompleted
                  ? 'Этот урок уже был пройден раньше, поэтому очки повторно не добавляются.'
                  : 'В банк зачислено $score очков.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF615D58),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Вернуться на главную'),
            ),
          ],
        ),
      ),
    );
  }
}
