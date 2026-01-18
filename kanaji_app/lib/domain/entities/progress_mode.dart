enum ProgressMode { practice, test}

int modeToInt(ProgressMode mode) {
  switch (mode) {
    case ProgressMode.practice:
      return 0;
    case ProgressMode.test:
      return 1;
  }
}

ProgressMode intToMode(int value) {
  switch (value) {
    case 0:
      return ProgressMode.practice;
    case 1:
      return ProgressMode.test;
    default:
      throw ArgumentError('Invalid integer value for ProgressMode: $value');
  }
}