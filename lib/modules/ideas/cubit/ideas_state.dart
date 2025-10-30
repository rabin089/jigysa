import 'package:equatable/equatable.dart';
import '../../ideas/models/idea.dart';

abstract class IdeasState extends Equatable {
  const IdeasState();
  @override
  List<Object?> get props => [];
}

class IdeasInitial extends IdeasState {}

class IdeasLoading extends IdeasState {}

class IdeasLoaded extends IdeasState {
  final List<Idea> ideas;
  const IdeasLoaded(this.ideas);
  @override
  List<Object?> get props => [ideas];
}

class IdeasError extends IdeasState {
  final String message;
  const IdeasError(this.message);
  @override
  List<Object?> get props => [message];
}
