import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/ideas_repository.dart';
import 'ideas_state.dart';

class IdeasCubit extends Cubit<IdeasState> {
  final IdeasRepository _repo;
  IdeasCubit({IdeasRepository? repository})
      : _repo = repository ?? IdeasRepositoryImpl(),
        super(IdeasInitial());

  Future<void> fetchAll() async {
    emit(IdeasLoading());
    try {
      final ideas = await _repo.getAllIdeas();
      emit(IdeasLoaded(ideas));
    } catch (e) {
      emit(IdeasError(e.toString()));
    }
  }

  Future<void> createIdea(Map<String, dynamic> payload) async {
    emit(IdeaCreateLoading());
    try {
      final idea = await _repo.createIdea(payload);
      emit(IdeaCreateSuccess(idea));
    } catch (e) {
      emit(IdeaCreateError(e.toString()));
    }
  }
}
