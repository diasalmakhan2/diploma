import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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

    return ListView(
      key: ValueKey('lesson-${lesson.id}-$currentQuestion'),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        lesson.type == LessonType.video
            ? _VideoLessonCard(lesson: lesson, accent: accent)
            : _ReadingLessonCard(lesson: lesson, accent: accent),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Text(
            'Review the lesson sections below, then answer 10 quiz questions. Each correct answer gives 1 point.',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F3A35),
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...lesson.sections.map(
          (section) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _LessonSectionCard(section: section, accent: accent),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Question ${currentQuestion + 1} of ${lesson.questions.length}',
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
                ? 'Finish quiz'
                : 'Next question',
          ),
        ),
      ],
    );
  }
}

class _LessonSectionCard extends StatelessWidget {
  const _LessonSectionCard({
    required this.section,
    required this.accent,
  });

  final LessonSection section;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            section.body,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: Color(0xFF3F3A35),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingLessonCard extends StatelessWidget {
  const _ReadingLessonCard({
    required this.lesson,
    required this.accent,
  });

  final LessonContent lesson;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            lesson.title,
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
    );
  }
}

class _VideoLessonCard extends StatelessWidget {
  const _VideoLessonCard({
    required this.lesson,
    required this.accent,
  });

  final LessonContent lesson;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lesson.contentTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1C1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.contentBody,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF615D58),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          _AssetVideoPlayer(
            videoAsset: lesson.videoAsset,
            accent: accent,
          ),
        ],
      ),
    );
  }
}

class _AssetVideoPlayer extends StatefulWidget {
  const _AssetVideoPlayer({
    required this.videoAsset,
    required this.accent,
  });

  final String? videoAsset;
  final Color accent;

  @override
  State<_AssetVideoPlayer> createState() => _AssetVideoPlayerState();
}

class _AssetVideoPlayerState extends State<_AssetVideoPlayer> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final asset = widget.videoAsset;
    if (asset == null || asset.isEmpty) {
      setState(() {
        _failed = true;
      });
      return;
    }

    final controller = VideoPlayerController.asset(asset);
    try {
      await controller.initialize();
      await controller.setLooping(false);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
      });
    } catch (_) {
      await controller.dispose();
      if (!mounted) {
        return;
      }
      setState(() {
        _failed = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Container(
        height: 220,
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: widget.accent.withOpacity(0.10),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_rounded, size: 40),
            SizedBox(height: 12),
            Text(
              'Audio or video file is not added yet.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Put the lesson file into assets/videos and run flutter pub get.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF615D58),
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.accent.withOpacity(0.10),
          borderRadius: BorderRadius.circular(24),
        ),
        child: CircularProgressIndicator(color: widget.accent),
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (controller.value.isPlaying) {
                    await controller.pause();
                  } else {
                    await controller.play();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                icon: Icon(
                  controller.value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                label: Text(
                  controller.value.isPlaying ? 'Pause' : 'Play lesson media',
                ),
              ),
            ),
          ],
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
              'Quiz completed',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Correct answers: $score of ${lesson.questions.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isAlreadyCompleted
                  ? 'This lesson was already completed before, so points were not added again.'
                  : '$score points were added to the bank.',
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
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
