import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/quiz_question.dart';
import 'widgets/kuis_explanation_view.dart';
import 'widgets/kuis_intro_view.dart';
import 'widgets/kuis_question_view.dart';

enum _QuizStage {
  intro,
  question,
  explanation,
}

class KuisScreen extends StatefulWidget {
  const KuisScreen({super.key});

  @override
  State<KuisScreen> createState() => _KuisScreenState();
}

class _KuisScreenState extends State<KuisScreen> {
  static const String _supabaseTableName = 'kuis';
  static const int _initialQuizSeconds = 300; // 05:00 untuk seluruh kuis
  static const int _maxQuizPoints = 100;

  _QuizStage _stage = _QuizStage.intro;
  int _activeTab = 0; // 0 = Kuis, 1 = Papan Peringkat

  late List<QuizQuestion> _questions;
  List<int?> _userAnswers = [];
  int _currentIndex = 0;
  int? _selectedOptionIndex;

  int _userPoints = 1280;
  int _earnedQuizPoints = _maxQuizPoints;
  int _wrongCount = 0;

  Timer? _timer;
  int _secondsLeft = _initialQuizSeconds;

  @override
  void initState() {
    super.initState();
    _questions = placeholderQuestions;
    _userAnswers = List<int?>.filled(_questions.length, null);
    _loadQuestionsFromSupabase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Mengambil soal dari Supabase secara background tanpa menahan tampilan (tanpa loading screen).
  Future<void> _loadQuestionsFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from(_supabaseTableName)
          .select()
          .limit(10);

      final list = response as List<dynamic>;
      if (list.isNotEmpty && mounted) {
        setState(() {
          _questions = list
              .map((item) =>
                  QuizQuestion.fromMap(Map<String, dynamic>.from(item)))
              .toList();
          _userAnswers = List<int?>.filled(_questions.length, null);
          _currentIndex = 0;
        });
      }
    } catch (_) {
      // Tabel belum ada di Supabase -> tetap memakai placeholderQuestions
    }
  }

  void _startTimerIfNotRunning() {
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
      }
    });
  }

  void _resetTimerForNewQuiz() {
    _timer?.cancel();
    _timer = null;
    _secondsLeft = _initialQuizSeconds;
  }

  void _startQuiz() {
    _resetTimerForNewQuiz();
    setState(() {
      _currentIndex = 0;
      _selectedOptionIndex = null;
      _earnedQuizPoints = _maxQuizPoints;
      _wrongCount = 0;
      _userAnswers = List<int?>.filled(_questions.length, null);
      _stage = _QuizStage.question;
    });
  }

  void _handleSelectOption(int idx) {
    setState(() {
      _selectedOptionIndex = idx;
      _userAnswers[_currentIndex] = idx;
    });
    // Waktu mulai berjalan saat user memencet jawaban dan TIDAK di-reset saat pindah soal
    _startTimerIfNotRunning();
  }

  /// Dipanggil saat user menekan tombol di bawah soal:
  /// - Jika belum soal terakhir: simpan jawaban & langsung lanjut ke soal berikutnya (waktu tetap lanjut).
  /// - Jika sudah soal terakhir: hentikan waktu, hitung pengurangan poin untuk jawaban salah, dan masuk ke halaman Pembahasan.
  void _submitOrNextQuestion() {
    if (_selectedOptionIndex == null) return;

    _userAnswers[_currentIndex] = _selectedOptionIndex;

    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = _userAnswers[_currentIndex];
      });
    } else {
      _timer?.cancel();
      int wrong = 0;
      for (int i = 0; i < _questions.length; i++) {
        if (_userAnswers[i] != _questions[i].correctOptionIndex) {
          wrong++;
        }
      }

      // Poin maksimal 100, berkurang proporsional setiap ada jawaban yang salah
      final penaltyPerWrong = (_maxQuizPoints / _questions.length).round();
      final calculatedPoints =
          (_maxQuizPoints - (wrong * penaltyPerWrong)).clamp(0, _maxQuizPoints);

      setState(() {
        _wrongCount = wrong;
        _earnedQuizPoints = calculatedPoints;
        _currentIndex = 0;
        _selectedOptionIndex = _userAnswers[0];
        _stage = _QuizStage.explanation;
      });
    }
  }

  /// Navigasi di halaman koreksi/pembahasan akhir
  void _nextExplanation() {
    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = _userAnswers[_currentIndex];
      });
    } else {
      final finalEarned = _earnedQuizPoints;
      final totalCorrect = _questions.length - _wrongCount;
      _resetTimerForNewQuiz();
      setState(() {
        _userPoints += finalEarned;
        _currentIndex = 0;
        _selectedOptionIndex = null;
        _stage = _QuizStage.intro;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kuis selesai! Benar $totalCorrect/${_questions.length} soal. Poin bertambah +$finalEarned poin!',
            style: const TextStyle(fontFamily: 'Inter'),
          ),
          backgroundColor: const Color(0xFF35563C),
        ),
      );
    }
  }

  void _handleBack() {
    if (_stage == _QuizStage.explanation) {
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _selectedOptionIndex = _userAnswers[_currentIndex];
        });
      } else {
        setState(() => _stage = _QuizStage.intro);
      }
    } else if (_stage == _QuizStage.question) {
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _selectedOptionIndex = _userAnswers[_currentIndex];
        });
      } else {
        _resetTimerForNewQuiz();
        setState(() {
          _selectedOptionIndex = null;
          _stage = _QuizStage.intro;
        });
      }
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle.merge(
        style: const TextStyle(fontFamily: 'Inter'),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFA9AB8E),
                Color(0xFF4B5842),
                Color(0xFF233220),
              ],
              stops: [0.0, 0.45, 0.9],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildCurrentStage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStage() {
    switch (_stage) {
      case _QuizStage.intro:
        return KuisIntroView(
          key: const ValueKey('intro_stage'),
          totalQuestions: _questions.length,
          userPoints: _userPoints,
          onStartQuiz: _startQuiz,
          onBack: _handleBack,
        );
      case _QuizStage.question:
        return KuisQuestionView(
          key: ValueKey('question_stage_$_currentIndex'),
          question: _questions[_currentIndex],
          currentIndex: _currentIndex,
          totalQuestions: _questions.length,
          activeTab: _activeTab,
          onTabChanged: (tab) => setState(() => _activeTab = tab),
          secondsLeft: _secondsLeft,
          selectedOptionIndex: _selectedOptionIndex,
          onSelectOption: _handleSelectOption,
          onCheckAnswer: _submitOrNextQuestion,
          onBack: _handleBack,
          userPoints: _userPoints,
        );
      case _QuizStage.explanation:
        return KuisExplanationView(
          key: ValueKey('explanation_stage_$_currentIndex'),
          question: _questions[_currentIndex],
          currentIndex: _currentIndex,
          totalQuestions: _questions.length,
          selectedOptionIndex: _selectedOptionIndex,
          userPoints: _userPoints,
          earnedQuizPoints: _earnedQuizPoints,
          wrongCount: _wrongCount,
          onNextQuestion: _nextExplanation,
          onBack: _handleBack,
        );
    }
  }
}
