import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/simple_date_helper.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/user_history_screen.dart/data/model/user_history_model.dart';
import 'package:gogo/ui/user_screens/user_history_screen.dart/ui/widgets/user_history_card.dart';

class UserHistoryList extends StatelessWidget {
  final List<UserHistory> history;

  const UserHistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final sortedHistory = [...history]..sort((a, b) => b.date.compareTo(a.date));
    final groupedHistory = <String, List<UserHistory>>{};
    for (var item in sortedHistory) {
      final groupKey = SimpleDateHelper.format(item.date);
      groupedHistory.putIfAbsent(groupKey, () => []).add(item);
    }
    return ListView(
      children: groupedHistory.entries.map((entry) {
        final groupTitle = entry.key;
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 20.w),
              child: Text(
                groupTitle,
                style: TextStyles.font15Blackbold()
              ),
            ),
            ...items.map((item) => UserHistoryCard(
                  from: item.from,
                  to: item.to,
                  paymentType: item.paymentMethod,
                  date: item.date.toString().split(" ").first,
                  time: item.date.toString().split(" ").last.substring(0, 5),
                  amount: "${item.price.toStringAsFixed(2)} ",
                )),
            const Divider(thickness: 1),
          ],
        );
      }).toList(),
    );
  }
}
