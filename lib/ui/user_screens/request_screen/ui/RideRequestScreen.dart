import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/helper/spacer.dart';
import 'package:gogo/core/routes/app_images_routes.dart';
import 'package:gogo/core/style/textstyles.dart';
import 'package:gogo/core/widgets/back_text_button.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/notes_input_field.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/passenger_counter.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/price_input_field.dart';
import 'package:gogo/ui/user_screens/request_screen/ui/widgets/submit_order_button.dart';
import 'package:gogo/ui/user_screens/map_screen/ui/widgets/trip_summary_card.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mb;

class RideRequestScreen extends StatefulWidget {
  final String from;
  final String to;
  final mb.Point? fromLatLng;
  final mb.Point? toLatLng;
  final double? distanceKm;
  final double? durationMin;

  const RideRequestScreen({
    super.key,
    required this.from,
    required this.to,
    this.fromLatLng,
    this.toLatLng,
    this.distanceKm,
    this.durationMin,
  });

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  int passengers = 1;
  final priceController = TextEditingController();
  final notesController = TextEditingController();
  late TextEditingController fromNameController;
  late TextEditingController toNameController;
  String tripType = "One Way";

  @override
  void initState() {
    super.initState();
    fromNameController = TextEditingController(
      text: widget.from.isNotEmpty ? widget.from : "No name available",
    );
    toNameController = TextEditingController(
      text: widget.to.isNotEmpty ? widget.to : "No name available",
    );
  }

  @override
  void dispose() {
    fromNameController.dispose();
    toNameController.dispose();
    priceController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackTextButton(onTap: () => Navigator.pop(context)),
                verticalSpace(10),
                Image.asset(AppImage().taxi),
                verticalSpace(20),

                // ✅ إضافة ملخص الرحلة
                if (widget.distanceKm != null && widget.durationMin != null)
                  TripSummaryCard(
                    distanceKm: widget.distanceKm!,
                    durationMin: widget.durationMin!,
                  ),
                verticalSpace(20),

                PriceInputField(
                  controller: priceController,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a price" : null,
                ),
                verticalSpace(18),
                Divider(color: Colors.grey.shade400, thickness: 1),
                verticalSpace(18),

                Center(
                  child: Text(
                    "Number of Passengers",
                    style: TextStyles.font15blackBold(),
                  ),
                ),
                verticalSpace(10),
                PassengerCounter(
                  passengers: passengers,
                  onChanged: (value) {
                    setState(() {
                      passengers = value;
                    });
                  },
                ),
                verticalSpace(20),
                Divider(color: Colors.grey.shade400, thickness: 1),
                Center(child: NotesInputField(controller: notesController)),
                verticalSpace(30),
                SubmitOrderButton(
                  formKey: _formKey,
                  getFrom: () => fromNameController.text,
                  getTo: () => toNameController.text,
                  getFromLatLng: () => widget.fromLatLng,
                  getToLatLng: () => widget.toLatLng,
                  getPassengers: () => passengers,
                  getTripType: () => tripType,
                  getPrice: () => priceController.text,
                  getNotes: () => notesController.text,
                  getDistanceKm: () => widget.distanceKm,
                  getDurationMin: () => widget.durationMin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
