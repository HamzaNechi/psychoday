import 'package:psychoday/models/user.dart';

class Appointement {
  String? patient;
  User? doctor;
  String? schedule;
  DateTime? date;
  String? time;
  String? day;
  bool? upcoming;
  bool? canceled;

  Appointement(this.patient, this.doctor, this.date, this.time, this.day,
      this.upcoming, this.canceled);
  Appointement.AppointementWithFourParameter(
      {this.doctor, this.date, this.time,this.day});
}
