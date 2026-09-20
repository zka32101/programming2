import 'package:flutter/material.dart';
import 'package:shared_core/utils/parental_gate_helper.dart' as shared;

/// 保護者確認ゲート。shared_core の計算問題ゲートに委譲する（固定PINは使わない）。
class ParentalGateService {
  static Future<bool> requireParentalGate(BuildContext context) {
    return shared.requireParentalGate(context);
  }
}
