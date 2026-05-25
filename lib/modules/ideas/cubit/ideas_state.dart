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

class IdeaCreateLoading extends IdeasState {}

class IdeaCreateSuccess extends IdeasState {
  final Idea idea;
  const IdeaCreateSuccess(this.idea);
  @override
  List<Object?> get props => [idea];
}

class IdeaCreateError extends IdeasState {
  final String message;
  const IdeaCreateError(this.message);
  @override
  List<Object?> get props => [message];
}
