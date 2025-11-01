import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_pay_repository.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/repo/driver_wallet_repository.dart';
import 'package:gogo/ui/driver_screen/driver_wallet_screen/data/model/driver_pay_model.dart';

part 'driver_wallet_screen_state.dart';

class DriverWalletScreenCubit extends Cubit<DriverWalletScreenState> {
  DriverWalletScreenCubit(this._payRepository, this._walletRepository)
      : super(
          const DriverWalletScreenState(wallet: 0, images: [null, null, null]),
        );

  final DriverPayRepository _payRepository;
  final DriverWalletRepository _walletRepository;
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  Future<File> _saveImagePermanently(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = DateTime.now().millisecondsSinceEpoch.toString();
    final newImage = File('${directory.path}/$name.jpg');
    return File(image.path).copy(newImage.path);
  }

  Future<void> pickImage(int index) async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final savedFile = await _saveImagePermanently(pickedFile);
        final updatedImages = List<XFile?>.from(state.images);
        updatedImages[index] = XFile(savedFile.path);

        if (isClosed) return;
        emit(state.copyWith(images: updatedImages, error: null));
      }
    } finally {
      _isPicking = false;
    }
  }

  Future<void> submitPayment(int index) async {
    final file = state.images[index];
    if (file == null) {
      if (isClosed) return;
      emit(
        state.copyWith(
          error: "wallet_select_image_first".tr(),
        ),
      );
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final imageUrl = await _payRepository.uploadImage(File(file.path));
      final driverPay = await _payRepository.submitDriverPay(
        imageUrl: imageUrl!,
      );

      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          images: [null, null, null],
          driverPay: driverPay,
          showSuccessAnimation: true,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> fetchWallet() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final wallet = await _walletRepository.getDriverWallet();
      if (isClosed) return;
      emit(state.copyWith(wallet: wallet, isLoading: false));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void resetDriverPay() {
    if (isClosed) return;
    emit(state.copyWith(showSuccessAnimation: false, driverPay: null));
  }

  void clearError() {
    if (isClosed) return;
    emit(state.copyWith(error: null));
  }
}
