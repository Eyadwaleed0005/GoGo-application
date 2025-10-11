import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/core/models/car_models/car_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/data/model/driver_auth_model.dart';
import 'package:gogo/ui/auth_screens/driver_screen/car_driver_informaton_screen/data/repo/car_driver_information_repository.dart';

part 'car_driver_information_state.dart';

class CarDriverInformationCubit extends Cubit<CarDriverInformationState> {
  final CarDriverInformationRepository repository;
  CarDriverInformationCubit(this.repository)
      : super(CarDriverInformationInitial());

  File? carImage;
  File? licenseFrontImage;
  File? licenseBackImage;

  File? driverImage;
  File? driverWithCardImage;
  File? driverLicenseFrontImage;
  File? driverLicenseBackImage;
  File? idCardFrontImage;
  File? idCardBackImage;

  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final plateController = TextEditingController();

  final fullNameController = TextEditingController();
  final nationalIdController = TextEditingController();
  final ageController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final licenseExpiryController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // ✅ التقاط صورة وتحديث الحالة بأمان
  Future<void> pickImage(ImageSource source, void Function(File) onPicked) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      onPicked(savedImage);
      if (!isClosed) emit(CarInfoUpdated(validateCarInfo())); // ✅ تأكد قبل emit
    }
  }

  // دوال الصور
  void pickCarImage(ImageSource source) => pickImage(source, (file) => carImage = file);
  void pickLicenseFrontImage(ImageSource source) => pickImage(source, (file) => licenseFrontImage = file);
  void pickLicenseBackImage(ImageSource source) => pickImage(source, (file) => licenseBackImage = file);
  void pickDriverImage(ImageSource source) => pickImage(source, (file) => driverImage = file);
  void pickDriverWithCardImage(ImageSource source) => pickImage(source, (file) => driverWithCardImage = file);
  void pickDriverLicenseFrontImage(ImageSource source) => pickImage(source, (file) => driverLicenseFrontImage = file);
  void pickDriverLicenseBackImage(ImageSource source) => pickImage(source, (file) => driverLicenseBackImage = file);
  void pickIdCardFrontImage(ImageSource source) => pickImage(source, (file) => idCardFrontImage = file);
  void pickIdCardBackImage(ImageSource source) => pickImage(source, (file) => idCardBackImage = file);

  // ✅ التحقق من البيانات
  List<String> validateCarInfo() {
    List<String> missing = [];

    if (brandController.text.isEmpty) missing.add("Car Brand");
    if (modelController.text.isEmpty) missing.add("Car Model");
    if (colorController.text.isEmpty) missing.add("Car Color");
    if (plateController.text.isEmpty) missing.add("Plate Number");
    if (carImage == null) missing.add("Car Photo");
    if (licenseFrontImage == null) missing.add("License (Front)");
    if (licenseBackImage == null) missing.add("License (Back)");

    if (fullNameController.text.isEmpty) missing.add("Driver Full Name");
    if (nationalIdController.text.isEmpty) missing.add("Driver National ID");
    if (ageController.text.isEmpty) missing.add("Driver Age");
    if (licenseNumberController.text.isEmpty) missing.add("Driver License Number");
    if (licenseExpiryController.text.isEmpty) missing.add("License Expiry Date");

    if (driverImage == null) missing.add("Driver Photo");
    if (driverWithCardImage == null) missing.add("Driver with ID Card");
    if (driverLicenseFrontImage == null) missing.add("Driver License (Front)");
    if (driverLicenseBackImage == null) missing.add("Driver License (Back)");
    if (idCardFrontImage == null) missing.add("ID Card (Front)");
    if (idCardBackImage == null) missing.add("ID Card (Back)");

    return missing;
  }

  // ✅ إرسال البيانات
  Future<void> submitData() async {
    final missing = validateCarInfo();
    if (missing.isNotEmpty) {
      if (!isClosed) emit(CarInfoUpdated(missing));
      return;
    }

    if (!isClosed) emit(CarDriverUploadingImages());

    try {
      final userId = await SecureStorageHelper.getdata(key: SecureStorageKeys.userId);
      final email = await SecureStorageHelper.getdata(key: SecureStorageKeys.email);
      final password = await SecureStorageHelper.getdata(key: SecureStorageKeys.password);

      final uploadedImages = await Future.wait([
        repository.uploadImage(carImage!),
        repository.uploadImage(licenseFrontImage!),
        repository.uploadImage(licenseBackImage!),
        repository.uploadImage(driverImage!),
        repository.uploadImage(driverWithCardImage!),
        repository.uploadImage(driverLicenseFrontImage!),
        repository.uploadImage(driverLicenseBackImage!),
        repository.uploadImage(idCardFrontImage!),
        repository.uploadImage(idCardBackImage!),
      ]);

      if (isClosed) return;
      emit(CarDriverSubmittingDriverData());

      final driverModel = DriverAuthModel(
        id: 0,
        driverPhoto: uploadedImages[3]!,
        driverIdCard: uploadedImages[4]!,
        driverLicenseFront: uploadedImages[5]!,
        driverLicenseBack: uploadedImages[6]!,
        idCardFront: uploadedImages[7]!,
        idCardBack: uploadedImages[8]!,
        driverFullname: fullNameController.text,
        nationalId: nationalIdController.text,
        age: int.parse(ageController.text),
        licenseNumber: licenseNumberController.text,
        email: email ?? "",
        password: password ?? "",
        licenseExpiryDate: licenseExpiryController.text,
        userId: userId ?? "",
      );

      final createdDriver = await repository.submitDriverData(driverModel);

      if (isClosed) return;
      emit(CarDriverSubmittingCarData());

      final carModel = CarModel(
        id: 0,
        carPhoto: uploadedImages[0]!,
        licenseFront: uploadedImages[1]!,
        licenseBack: uploadedImages[2]!,
        carBrand: brandController.text,
        carModel: modelController.text,
        carColor: colorController.text,
        plateNumber: plateController.text,
        driverId: createdDriver.id,
      );

      await repository.submitCarData(carModel);

      if (!isClosed) emit(CarDriverSubmissionSuccess());
    } catch (e) {
      if (!isClosed) emit(CarDriverSubmissionFailure(e.toString()));
    }
  }
  @override
  Future<void> close() {
    brandController.dispose();
    modelController.dispose();
    colorController.dispose();
    plateController.dispose();
    fullNameController.dispose();
    nationalIdController.dispose();
    ageController.dispose();
    licenseNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    licenseExpiryController.dispose();
    return super.close();
  }
}
