import '../models/enums.dart';

DateTime calcExpireAt(DateTime createAt, int days){
  return createAt.add(Duration(days: days));
}

int calcDDay(DateTime expireAt){
  final now = DateTime.now();
  final nowDate = DateTime(now.year, now.month, now.day);
  final expireDate = DateTime(expireAt.year, expireAt.month, expireAt.day);
  return expireDate.difference(nowDate).inDays;
}

DDayStatus getDDayStatus(int day){
  if(day < 0) return DDayStatus.expired;
  if(day == 0) return DDayStatus.today;
  if(day <= 2) return DDayStatus.soon;

  return DDayStatus.safe;
}

String formatDDay(int dDay){
  if(dDay < 0) return 'D+${dDay.abs()}';
  if(dDay == 0) return 'D-Day';
  return 'D-$dDay';
}