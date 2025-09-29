import 'package:flutter/material.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/model/driver_history_model.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/card_driver_ui/card_driver_history.dart';
import 'package:gogo/core/helper/simple_date_helper.dart';

class DriverHistoryList extends StatelessWidget {
  final List<DriverHistoryMoedl> historyData;

  const DriverHistoryList({super.key, required this.historyData});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ نسخ وترتيب البيانات تنازليًا حسب التاريخ
    final sortedData = List<DriverHistoryMoedl>.from(historyData);
    sortedData.sort((a, b) => b.date.compareTo(a.date));

    // 2️⃣ تجميع البيانات حسب SimpleDateHelper.format
    final Map<String, List<DriverHistoryMoedl>> groupedData = {};
    for (var item in sortedData) {
      final sectionKey = SimpleDateHelper.format(item.date);
      groupedData.putIfAbsent(sectionKey, () => []).add(item);
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: groupedData.entries.map((entry) {
        final sectionTitle = entry.key;
        final sectionItems = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            verticalSpace(10),
            Center(
              child: Text(
                sectionTitle, 
                style: TextStyles.font20Blackbold(),
              ),
            ),
            verticalSpace(8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sectionItems.length,
              separatorBuilder: (_, __) => verticalSpace(0),
              itemBuilder: (context, index) {
                final item = sectionItems[index];
                final bool isOrange = index.isEven;
                final containerColor = isOrange
                    ? ColorPalette.mainColor
                    : ColorPalette.textDark;
                final circleColor = isOrange
                    ? ColorPalette.textDark
                    : ColorPalette.circlesBackground;
                return CardDriverHistory(
                  from: item.from,
                  to: item.to,
                  containerColor: containerColor,
                  circleColor: circleColor,
                  rating: item.review,
       
                  price: "${item.totalTip}",
                  wayOfPay: item.paymentWay,
                  date: item.formattedDate,
                  time: item.formattedTime,
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}