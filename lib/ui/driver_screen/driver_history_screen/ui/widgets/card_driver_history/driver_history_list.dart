import 'package:flutter/material.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/helper/simple_date_helper.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/data/model/driver_history_model.dart';
import 'package:gogo/ui/driver_screen/driver_history_screen/ui/widgets/card_driver_history/card_driver_ui/card_driver_history.dart';

class DriverHistoryList extends StatelessWidget {
  final List<DriverHistoryModel> historyData;

  const DriverHistoryList({super.key, required this.historyData});

  @override
  Widget build(BuildContext context) {
    // ✅ 1. ترتيب حسب التاريخ تنازليًا
    final sortedData = List<DriverHistoryModel>.from(historyData);
    sortedData.sort((a, b) => b.date.compareTo(a.date));

    // ✅ 2. تجميع حسب النتيجة من SimpleDateHelper.format
    final Map<String, List<DriverHistoryModel>> groupedData = {};
    for (var item in sortedData) {
      final key = SimpleDateHelper.format(item.date);
      groupedData.putIfAbsent(key, () => []).add(item);
    }

    // ✅ 3. عرض البيانات مجمعة تحت كل عنوان (اليوم / أمس / منذ أسبوع ...)
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: groupedData.entries.map((entry) {
        final sectionTitle = entry.key;
        final sectionItems = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            verticalSpace(12),
            Center(
              child: Text(
                sectionTitle,
                style: TextStyles.font20Blackbold(),
              ),
            ),
            verticalSpace(10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sectionItems.length,
              separatorBuilder: (_, __) => verticalSpace(8),
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
                  date: item.formattedDate(context), 
                  time: item.formattedTime(context), 
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}
