library calendar_logic;

import 'package:flutter/gestures.dart';

/// A Calculator.
class CalendarBuilder {
  /// [date]が表す日が所属するカレンダーを生成
  List<List<int?>> build(DateTime date) {
    final calendar = <List<int?>>[];

    final firstWeekday = _calcFirstWeekday(date);
    final lastDate = _calcLastDate(date);

    // 1周目のカレンダーデータの生成
    final firstWeek = List.generate(7, (index) {
      final i = index + 1; // indexは0始まりのため、1始まりの曜日と合わせる
      final offset = i - firstWeekday; // その月の1日の曜日との差
      return i < firstWeekday ? null : 1 + offset;
    });

    calendar.add(firstWeek);

    while (true) {
      final firstDateOfWeek = calendar.last.last! + 1; // 前の週の最終日の次の日のスタート

      // 1週間分のデータを生成
      final week = List.generate(7, (index) {
        final date = firstDateOfWeek + index; // 追加する日付
        return date <= lastDate ? date : null; // 最終日以前なら採用、それ以降はnull
      });

      calendar.add(week); // 週のリストを月のリストに追加

      // すでに最終日まで追加し終わっていたら終了
      final lastDateOfWeek = week.last;
      if (lastDateOfWeek == null || lastDateOfWeek >= lastDate) {
        break;
      }
    }

    return calendar;
  }
}

/// [date]が所属する月の1日の曜日を計算
/// 月曜日を1、日曜日を7とする
int _calcFirstWeekday(DateTime date) {
  return DateTime(date.year, date.month, 1).weekday;
}

/// [date]が所属する月の最後の日を計算
int _calcLastDate(DateTime date) {
  return DateTime(date.year, date.month + 1, 0).day;
}
