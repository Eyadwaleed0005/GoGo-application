import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gogo/core/local/secure_storage.dart';
import 'package:gogo/core/local/secure_storage_keys.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/data/model/local_user_model.dart';
import 'package:gogo/ui/user_screens/user_profile_screen/data/repo/user_profile_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'user_profile_screen_state.dart';

class UserProfileScreenCubit extends Cubit<UserProfileScreenState> {
  UserProfileScreenCubit(this._repo) : super(UserProfileScreenInitial());

  final UserProfileRepository _repo;
  final ImagePicker _picker = ImagePicker();

  File? userImage;
  LocalUserModel? localUser;
  String? userProfileImageUrl; 
  
  Future<void> loadUserData() async {
    final Map<String, String?> data = {
      'displayName': await SecureStorageHelper.getdata(
        key: SecureStorageKeys.displayName,
      ),
      'email': await SecureStorageHelper.getdata(
        key: SecureStorageKeys.email,
      ),
      'phoneNumber': await SecureStorageHelper.getdata(
        key: SecureStorageKeys.phoneNumber,
      ),
    };

    localUser = LocalUserModel.fromMap(data);
    emit(UserProfileScreenUserDataLoaded(localUser!));
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      emit(UserProfileScreenImageChanged(userImage!));
      await updateProfile();
    }
  }

  Future<void> updateProfile() async {
    if (userImage == null) return;
    emit(UserProfileScreenUpdating());
    try {
      await _repo.updateUserProfile(userImage!);
      emit(UserProfileScreenUpdateSuccess());
    } catch (e) {
      emit(UserProfileScreenUpdateError(e.toString()));
    }
  }

  Future<void> loadUserPhoto() async {
  emit(UserProfilePhotoLoading());
  try {
    final photo = await _repo.getUserProfilePhoto();
    if (photo != null) {
      userProfileImageUrl = photo.imageUrl; 
      emit(UserProfilePhotoLoaded(photo.imageUrl));
    } else {
      emit(UserProfilePhotoLoadError("No Image Found"));
    }
  } catch (e) {
    emit(UserProfilePhotoLoadError(e.toString()));
  }
}

}
