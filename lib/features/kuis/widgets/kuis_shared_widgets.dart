import 'package:flutter/material.dart';

const List<String> kLoraFallback = ['Georgia', 'serif'];
const List<String> kInterFallback = ['Roboto', 'sans-serif'];

class KuisTopHeader extends StatelessWidget {
  final String subtitle;
  final bool showHelpButton;
  final VoidCallback onBack;

  const KuisTopHeader({
    super.key,
    required this.subtitle,
    required this.onBack,
    this.showHelpButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF1E2D1C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Arena Pengetahuan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontFamilyFallback: kInterFallback,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontFamilyFallback: kInterFallback,
                    fontSize: 11.5,
                    color: Color(0xFFD7DACB),
                  ),
                ),
              ],
            ),
          ),
          if (showHelpButton)
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Pilih salah satu jawaban A/B/C/D lalu tekan Periksa jawaban.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white70, width: 1.2),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontFamilyFallback: kInterFallback,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KuisQuestionImage extends StatelessWidget {
  final String imageUrl;
  final String? badgeText;
  final double height;

  const KuisQuestionImage({
    super.key,
    required this.imageUrl,
    this.badgeText,
    this.height = 155,
  });

  @override
  Widget build(BuildContext context) {
    final hasNetworkUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: height,
            child: hasNetworkUrl
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/BgHome.jpeg',
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/BgHome.jpeg',
                    fit: BoxFit.cover,
                  ),
          ),
          if (badgeText != null && badgeText!.isNotEmpty)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EFE6).withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontFamilyFallback: kInterFallback,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: Color(0xFF22311F),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class KuisPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;

  const KuisPrimaryButton({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.55,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF21321F),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF566B50),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontFamilyFallback: kInterFallback,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, size: 18, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class KuisLeaderboardCard extends StatelessWidget {
  final int userPoints;

  const KuisLeaderboardCard({
    super.key,
    required this.userPoints,
  });

  @override
  Widget build(BuildContext context) {
    final rankings = [
      {'name': 'Raka Pratama', 'points': '1.540 pts'},
      {'name': 'Kamu (Lakon)', 'points': '$userPoints pts'},
      {'name': 'Saraswati', 'points': '1.120 pts'},
      {'name': 'Bagas Adi', 'points': '980 pts'},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE3D2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Papan Peringkat Mingguan',
            style: TextStyle(
              fontFamily: 'Lora',
              fontFamilyFallback: kLoraFallback,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F261D),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(rankings.length, (i) {
            final item = rankings[i];
            final isMe = i == 1;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF243923) : const Color(0xFFDCE0D1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    '#${i + 1}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.white : const Color(0xFF1F261D),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item['name']!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontFamilyFallback: kInterFallback,
                        fontWeight: FontWeight.w600,
                        color: isMe ? Colors.white : const Color(0xFF1F261D),
                      ),
                    ),
                  ),
                  Text(
                    item['points']!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontFamilyFallback: kInterFallback,
                      fontWeight: FontWeight.w600,
                      color: isMe
                          ? const Color(0xFFEDE3D2)
                          : const Color(0xFF4A5043),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
