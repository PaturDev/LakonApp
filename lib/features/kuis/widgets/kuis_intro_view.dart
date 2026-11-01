import 'package:flutter/material.dart';
import 'kuis_shared_widgets.dart';

class KuisIntroView extends StatelessWidget {
  final int totalQuestions;
  final int userPoints;
  final VoidCallback onStartQuiz;
  final VoidCallback onBack;

  const KuisIntroView({
    super.key,
    required this.totalQuestions,
    required this.userPoints,
    required this.onStartQuiz,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KuisTopHeader(
          subtitle: 'Kembali ke Beranda',
          showHelpButton: false,
          onBack: onBack,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
            children: [
              const Text(
                'E · MENGUJI PEMAHAMAN / 11',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontFamilyFallback: kInterFallback,
                  fontSize: 11,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE6E4D8),
                ),
              ),
              const SizedBox(height: 12),

              const KuisQuestionImage(
                imageUrl: '',
                height: 155,
              ),
              const SizedBox(height: 14),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22311F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'TANTANGAN HARIAN',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: Color(0xFFE6E4D8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Seberapa dekat kamu\ndengan warisan kita?',
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontFamilyFallback: kLoraFallback,
                  fontSize: 28,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF6F3EA),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Tema: situs bersejarah, batik, dan wayang. Uji hal-hal\nyang sudah kamu pelajari.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontFamilyFallback: kInterFallback,
                  fontSize: 12.5,
                  height: 1.45,
                  color: Color(0xFFD7DACB),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE3D2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$totalQuestions',
                            style: const TextStyle(
                              fontFamily: 'Lora',
                              fontFamilyFallback: kLoraFallback,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F261D),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Pertanyaan pilihan ganda',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontFamilyFallback: kInterFallback,
                              fontSize: 11.5,
                              color: Color(0xFF4A5043),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE3D2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+100',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontFamilyFallback: kLoraFallback,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F261D),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Poin setelah selesai',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontFamilyFallback: kInterFallback,
                              fontSize: 11.5,
                              color: Color(0xFF4A5043),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE3D2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sebelum mulai',
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontFamilyFallback: kLoraFallback,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F261D),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Pilih satu jawaban di setiap pertanyaan, lalu lanjut ke soal berikutnya.\n'
                      '2. Koreksi dan penjelasan ditampilkan di akhir setelah semua soal dijawab.\n'
                      '3. Selesaikan semua pertanyaan dengan benar untuk maksimal +100 poin.\n'
                      'Pantau timer kuis. Setiap jawaban yang salah akan mengurangi poin.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 12,
                        height: 1.55,
                        color: Color(0xFF3A4134),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Sekitar 5 menit · Pembahasan tersedia di akhir.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontFamilyFallback: kInterFallback,
                  fontSize: 11.5,
                  color: Color(0xFFD0D5C5),
                ),
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE0D1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PERSIAPAN BELAJAR',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: Color(0xFF5A6552),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Pahami, bukan sekadar hafal',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F261D),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Ingat kembali lokasi dan bentuk Borobudur, makna Kawung, serta peran Arjuna. Kuis menghubungkan materi itu; baca setiap pilihan sebelum memeriksa jawaban.',
                      style: TextStyle(
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
                'Poinmu saat ini $userPoints · Bonus diberikan setelah kuis selesai.',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontFamilyFallback: kInterFallback,
                  fontSize: 11,
                  color: Color(0xFFD0D5C5),
                ),
              ),
              const SizedBox(height: 10),

              KuisPrimaryButton(
                label: 'Mulai $totalQuestions pertanyaan',
                trailingIcon: Icons.arrow_forward_rounded,
                onTap: onStartQuiz,
              ),
              const SizedBox(height: 12),

              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Belajar dulu di Jelajah',
                    style: TextStyle(
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
