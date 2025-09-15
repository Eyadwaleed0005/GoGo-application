import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/logic/cubit/driver_waiting_list_cubit.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/data/repo/driver_waiting_list_repository.dart';
import 'package:gogo/ui/admin_screens/driver_wating_list_screen/ui/widget/driver_waiting_card/driver_waiting_card.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
class DriverWaitingListScreen extends StatefulWidget {
  const DriverWaitingListScreen({super.key});

  @override
  State<DriverWaitingListScreen> createState() =>
      _DriverWaitingListScreenState();
}
class _DriverWaitingListScreenState extends State<DriverWaitingListScreen>
    with RouteAware {
  late DriverWaitingListCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = DriverWaitingListCubit(DriverWaitingListRepository());
    cubit.fetchDriverWaitingList();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    cubit.close();
    super.dispose();
  }
  @override
  void didPopNext() {
    cubit.fetchDriverWaitingList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "قايمة مراجعة بيانات السواقين",
            style: TextStyles.font15Blackbold(),
          ),
          centerTitle: true,
          backgroundColor: ColorPalette.mainColor,
        ),
        body: BlocBuilder<DriverWaitingListCubit, DriverWaitingListState>(
          builder: (context, state) {
            if (state is DriverWaitingListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DriverWaitingListLoaded) {
              if (state.drivers.isEmpty) {
                return const Center(child: Text("لا يوجد سائقين في الانتظار"));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  cubit.fetchDriverWaitingList();
                },
                child: ListView.builder(
                  itemCount: state.drivers.length,
                  itemBuilder: (context, index) {
                    final driver = state.drivers[index];
                    return DriverWaitingCard(
                      driverId: driver.id,
                      userId: driver.userId,
                      driverFullname: driver.driverFullname,
                      email: driver.email,
                      status: driver.status,
                    );
                  },
                ),
              );
            } else if (state is DriverWaitingListError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
