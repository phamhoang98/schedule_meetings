bool isBeforeTime(DateTime first, DateTime last) {
  if (first.hour < last.hour ||
      (first.hour == last.hour && first.minute < last.minute)) {
    return true;
  }
  return false;
}

bool isAtSameMomentAsTime(DateTime first, DateTime last) {
  if (first.hour == last.hour && first.minute == last.minute) {
    return true;
  }
  return false;
}

bool isAfterTime(DateTime first, DateTime last) {
  if (first.hour > last.hour ||
      (first.hour == last.hour && first.minute > last.minute)) {
    return true;
  }
  return false;
}
