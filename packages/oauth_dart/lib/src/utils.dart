library oauth.utils;
import 'dart:async';
import 'dart:math';

Future get async => new Future.delayed(const Duration(milliseconds: 0),
                                       () => null);

Random randomSource;
bool _haveWarned = false;

List<int> getRandomBytes(int count) {
    if (randomSource == null) {
      randomSource = new Random.secure();
    }

    // N.B. Random.nextInt():
    // Generates a non-negative random integer uniformly distributed in the
    // range from 0, inclusive, to max, *exclusive*.
    return new List<int>.generate(count,
      (_) => randomSource.nextInt(256), growable: false);
}
