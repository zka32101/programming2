import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kokugo_kore/utils/constants.dart';

void main() {
  test('AppConstants.appVersion matches pubspec.yaml', () {
    final line = File('pubspec.yaml')
        .readAsLinesSync()
        .firstWhere((l) => l.startsWith('version:'));
    final v = line.split(':')[1].trim().split('+').first;
    expect(AppConstants.appVersion, v);
  });
}
