// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final User user;
  final CustomError error;

  ProfileState(
      {required this.profileStatus, required this.user, required this.error});

  factory ProfileState.initial() {
    return ProfileState(
        profileStatus: ProfileStatus.initial,
        user: User.initial(),
        error: CustomError());
  }

  @override
  List<Object> get props => [profileStatus, user, error];

  @override
  bool get stringify => true;

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    User? user,
    CustomError? error,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}
