part of 'group_study_bloc.dart';

abstract class GroupStudyState extends Equatable {
  const GroupStudyState();

  @override
  List<Object?> get props => [];
}

class GroupStudyInitial extends GroupStudyState {}

class GroupStudyLoading extends GroupStudyState {}

class GroupStudyError extends GroupStudyState {
  final Failure failure;
  const GroupStudyError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class GroupCreated extends GroupStudyState {
  final GroupEntity group;
  const GroupCreated(this.group);

  @override
  List<Object?> get props => [group];
}

class GroupsLoaded extends GroupStudyState {
  final List<GroupEntity> groups;
  const GroupsLoaded(this.groups);

  @override
  List<Object?> get props => [groups];
}
