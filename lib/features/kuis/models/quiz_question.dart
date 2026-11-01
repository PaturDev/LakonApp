class QuizQuestion {
  final String id;
  final String category;
  final String question;
  final String imageUrl;
  final List<String> options; // [Opsi A, Opsi B, Opsi C, Opsi D]
  final int correctOptionIndex; // 0 = A, 1 = B, 2 = C, 3 = D
  final String explanation;
  final String source;
  final String whyCorrectTitle;
  final String whyCorrectBody;
  final String topicName;

  const QuizQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.imageUrl,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.source,
    required this.whyCorrectTitle,
    required this.whyCorrectBody,
    required this.topicName,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    List<String> parsedOptions = [];
    if (map['options'] is List) {
      parsedOptions = List<String>.from(map['options']);
    } else {
      parsedOptions = [
        (map['opsi_a'] ?? map['jawaban_a'] ?? 'Pilihan A').toString(),
        (map['opsi_b'] ?? map['jawaban_b'] ?? 'Pilihan B').toString(),
        (map['opsi_c'] ?? map['jawaban_c'] ?? 'Pilihan C').toString(),
        (map['opsi_d'] ?? map['jawaban_d'] ?? 'Pilihan D').toString(),
      ];
    }

    int correctIdx = 0;
    final rawCorrect =
        map['correct_option_index'] ?? map['jawaban_benar'] ?? map['jawaban'];
    if (rawCorrect is int) {
      correctIdx = rawCorrect.clamp(0, 3);
    } else if (rawCorrect is String) {
      final upper = rawCorrect.trim().toUpperCase();
      if (upper == 'A') {
        correctIdx = 0;
      } else if (upper == 'B') {
        correctIdx = 1;
      } else if (upper == 'C') {
        correctIdx = 2;
      } else if (upper == 'D') {
        correctIdx = 3;
      } else {
        final matchIndex = parsedOptions.indexWhere(
          (o) => o.toLowerCase() == rawCorrect.trim().toLowerCase(),
        );
        if (matchIndex != -1) correctIdx = matchIndex;
      }
    }

    return QuizQuestion(
      id: (map['id'] ?? '').toString(),
      category: (map['kategori'] ?? map['category'] ?? 'SITUS BERSEJARAH')
          .toString()
          .toUpperCase(),
      question:
          (map['pertanyaan'] ?? map['soal'] ?? map['question'] ?? '').toString(),
      imageUrl:
          (map['gambar_soal'] ?? map['image_url'] ?? map['gambar'] ?? '')
              .toString(),
      options: parsedOptions,
      correctOptionIndex: correctIdx,
      explanation: (map['pembahasan'] ??
              map['penjelasan'] ??
              map['explanation'] ??
              'Penjelasan untuk pertanyaan ini.')
          .toString(),
      source: (map['sumber'] ??
              map['source'] ??
              'Sumber: Ensiklopedia Warisan Budaya Jawa')
          .toString(),
      whyCorrectTitle: (map['judul_alasan'] ??
              map['why_correct_title'] ??
              'Pahami konteks sejarah dan budaya')
          .toString(),
      whyCorrectBody: (map['isi_alasan'] ??
              map['why_correct_body'] ??
              'Memahami detail lokasi, motif, dan tokoh membantu kita mengenal warisan budaya secara utuh.')
          .toString(),
      topicName: (map['topik'] ?? map['topic_name'] ?? 'Materi').toString(),
    );
  }
}

const List<QuizQuestion> placeholderQuestions = [
  QuizQuestion(
    id: '1',
    category: 'SITUS BERSEJARAH',
    question: 'Di kota atau kabupaten mana Candi Borobudur berada?',
    imageUrl: '',
    options: [
      'Kota Semarang',
      'Kabupaten Magelang',
      'Kota Surakarta',
      'Kabupaten Klaten',
    ],
    correctOptionIndex: 1,
    explanation:
        'Borobudur berada di Kabupaten Magelang, Jawa Tengah, bukan di Kota Magelang atau Yogyakarta. Candi Buddha ini dibangun pada abad VIII–IX pada masa Dinasti Syailendra.',
    source: 'Sumber: UNESCO - Borobudur Temple Compounds',
    whyCorrectTitle: 'Bedakan kota dan kabupaten',
    whyCorrectBody:
        'Kabupaten Magelang adalah jawaban yang tepat. Nama wilayah administratif penting: dekatnya sebuah situs dengan kota lain tidak berarti situs itu berada di kota tersebut.',
    topicName: 'Borobudur',
  ),
  QuizQuestion(
    id: '2',
    category: 'WARISAN BATIK',
    question: 'Apa makna filosofis utama dari motif Batik Kawung?',
    imageUrl: '',
    options: [
      'Keberanian di medan perang',
      'Kesucian hati dan pengendalian diri',
      'Kemakmuran hasil laut',
      'Perjalanan para pedagang',
    ],
    correctOptionIndex: 1,
    explanation:
        'Motif Batik Kawung terinspirasi dari buah kolang-kaling (aren) yang tersusun empat sisi, melambangkan hati yang bersih, kesucian, dan pengendalian diri yang seimbang.',
    source: 'Sumber: Museum Batik Indonesia',
    whyCorrectTitle: 'Filosofi empat penjuru pada Kawung',
    whyCorrectBody:
        'Pola geometris empat bulatan yang mengelilingi satu pusat pada Kawung melambangkan pusat energi dan kemurnian niat manusia.',
    topicName: 'Batik Kawung',
  ),
  QuizQuestion(
    id: '3',
    category: 'SENI PERTUNJUKAN',
    question: 'Siapakah tokoh Pandawa yang dikenal sebagai pemanah ulung?',
    imageUrl: '',
    options: [
      'Yudhistira',
      'Bima',
      'Arjuna',
      'Nakula',
    ],
    correctOptionIndex: 2,
    explanation:
        'Arjuna (Janaka) adalah putra ketiga Pandawa yang terkenal karena ketenangan batin, ketampanan, dan keahliannya memanah dengan pusaka Panah Pasopati.',
    source: 'Sumber: Ensiklopedia Wayang Purwa',
    whyCorrectTitle: 'Karakteristik tokoh Pandawa',
    whyCorrectBody:
        'Dalam pewayangan Jawa, Arjuna melambangkan fokus dan keteguhan pikiran ketika menjalankan dharma seorang kesatria.',
    topicName: 'Wayang Arjuna',
  ),
];

