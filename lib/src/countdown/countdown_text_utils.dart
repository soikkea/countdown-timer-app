import 'package:intl/intl.dart';

String padNumber(int number) {
  return number.toString().padLeft(2, "0");
}

String formatTarget(DateTime targetInUtc) {
  return DateFormat("yyyy-MM-dd HH:mm").format(targetInUtc.toLocal());
}

String formatDurationToTarget(DateTime targetInUtc, DateTime currentTimeInLocal,
    {bool includeMillis = false}) {
  // TODO: Handle case when duration negative
  final duration = getDurationInLocal(targetInUtc, currentTimeInLocal);
  final days = duration.inDays;
  final hours = duration.inHours % 24;
  final minutes = duration.inMinutes % 60;
  final seconds = duration.inSeconds % 60;
  int millis = ((duration.inMilliseconds % 1000) / 100).round();
  millis = millis == 10 ? 0 : millis;
  var sb = StringBuffer();
  sb
    ..write(
        '${days.toString()} d, ${padNumber(hours)}:${padNumber(minutes)}:${padNumber(seconds)}')
    ..write(includeMillis ? '.${millis.toString()}' : '');

  return sb.toString();
}

Duration getDurationInLocal(DateTime targetInUtc, DateTime currentInLocal) {
  final targetInLocal = targetInUtc.toLocal();
  return targetInLocal.isAfter(currentInLocal)
      ? targetInLocal.difference(currentInLocal)
      : currentInLocal.difference(targetInLocal);
}
