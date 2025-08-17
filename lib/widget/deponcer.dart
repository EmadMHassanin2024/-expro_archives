import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer({this.milliseconds});
  final int? milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}

final _debouncer = Debouncer(milliseconds: 300);
