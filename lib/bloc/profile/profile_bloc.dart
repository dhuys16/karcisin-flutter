import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karcisin_app/bloc/profile/profile_event.dart';
import 'package:karcisin_app/bloc/profile/profile_state.dart';
import '../../repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<ProfileFetched>(_onProfileFetched);
  }

  Future<void> _onProfileFetched(
    ProfileFetched event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await _profileRepository.getProfile();
      emit(ProfileLoaded(
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        image: user.image,
      ));
    } catch (e) {
      print(e);
      emit(ProfileError(e.toString()));
    }
  }
}