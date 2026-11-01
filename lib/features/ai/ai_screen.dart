import 'package:flutter/material.dart';

import '/services/ai_service.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final AIService _aiService = AIService();

  final List<Map<String, String>> _messages = [];

  bool _isLoading = false;

  static const List<Map<String, dynamic>> _suggestions = [
    {
      'icon': Icons.account_balance_outlined,
      'text': 'Jelaskan Candi Borobudur',
    },
    {
      'icon': Icons.brush_outlined,
      'text': 'Apa makna motif Kawung?',
    },
    {
      'icon': Icons.theater_comedy_outlined,
      'text': 'Siapa itu Arjuna?',
    },
  ];

  void _scrollToChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _sendMessage() async {
    final question = _messageController.text.trim();

    if (question.isEmpty || _isLoading) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _messages.add({'role': 'user', 'text': question});
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToChat();

    try {
      final answer = await _aiService.ask(question);

      if (!mounted) return;

      setState(() {
        _messages.add({'role': 'ai', 'text': answer});
      });
      _scrollToChat();
    } catch (e, stackTrace) {
      debugPrint('AI ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _messages.add({'role': 'ai', 'text': 'Error detail:\n$e'});
      });
      _scrollToChat();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _scrollToChat();
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasStartedChat = _messages.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EA),
      body: Column(
        children: [
          // ===================================================================
          // HEADER HIJAU TUA
          // ===================================================================
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF273524),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 18, 14),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (hasStartedChat) {
                          setState(() {
                            _messages.clear();
                          });
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Asisten AI',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFF6F3EA),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Laras · Teman belajar budayamu',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color: Color(0xFFC9D0C1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===================================================================
          // KONTEN UTAMA (AWAL vs MODE CHAT)
          // ===================================================================
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              children: [
                if (!hasStartedChat) ...[
                  const Text(
                    'F · MELANJUTKAN RASA INGIN TAHU / 15',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Color(0xFF596353),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Ikon Sparkle Tengah
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA2AC94),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_outlined,
                        size: 32,
                        color: Color(0xFF563D35),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Judul "Apa yang ingin kamu ketahui?"
                  const Text(
                    'Apa yang ingin kamu\nketahui?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 27,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF283A27),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Kartu Sapaan Awal Laras
                  _buildLarasBubble(
                    'Halo, Nabila! Mau menjelajahi candi, batik, atau kisah wayang hari ini?',
                  ),
                  const SizedBox(height: 12),

                  // Kartu "TIGA LANGKAH BERSAMA LARAS"
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E6DA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TIGA LANGKAH BERSAMA LARAS',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFF53604D),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildStepRow(
                          '01',
                          'Pilih satu topik yang ingin kamu jelajahi.',
                        ),
                        const SizedBox(height: 6),
                        _buildStepRow(
                          '02',
                          'Pilih saran atau tulis pertanyaanmu sendiri.',
                        ),
                        const SizedBox(height: 6),
                        _buildStepRow(
                          '03',
                          'Kirim pertanyaan, lalu periksa rujukannya.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bagian "MULAI DARI PERTANYAAN INI"
                  const Text(
                    'MULAI DARI PERTANYAAN INI',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Color(0xFF53604D),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ..._suggestions.map((item) {
                    final text = item['text'] as String;
                    final icon = item['icon'] as IconData;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            _messageController.text = text;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF8F3),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE3DECF)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                size: 20,
                                color: const Color(0xFF283A27),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF232C20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ] else ...[
                  // ===========================================================
                  // MODE CHAT: HANYA CHAT AI & PERTANYAAN PENGGUNA
                  // ===========================================================
                  _buildLarasBubble(
                    'Halo, Nabila! Mau menjelajahi candi, batik, atau kisah wayang hari ini?',
                  ),
                  const SizedBox(height: 12),

                  ..._messages.map((message) {
                    final isUser = message['role'] == 'user';
                    final text = message['text'] ?? '';

                    if (isUser) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.78,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF273524),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: SelectableText(
                              text,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.5,
                                height: 1.48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildLarasBubble(text),
                      );
                    }
                  }),

                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF8F3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE3DECF)),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF273524),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Laras sedang berpikir...',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.5,
                                color: Color(0xFF2A3327),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),
                ],

                // =============================================================
                // KOTAK PESAN & TOMBOL KIRIM PERTANYAAN
                // =============================================================
                const Text(
                  'Pertanyaanmu',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4C5646),
                  ),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _messageController,
                  enabled: !_isLoading,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                    color: Color(0xFF232C20),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Jelaskan Candi Borobudur',
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.5,
                      color: Color(0xFF6B7364),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFAF8F3),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    suffixIcon: const Icon(
                      Icons.mic_none_rounded,
                      color: Color(0xFF3E4A3B),
                      size: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF6E7765),
                        width: 1.1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF273524),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                if (!hasStartedChat) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Jawaban menyertakan rujukan untuk diperiksa.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF60695A),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Kartu "PERTANYAAN YANG LEBIH TERARAH" (hanya di tampilan awal)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E6DA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PERTANYAAN YANG LEBIH TERARAH',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFF53604D),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Sebutkan hal yang ingin dipahami',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF233121),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Mulai dari satu topik, lalu tambahkan fokus: makna motif, susunan candi, atau nilai tokoh. Pertanyaan yang spesifik membantu kamu menilai apakah jawaban sudah menjawab rasa ingin tahumu.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            height: 1.5,
                            color: Color(0xFF3E4739),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Divider(
                    color: Color(0xFFE2DDD0),
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'AI dapat keliru. Periksa kembali sumber penting.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF60695A),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Tombol "Kirim pertanyaan ->"
                GestureDetector(
                  onTap: _isLoading ? null : _sendMessage,
                  child: Opacity(
                    opacity: _isLoading ? 0.6 : 1.0,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21321F),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Kirim pertanyaan',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLarasBubble(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3DECF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Laras',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5B6455),
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.5,
              height: 1.48,
              color: Color(0xFF2A3327),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF53604D),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: Color(0xFF333D2E),
            ),
          ),
        ),
      ],
    );
  }
}
