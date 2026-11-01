import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import 'kuis_shared_widgets.dart';

class KuisQuestionView extends StatelessWidget {
  final QuizQuestion question;
  final int currentIndex;
  final int totalQuestions;
  final int activeTab;
  final ValueChanged<int> onTabChanged;
  final int secondsLeft;
  final int? selectedOptionIndex;
  final ValueChanged<int> onSelectOption;
  final VoidCallback onCheckAnswer;
  final VoidCallback onBack;
  final int userPoints;

  const KuisQuestionView({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.activeTab,
    required this.onTabChanged,
    required this.secondsLeft,
    required this.selectedOptionIndex,
    required this.onSelectOption,
    required this.onCheckAnswer,
    required this.onBack,
    required this.userPoints,
  });

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final displayNumber = currentIndex + 1;
    final progressValue = (displayNumber / totalQuestions).clamp(0.1, 1.0);

    return Column(
      children: [
        KuisTopHeader(
          subtitle: 'Belajar sambil menantang diri',
          showHelpButton: true,
          onBack: onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
            children: [
              // Segmented Switch: Kuis | Papan Peringkat
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD0C1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTabChanged(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: activeTab == 0
                                ? const Color(0xFF2B2921)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Kuis',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontFamilyFallback: kInterFallback,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: activeTab == 0
                                  ? Colors.white
                                  : const Color(0xFF3E3D35),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTabChanged(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: activeTab == 1
                                ? const Color(0xFF2B2921)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Papan Peringkat',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontFamilyFallback: kInterFallback,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: activeTab == 1
                                  ? Colors.white
                                  : const Color(0xFF3E3D35),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              if (activeTab == 1)
                KuisLeaderboardCard(userPoints: userPoints)
              else ...[
                // Baris Info Pertanyaan & Timer (Tanpa Hati / Nyawa)
                Row(
                  children: [
                    Text(
                      'Pertanyaan $displayNumber dari $totalQuestions',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF283322),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.timer_outlined,
                      size: 15,
                      color: Color(0xFF283322),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTimer(secondsLeft),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF283322),
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
                  badgeText: question.category,
                  height: 155,
                ),
                const SizedBox(height: 16),

                Text(
                  question.question,
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    fontFamilyFallback: kLoraFallback,
                    fontSize: 22,
                    height: 1.28,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF6F3EA),
                  ),
                ),
                const SizedBox(height: 14),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF20301E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '1  Pilih satu jawaban   /   2  Periksa jawaban',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6E4D8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                ...List.generate(question.options.length, (idx) {
                  final letter = String.fromCharCode(65 + idx);
                  final isSelected = selectedOptionIndex == idx;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => onSelectOption(idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF243923)
                              : const Color(0xFFA2AB94),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF5E7759)
                                : Colors.transparent,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF4E654B)
                                    : const Color(0xFF5D6A53),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontFamilyFallback: kInterFallback,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                question.options[idx],
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontFamilyFallback: kInterFallback,
                                  fontSize: 13.5,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: const Color(0xFFF6F3EA),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.radio_button_checked_rounded,
                                size: 18,
                                color: Color(0xFFB5C4AD),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE3D2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'STATUS JAWABAN',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontFamilyFallback: kInterFallback,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFF6B6E5E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        selectedOptionIndex != null
                            ? 'Pilihan belum diperiksa'
                            : 'Belum ada pilihan dipilih',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontFamilyFallback: kInterFallback,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F261D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        selectedOptionIndex != null
                            ? 'Satu jawaban sedang dipilih. Kamu masih dapat meninjau pilihan sebelum melanjutkan. Penjelasan dan jawaban tepat ditampilkan setelah seluruh soal selesai.'
                            : 'Pilih salah satu opsi A, B, C, atau D di atas untuk mulai menjawab.',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontFamilyFallback: kInterFallback,
                          fontSize: 12,
                          height: 1.5,
                          color: Color(0xFF3A4134),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                KuisPrimaryButton(
                  label: currentIndex + 1 < totalQuestions
                      ? 'Lanjut ke pertanyaan ${currentIndex + 2}'
                      : 'Periksa jawaban',
                  leadingIcon: Icons.arrow_forward_rounded,
                  onTap: selectedOptionIndex != null ? onCheckAnswer : null,
                ),
                const SizedBox(height: 10),

                Center(
                  child: Text(
                    'Poinmu $userPoints · Maksimal +100 poin (berkurang jika ada jawaban salah).',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontSize: 11,
                      color: Color(0xFFD0D5C5),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
