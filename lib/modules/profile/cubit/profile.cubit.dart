import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigyasa/modules/profile/cubit/profile.state.dart';
import 'package:jigyasa/modules/profile/repository/profile.repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit({
    required ProfileRepository repository,
  })  : _repository = repository,
        super(ProfileInitial());

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());
      final user = await _repository.getProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }


  Future<void> refreshProfile() async {
    try {
      final user = await _repository.getProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}