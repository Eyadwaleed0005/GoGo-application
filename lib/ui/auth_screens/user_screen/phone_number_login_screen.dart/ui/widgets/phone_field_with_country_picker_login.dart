import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo/core/widgets/app_text_field.dart';

class PhoneFieldWithCountryPickerLogin extends StatelessWidget {
  final Country selectedCountry;
  final void Function(Country) onCountryChanged;
  final TextEditingController controller;

  const PhoneFieldWithCountryPickerLogin({
    super.key,
    required this.selectedCountry,
    required this.onCountryChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Country>(
              value: selectedCountry,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (Country? newCountry) {
                if (newCountry != null) onCountryChanged(newCountry);
              },
              items: CountryService().getAll().map((country) {
                return DropdownMenuItem<Country>(
                  value: country,
                  child: Row(
                    children: [
                      Text(country.flagEmoji),
                      SizedBox(width: 8.w),
                      Text('+${country.phoneCode}'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AppTextField(
            hint: 'Phone Number',
            keyboardType: TextInputType.phone,
            controller: controller,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Enter phone number' : null,
          ),
        ),
      ],
    );
  }
}
 