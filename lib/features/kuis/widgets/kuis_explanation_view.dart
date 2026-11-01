import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import 'kuis_shared_widgets.dart';

class KuisExplanationView extends StatelessWidget {
  final QuizQuestion question;
  final int currentIndex;
  final int totalQuestions;
  final int? selectedOptionIndex;
  final int userPoints;
  final int earnedQuizPoints;
  final int wrongCount;
  final VoidCallback onNextQuestion;
  final VoidCallback onBack;

  const KuisExplanationView({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.selectedOptionIndex,
    required this.userPoints,
    required this.earnedQuizPoints,
    required this.wrongCount,
    required this.onNextQuestion,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final displayNumber = currentIndex + 1;
    final nextNumber = displayNumber + 1;
    final progressValue = (displayNumber / totalQuestions).clamp(0.1, 1.0);
    final isCorrect = selectedOptionIndex == question.correctOptionIndex;

    return Column(
      children: [
        KuisTopHeader(
          subtitle: 'Pembahasan pertanyaan $displayNumber',
          showHelpButton: false,
          onBack: onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
            children: [
              const Text(
                'E · MENGUJI PEMAHAMAN / 12',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontFamilyFallback: kInterFallback,
                  fontSize: 11,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE6E4D8),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pertanyaan $displayNumber dari $totalQuestions',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE6E4D8),
                    ),
                  ),
                  Text(
                    'Poin kuis: +$earnedQuizPoints / 100',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6E4D8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 5,
                  backgroundColor: const Color(0xFFD6D8C9),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF253723),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              KuisQuestionImage(
                imageUrl: question.imageUrl,
                height: 130,
              ),
              const SizedBox(height: 14),

              Text(
                question.question,
                style: const TextStyle(
                  fontFamily: 'Lora',
                  fontFamilyFallback: kLoraFallback,
                  fontSize: 21,
                  height: 1.28,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF6F3EA),
                ),
              ),
              const SizedBox(height: 12),

              ...List.generate(question.options.length, (idx) {
                final letter = String.fromCharCode(65 + idx);
                final isRightOption = idx == question.correctOptionIndex;
                final isUserWrongChoice =
                    idx == selectedOptionIndex && !isRightOption;

                Color bgColor = const Color(0xFFA2AB94);
                Color textColor = const Color(0xFF232C20);
                if (isRightOption) {
                  bgColor = const Color(0xFF425D40);
                  textColor = Colors.white;
                } else if (isUserWrongChoice) {
                  bgColor = const Color(0xFF6E433B);
                  textColor = Colors.white;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$letter · ${question.options[idx]}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontFamilyFallback: kInterFallback,
                              fontSize: 13,
                              fontWeight: isRightOption
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (isRightOption)
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        else if (isUserWrongChoice)
                          const Icon(
                            Icons.cancel_outlined,
                            size: 18,
                            color: Colors.white70,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE3D2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'Tepat sekali!' : 'Kurang tepat!',
                      style: const TextStyle(
                        fontFamily: 'Lora',
                        fontFamilyFallback: kLoraFallback,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F261D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      question.explanation,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF3A4134),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      question.source,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF596150),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      displayNumber < totalQuestions
                          ? 'Ingat lokasinya, pahami sejarahnya, lalu lanjutkan ke pembahasan $nextNumber.'
                          : 'Ingat lokasinya, pahami sejarahnya, lalu selesaikan kuis ini.',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 11.5,
                        color: Color(0xFF3A4134),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE0D1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MENGAPA JAWABAN INI TEPAT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF5A6552),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.whyCorrectTitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F261D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.whyCorrectBody,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 12,
                        height: 1.5,
                        color: Color(0xFF374031),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Text(
                wrongCount == 0
                    ? 'Poinmu $userPoints · Semua benar! Kamu dapat penuh +$earnedQuizPoints poin.'
                    : 'Poinmu $userPoints · Ada $wrongCount salah, poin berkurang menjadi +$earnedQuizPoints poin.',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontFamilyFallback: kInterFallback,
                  fontSize: 11,
                  color: Color(0xFFD0D5C5),
                ),
              ),
              const SizedBox(height: 10),

              KuisPrimaryButton(
                label: displayNumber < totalQuestions
                    ? 'Lanjut ke pembahasan $nextNumber'
                    : 'Selesaikan Kuis',
                trailingIcon: Icons.arrow_forward_rounded,
                onTap: onNextQuestion,
              ),
              const SizedBox(height: 12),

              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Lihat kembali ${question.topicName}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6E4D8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
