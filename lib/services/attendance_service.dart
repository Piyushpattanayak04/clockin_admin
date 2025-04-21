// attendance_service.dart

import '../models/team.dart';

class AttendanceService {
  static void markCheckin(Team team) {
    team.checkin = true;
  }

  static void markLunch(Team team) {
    team.lunch = true;
  }

  static void markDinner(Team team) {
    team.dinner = true;
  }

  static void markCheckout(Team team) {
    team.checkout = true;
  }

  static void resetAttendance(Team team) {
    team.checkin = false;
    team.lunch = false;
    team.dinner = false;
    team.checkout = false;
  }
}
