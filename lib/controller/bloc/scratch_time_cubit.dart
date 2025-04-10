import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScratchTimerCubit extends Cubit<String> {
  ScratchTimerCubit() : super("Now");

  DateTime? nextScratchTime;
  Timer? countdownTimer;

  void startTimer(DateTime nextTime) {
    nextScratchTime = nextTime;
    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(_getRemainingTime());
    });
  }

  void stopTimer() {
    countdownTimer?.cancel();
    nextScratchTime = null;
    emit("Now");
  }

  String _getRemainingTime() {
    if (nextScratchTime == null) return "Now";

    Duration diff = nextScratchTime!.difference(DateTime.now());

    if (diff.isNegative) {
      countdownTimer?.cancel();
      return "Now";
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(diff.inHours)}:${twoDigits(diff.inMinutes.remainder(60))}:${twoDigits(diff.inSeconds.remainder(60))}";
  }

  @override
  Future<void> close() {
    countdownTimer?.cancel();
    return super.close();
  }
}
