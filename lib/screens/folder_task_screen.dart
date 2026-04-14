import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/folder_submission.dart';
import '../models/lesson_content.dart';
import '../widgets/app_scope.dart';

class FolderTaskScreen extends StatefulWidget {
  const FolderTaskScreen({
    super.key,
    required this.lesson,
    required this.folder,
  });

  final LessonContent lesson;
  final LessonFolder folder;

  @override
  State<FolderTaskScreen> createState() => _FolderTaskScreenState();
}

class _FolderTaskScreenState extends State<FolderTaskScreen> {
  int _currentIndex = 0;
  bool _isSubmitting = false;
  FolderSubmission? _submittedSubmission;

  final Map<String, int> _choiceAnswers = <String, int>{};
  final Map<String, String> _textAnswers = <String, String>{};
  final Map<String, List<String>> _checklistAnswers = <String, List<String>>{};
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  LessonStep get _currentStep => widget.folder.steps[_currentIndex];

  void _syncControllerWithStep() {
    final step = _currentStep;
    if (step.type == LessonStepType.fillBlank ||
        step.type == LessonStepType.openText ||
        step.type == LessonStepType.longText) {
      final value = _textAnswers[step.id] ?? '';
      if (_textController.text != value) {
        _textController
          ..text = value
          ..selection = TextSelection.collapsed(offset: value.length);
      }
    }
  }

  bool get _canProceed {
    final step = _currentStep;
    switch (step.type) {
      case LessonStepType.info:
        return true;
      case LessonStepType.multipleChoice:
        return _choiceAnswers.containsKey(step.id);
      case LessonStepType.fillBlank:
      case LessonStepType.openText:
      case LessonStepType.longText:
        return (_textAnswers[step.id] ?? '').trim().isNotEmpty;
      case LessonStepType.checklist:
        final checked = _checklistAnswers[step.id] ?? const <String>[];
        return checked.length == step.checklistItems.length;
    }
  }

  void _saveCurrentStepValue() {
    final step = _currentStep;
    if (step.type == LessonStepType.fillBlank ||
        step.type == LessonStepType.openText ||
        step.type == LessonStepType.longText) {
      _textAnswers[step.id] = _textController.text.trim();
    }
  }

  Future<void> _goNext() async {
    _saveCurrentStepValue();
    if (!_canProceed) {
      return;
    }

    if (_currentIndex == widget.folder.steps.length - 1) {
      setState(() {
        _isSubmitting = true;
      });

      final appState = AppScope.of(context);
      final submission = await appState.submitFolder(
        lesson: widget.lesson,
        folder: widget.folder,
        answers: <String, Object?>{
          ..._choiceAnswers,
          ..._textAnswers,
          ..._checklistAnswers,
        },
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _submittedSubmission = submission;
        _isSubmitting = false;
      });
      return;
    }

    setState(() {
      _currentIndex += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final submission =
        _submittedSubmission ??
        appState.submissionForFolder(widget.lesson.id, widget.folder.id);

    if (submission != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.folder.title),
          backgroundColor: Colors.transparent,
        ),
        body: _SubmissionSummary(
          lesson: widget.lesson,
          folder: widget.folder,
          submission: submission,
        ),
      );
    }

    _syncControllerWithStep();
    final accent = Color(widget.lesson.accentColor);
    final step = _currentStep;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.title),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.folder.subtitle,
                  style: TextStyle(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.folder.description,
                  style: const TextStyle(
                    color: Color(0xFF615D58),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / widget.folder.steps.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(999),
                  color: accent,
                  backgroundColor: accent.withOpacity(0.12),
                ),
                const SizedBox(height: 10),
                Text(
                  'Page ${_currentIndex + 1} of ${widget.folder.steps.length}',
                  style: const TextStyle(
                    color: Color(0xFF615D58),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (widget.folder.media != null) ...[
            const SizedBox(height: 16),
            _MediaCard(media: widget.folder.media!, accent: accent),
          ],
          const SizedBox(height: 16),
          _StepCard(
            step: step,
            accent: accent,
            selectedOptionIndex: _choiceAnswers[step.id],
            onSelectOption: (value) {
              setState(() {
                _choiceAnswers[step.id] = value;
              });
            },
            textController: _textController,
            onTextChanged: (value) {
              _textAnswers[step.id] = value;
              setState(() {});
            },
            checkedItems: _checklistAnswers[step.id] ?? const <String>[],
            onToggleChecklist: (item, checked) {
              final current = <String>[
                ...(_checklistAnswers[step.id] ?? const <String>[]),
              ];
              if (checked) {
                if (!current.contains(item)) {
                  current.add(item);
                }
              } else {
                current.remove(item);
              }
              setState(() {
                _checklistAnswers[step.id] = current;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: !_canProceed || _isSubmitting ? null : _goNext,
            child: Text(
              _currentIndex == widget.folder.steps.length - 1
                  ? (_isSubmitting ? 'Submitting...' : 'Submit folder')
                  : 'Next page',
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.accent,
    required this.selectedOptionIndex,
    required this.onSelectOption,
    required this.textController,
    required this.onTextChanged,
    required this.checkedItems,
    required this.onToggleChecklist,
  });

  final LessonStep step;
  final Color accent;
  final int? selectedOptionIndex;
  final ValueChanged<int> onSelectOption;
  final TextEditingController textController;
  final ValueChanged<String> onTextChanged;
  final List<String> checkedItems;
  final void Function(String item, bool checked) onToggleChecklist;

  @override
  Widget build(BuildContext context) {
    Widget answerInput;
    if (step.type == LessonStepType.info) {
      answerInput = const SizedBox.shrink();
    } else if (step.type == LessonStepType.multipleChoice) {
      answerInput = Column(
        children: List.generate(step.options.length, (index) {
          final selected = selectedOptionIndex == index;
          final optionLabel = String.fromCharCode(65 + index);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelectOption(index),
              child: Ink(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: selected ? accent.withOpacity(0.10) : const Color(0xFFFFFCF7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? accent : const Color(0xFFE7DED3),
                    width: 2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? accent : const Color(0xFFF2EADF),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        optionLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: selected ? Colors.white : const Color(0xFF6F655C),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          step.options[index],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: selected ? accent : const Color(0xFF2F2A26),
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    } else if (step.type == LessonStepType.fillBlank ||
        step.type == LessonStepType.openText ||
        step.type == LessonStepType.longText) {
      answerInput = TextField(
        controller: textController,
        onChanged: onTextChanged,
        maxLines: step.type == LessonStepType.longText ? 8 : 4,
        decoration: InputDecoration(
          hintText: step.placeholder ?? 'Type your answer',
          alignLabelWithHint: true,
        ),
      );
    } else {
      answerInput = Column(
        children: step.checklistItems
            .map(
              (item) => CheckboxListTile(
                value: checkedItems.contains(item),
                onChanged: (value) => onToggleChecklist(item, value ?? false),
                title: Text(
                  item,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            )
            .toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.prompt,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1C1A1A),
              height: 1.15,
            ),
          ),
          if (step.instructions != null) ...[
            const SizedBox(height: 10),
            Text(
              step.instructions!,
              style: const TextStyle(
                color: Color(0xFF615D58),
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
          if (step.content.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...step.content.map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  line,
                  style: const TextStyle(
                    color: Color(0xFF3F3A35),
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ],
          if (step.helperLines.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: step.helperLines
                    .map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          line,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3F3A35),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          if (step.wordBank.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: step.wordBank
                  .map(
                    (word) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 18),
          answerInput,
        ],
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  const _MediaCard({
    required this.media,
    required this.accent,
  });

  final LessonMedia media;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            media.title,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            media.description,
            style: const TextStyle(
              color: Color(0xFF615D58),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (media.type == LessonMediaType.image)
            _ImagePreview(media: media, accent: accent)
          else
            _AudioPreview(media: media, accent: accent),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.media,
    required this.accent,
  });

  final LessonMedia media;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final assetPath = media.assetPath;
    if (assetPath == null || assetPath.isEmpty) {
      return _MediaEmptyState(text: media.emptyStateText, accent: accent);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        height: 240,
        width: double.infinity,
        errorBuilder: (_, __, ___) {
          return _MediaEmptyState(text: media.emptyStateText, accent: accent);
        },
      ),
    );
  }
}

class _AudioPreview extends StatefulWidget {
  const _AudioPreview({
    required this.media,
    required this.accent,
  });

  final LessonMedia media;
  final Color accent;

  @override
  State<_AudioPreview> createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<_AudioPreview> {
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    final assetPath = widget.media.assetPath;
    if (assetPath == null || assetPath.isEmpty) {
      setState(() {
        _failed = true;
      });
      return;
    }

    final controller = VideoPlayerController.asset(assetPath);
    try {
      await controller.initialize();
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
      return _MediaEmptyState(
        text: widget.media.emptyStateText,
        accent: widget.accent,
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: widget.accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: widget.accent),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.music_note_rounded, size: 42, color: widget.accent),
          const SizedBox(height: 8),
          Text(
            controller.value.isPlaying ? 'Audio is playing' : 'Audio is ready',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
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
            label: Text(controller.value.isPlaying ? 'Pause' : 'Play song'),
          ),
        ],
      ),
    );
  }
}

class _MediaEmptyState extends StatelessWidget {
  const _MediaEmptyState({
    required this.text,
    required this.accent,
  });

  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.perm_media_rounded, color: accent, size: 36),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmissionSummary extends StatelessWidget {
  const _SubmissionSummary({
    required this.lesson,
    required this.folder,
    required this.submission,
  });

  final LessonContent lesson;
  final LessonFolder folder;
  final FolderSubmission submission;

  @override
  Widget build(BuildContext context) {
    final accent = Color(lesson.accentColor);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                submission.status == SubmissionStatus.pendingReview
                    ? 'Submitted for teacher review'
                    : 'Folder completed',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                folder.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Auto score: ${submission.objectivePoints}/${submission.objectiveMaxPoints}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Teacher score: ${submission.teacherAwardedPoints}/${submission.teacherMaxPoints}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                submission.status == SubmissionStatus.pendingReview
                    ? 'Open answers are waiting for a teacher score.'
                    : 'The teacher review is finished.',
                style: const TextStyle(
                  color: Color(0xFF615D58),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...submission.answers.map(
          (answer) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    answer.stepTitle,
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    answer.prompt,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    answer.answerText.isEmpty ? 'No answer saved.' : answer.answerText,
                    style: const TextStyle(
                      color: Color(0xFF3F3A35),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (answer.autoMaxPoints > 0)
                        _ScoreChip(
                          label:
                              'Auto ${answer.autoEarnedPoints}/${answer.autoMaxPoints}',
                          color: const Color(0xFF1F7AFC),
                        ),
                      if (answer.requiresTeacherReview)
                        _ScoreChip(
                          label:
                              'Teacher ${answer.teacherAwardedPoints}/${answer.teacherMaxPoints}',
                          color: const Color(0xFFFF8C42),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
