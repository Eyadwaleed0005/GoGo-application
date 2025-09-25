import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/style/app_color.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/models/order_list_models/oreder_model.dart';
import 'package:gogo/ui/user_screens/request_screen/logic/cubit/ride_request_screen_cubit.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/payment_way_dropdown.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/trip_type_dropdown.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class TripDetailsForm extends StatefulWidget {
  TripDetailsForm({
    super.key,
    required this.from,
    required this.to,
    required this.fromLatLng,
    required this.toLatLng,
  });

  final String from;
  final String to;
  final mb.Point fromLatLng;
  final mb.Point toLatLng;

  @override
  State<TripDetailsForm> createState() => _TripDetailsFormState();
}

class _TripDetailsFormState extends State<TripDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController passengersController;
  late TextEditingController priceController;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    final state = context.read<RideRequestScreenCubit>().state;

    passengersController = TextEditingController(
      text: state.tripType == "delivery" ? "0" : "",
    );
    priceController = TextEditingController(text: state.price);
    notesController = TextEditingController(text: state.notes);
  }

  @override
  void dispose() {
    passengersController.dispose();
    priceController.dispose();
    notesController.dispose();
    super.dispose();
  }

  OutlineInputBorder _borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: ColorPalette.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideRequestScreenCubit, RideRequestScreenState>(
      builder: (context, state) {
        final cubit = context.read<RideRequestScreenCubit>();
        if (state.tripType == "delivery") {
          passengersController.text = "0";
        } else if (passengersController.text == "0") {
          passengersController.clear();
        }
        priceController.text = state.price;
        notesController.text = state.notes;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               verticalSpace(30),
              const TripCategoryDropdown(),
              verticalSpace(20),
              const PaymentWayDropdown(), 
              verticalSpace(20),
              Row(
                children: [
                  SizedBox(
                    width: 120.w,
                    child: TextFormField(
                      controller: passengersController,
                      readOnly: state.tripType == "delivery",
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: cubit.changePassengers,
                      validator: (value) {
                        final passengers = int.tryParse(value ?? "") ?? -1;

                        if (state.tripType == "delivery") {
                          if (passengers != 0) {
                            return "passengers_zero".tr();
                          }
                        } else {
                          if (passengers <= 0) {
                            return "passengers_gt_zero".tr();
                          }
                          if (passengers > 4) {
                            return "max_passengers".tr();
                          }
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorPalette.backgroundColor,
                        border: _borderStyle(),
                        enabledBorder: _borderStyle(),
                        focusedBorder: _borderStyle(),
                        hintText: state.tripType == "delivery"
                            ? null
                            : "enter_passengers".tr(),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Text("passengers".tr(), style: TextStyles.font15whitebold()),
                ],
              ),
              verticalSpace(20),
              Row(
                children: [
                  SizedBox(
                    width: 160.w,
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      onChanged: cubit.changePrice,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "price_note".tr(),
                              style: TextStyles.font10Blackbold().copyWith(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.black87,
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(12.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "enter_price".tr();
                        }
                        final priceValue = int.tryParse(value) ?? 0;
                        if (priceValue < state.suggestedPrice) {
                          return "${"suggested_price".tr()} ${state.suggestedPrice}";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: _borderStyle(),
                        enabledBorder: _borderStyle(),
                        focusedBorder: _borderStyle(),
                        prefixText: "E£ ",
                        prefixStyle: TextStyles.font10Blackbold(),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Text("price".tr(), style: TextStyles.font15whitebold()),
                ],
              ),
              verticalSpace(20),
              Row(
                children: [
                  SizedBox(
                    width: 120.w,
                    child: TextFormField(
                      initialValue: "${state.distanceKm.toStringAsFixed(2)} km",
                      readOnly: true,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: _borderStyle(),
                        enabledBorder: _borderStyle(),
                        focusedBorder: _borderStyle(),
                      ),
                    ),
                  ),
                  horizontalSpace(12),
                  Text("distance".tr(), style: TextStyles.font15whitebold()),
                ],
              ),
              verticalSpace(20),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                onChanged: cubit.changeNotes,
                decoration: InputDecoration(
                  labelText: "notes".tr(),
                  labelStyle: TextStyles.font10Blackbold(),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "write_notes".tr(),
                  border: _borderStyle(),
                  enabledBorder: _borderStyle(),
                  focusedBorder: _borderStyle(),
                ),
              ),
              verticalSpace(30),

              /// Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      cubit.createOrder(
                        from: widget.from,
                        to: widget.to,
                        fromLatLng: LatLngModel(
                          lat: widget.fromLatLng.coordinates.lat.toDouble(),
                          lng: widget.fromLatLng.coordinates.lng.toDouble(),
                        ),
                        toLatLng: LatLngModel(
                          lat: widget.toLatLng.coordinates.lat.toDouble(),
                          lng: widget.toLatLng.coordinates.lng.toDouble(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "confirm_order".tr(),
                    style: TextStyles.font15whitebold(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
