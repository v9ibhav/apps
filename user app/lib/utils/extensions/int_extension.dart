import '../../main.dart';

extension IntExt on int {
  String get monthName {
    switch (this) {
      case 1:
        return language.january;
      case 2:
        return language.february;
      case 3:
        return language.march;
      case 4:
        return language.april;
      case 5:
        return language.may;
      case 6:
        return language.june;
      case 7:
        return language.july;
      case 8:
        return language.august;
      case 9:
        return language.september;
      case 10:
        return language.october;
      case 11:
        return language.november;
      case 12:
        return language.december;

      default:
        return language.monthName;
    }
  }

  String get weekDayName {
    switch (this) {
      case 1:
        return language.mon;
      case 2:
        return language.tue;
      case 3:
        return language.wed;
      case 4:
        return language.thu;
      case 5:
        return language.fri;
      case 6:
        return language.sat;
      case 7:
        return language.sun;

      default:
        return language.weekName;
    }
  }
}
