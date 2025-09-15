part of 'user_profile_screen_cubit.dart';

@immutable
sealed class UserProfileScreenState {}

final class UserProfileScreenInitial extends UserProfileScreenState {}

final class UserProfileScreenImageChanged extends UserProfileScreenState {
  final File image;
  UserProfileScreenImageChanged(this.image);
}

final class UserProfileScreenUserDataLoaded extends UserProfileScreenState {
  final LocalUserModel user;
  UserProfileScreenUserDataLoaded(this.user);
}


final class UserProfileScreenUpdating extends UserProfileScreenState {}
final class UserProfileScreenUpdateSuccess extends UserProfileScreenState {}
final class UserProfileScreenUpdateError extends UserProfileScreenState {
  final String message;
  UserProfileScreenUpdateError(this.message);
}


final class UserProfilePhotoLoading extends UserProfileScreenState {}
final class UserProfilePhotoLoaded extends UserProfileScreenState {
  final String imageUrl;
  UserProfilePhotoLoaded(this.imageUrl);
}
final class UserProfilePhotoLoadError extends UserProfileScreenState {
  final String message;
  UserProfilePhotoLoadError(this.message);
}
