// 達成演出(バッジ獲得・レベルアップ)の共通アート部品。見た目のみ。
import 'package:flutter/material.dart';

const Color _kCelebrateBrown = Color(0xFF461905);

/// 星バースト + (メダル|トロフィー) + リボン。
/// [levelUp] が true のときは トロフィー + 矢印 + リボン(ribbonText)。
class CelebrateArt extends StatelessWidget {
  final String ribbonText;
  final bool levelUp;

  const CelebrateArt({super.key, required this.ribbonText, this.levelUp = false});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: 260,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Image.asset('assets/celebrate/celebrate_starburst.webp', width: 250),
            ),
            if (levelUp) ...[
              Positioned(
                top: 40,
                child: Image.asset('assets/celebrate/celebrate_trophy.webp', width: 110),
              ),
              Positioned(
                top: 140,
                child: Image.asset('assets/celebrate/levelup_arrow.webp', width: 70),
              ),
            ] else
              Positioned(
                top: 55,
                child: Image.asset('assets/celebrate/celebrate_medal.webp', width: 130),
              ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/celebrate/celebrate_ribbon_banner.webp', width: 260),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          ribbonText,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: _kCelebrateBrown,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
