import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/user_screens/map_screen/data/model/map_suggestion_model.dart';
import 'package:gogo/ui/user_screens/map_screen/data/repo/map_repository.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/location_service_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/map_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/route_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/logic/cubit/search_cubit.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/map_veiw.dart';

class ChooseFromMapButton extends StatelessWidget {
  final TextEditingController controller;
  final Function(MapSuggestion) onSelected;
  final void Function(MapSuggestion?) onPicked;

  const ChooseFromMapButton({
    super.key,
    required this.controller,
    required this.onSelected,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        final picked = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => LocationCubit()),
                BlocProvider(create: (_) => RouteCubit(MapRepository())),
                BlocProvider(create: (_) => MapCubit(MapRepository())),
                BlocProvider(create: (_) => SearchCubit(MapRepository())),
                BlocProvider(
                  create: (_) => LocationServiceCubit()..checkLocationService(),
                ),
              ],
              child: MapView(fromController: controller, isSelecting: true),
            ),
          ),
        );

        if (picked != null && picked is MapSuggestion) {
          controller.text = picked.name;
          onSelected(picked);
          onPicked(picked);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: ColorPalette.red),
          SizedBox(width: 6.w),
          Text("choose_from_map".tr(), style: TextStyles.font10Blackbold()),
        ],
      ),
    );
  }
}
