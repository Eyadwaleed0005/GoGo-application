import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/data/repo/order_details_repository.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/logic/cubit/driver_details_order_screen_cubit.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/widget/action_buttons_widget.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/widget/driver_details_appbar.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/widget/driver_details_order_skeleton_screen.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/widget/from_to_card.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/widget/note_widget.dart';
import 'package:gogo/ui/driver_screen/driver_details_order_screen/ui/widget/user_info_row.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_wallet_repository.dart';
import 'package:gogo/core/helper/driver_save_trip_helper_trips.dart';
import 'package:gogo/core/routes/app_routes.dart';

class DriverDetailsOrderScreen extends StatelessWidget {
  final int orderId;
  const DriverDetailsOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverDetailsOrderScreenCubit(
        repository: OrderDetailsRepository(),
        walletRepository: DriverWalletRepository(),
      )..fetchOrderDetails(orderId),
      child: Scaffold(
        appBar: const DriverDetailsAppBar(),
        body: SafeArea(
          child:
              BlocBuilder<
                DriverDetailsOrderScreenCubit,
                DriverDetailsOrderScreenState
              >(
                builder: (context, state) {
                  if (state is DriverDetailsOrderScreenLoading) {
                   return const DriverDetailsOrderSkeletonScreen();
                  } else if (state is DriverDetailsOrderScreenError) {
                    return Center(child: Text(state.message));
                  } else if (state is DriverDetailsOrderScreenSuccess) {
                    final order = state.order;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserInfoRow(
                            imageUrl: order.userImage,
                            name: order.userName,
                            time: order.formattedTime(context),
                          ),
                          SizedBox(height: 18.h),
                          FromToCard(
                            fromPlace: order.from,
                            toPlace: order.to,
                            price: order.expectedPrice.toString(),
                            distance: order.distance.toString(),
                            tripType: order.type,
                            passengers: order.noPassengers.toString(),
                            paymentWay: order.paymentWay,
                          ),
                          SizedBox(height: 18.h),
                          if (order.notes.isNotEmpty)
                            NoteWidget(note: order.notes),
                          SizedBox(height: 18.h),
                          ActionButtonsWidget(
                            onAccept: () async {
                              final cubit = context
                                  .read<DriverDetailsOrderScreenCubit>();
                              final orderTime = order.date;
                              await cubit.acceptOrder(context, order.id);
                              final currentState = cubit.state;

                              if (currentState
                                  is DriverDetailsOrderScreenSuccess) {
                                await SharedPreferencesHelperTrips.saveTripData(
                                  customerLat: order.fromLatLng.lat,
                                  customerLng: order.fromLatLng.lng,
                                  destinationLat: order.toLatLng.lat,
                                  destinationLng: order.toLatLng.lng,
                                  userPhone: order.userPhone,
                                  orderId: order.id,
                                  customerName: order.userName,
                                  price: order.expectedPrice,
                                  tripType: order.type,
                                  time: orderTime,
                                  fromPlace: order.from,
                                  toPlace: order.to,
                                );
                                await cubit.approveOrder(order.id);

                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.driverMapScreen,
                                  );
                                }
                              }
                            },
                            onReject: () {
                              if (context.mounted) Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
        ),
      ),
    );
  }
}
