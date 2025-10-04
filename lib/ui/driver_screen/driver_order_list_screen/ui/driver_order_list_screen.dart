import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/local/shared_preference_keys.dart';
import 'package:gogo/core/local/shared_preferences.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/custom_refresh_widget.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/data/repo/order_details_repository.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/logic/cubit/driver_details_order_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/driver_details_order_screen.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/logic/cubit/driver_order_list_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/data/repo/get_all_orders_repository.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/ui/widgets/order_list_widget/order_list_card.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/ui/widgets/order_list_widget/order_list_card_skeleton.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/ui/widgets/small_widgets.dart/order_list_background.dart';
import 'package:gogo/ui/driver_screen/driver_order_list_screen/ui/widgets/small_widgets.dart/title_screen_widget.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_wallet_repository.dart';

class DriverOrderListScreen extends StatelessWidget {
  const DriverOrderListScreen({super.key});

  Future<bool> _isDriverActive() async {
    final isActive = await SharedPreferencesHelper.getBool(
      key: SharedPreferenceKeys.driverActive,
    );
    return isActive ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isDriverActive(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isActive = snapshot.data!;

        if (!isActive) {
          return Scaffold(
            body: Center(
              child: Text(
                "go_to_profile_activate_status".tr(), // ✅ مفتاح الترجمة
                style: TextStyles.font18BlackBold(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return BlocProvider(
          create: (context) {
            final cubit = DriverOrderListScreenCubit(
              repository: GetAllOrdersRepository(),
            );
            cubit.fetchOrders();
            return cubit;
          },
          child: Scaffold(
            body: Stack(
              children: [
                const OrderListBackground(),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(15),
                        Expanded(
                          child:
                              BlocBuilder<
                                DriverOrderListScreenCubit,
                                DriverOrderListScreenState
                              >(
                                builder: (context, state) {
                                  return CustomRefreshWidget(
                                    onReload: () async {
                                      context
                                          .read<DriverOrderListScreenCubit>()
                                          .fetchOrders();
                                    },
                                    child: _buildContent(context, state),
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DriverOrderListScreenState state) {
    if (state is DriverOrderListScreenLoading) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleScreenWidget(),
            verticalSpace(15),
            ...List.generate(6, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: const OrderListCardSkeleton(),
              );
            }),
          ],
        ),
      );
    } else if (state is DriverOrderListScreenError) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 500.h,
          child: Center(
            child: Text(
              state.message,
              style: TextStyles.font12Blackbold().copyWith(
                color: ColorPalette.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else if (state is DriverOrderListScreenSuccess) {
      if (state.orders.isEmpty) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 500.h,
            child: Center(
              child: Text(
                "no_orders_available".tr(),
                style: TextStyles.font12Blackbold(),
              ),
            ),
          ),
        );
      }
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleScreenWidget(),
            verticalSpace(15),
            ...List.generate(state.orders.length, (index) {
              final order = state.orders[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 25.h),
                child: OrderListCard(
                  imageUrl: order.userImage,
                  userName: order.userName,
                  time: order.formattedTime(context),
                  location: order.to,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => DriverDetailsOrderScreenCubit(
                            repository: OrderDetailsRepository(),
                            walletRepository: DriverWalletRepository(),
                          )..fetchOrderDetails(order.id),
                          child: DriverDetailsOrderScreen(orderId: order.id),
                        ),
                      ),
                    );
                    context.read<DriverOrderListScreenCubit>().fetchOrders();
                  },
                ),
              );
            }),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
