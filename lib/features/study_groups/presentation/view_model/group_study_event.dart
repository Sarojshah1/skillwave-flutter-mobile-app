part of 'group_study_bloc.dart';

abstract class GroupStudyEvent extends Equatable {
  const GroupStudyEvent();

  @override
  List<Object?> get props => [];
}

class CreateGroupRequested extends GroupStudyEvent {
  final String groupName;
  final File groupImage;
  final String description;

  const CreateGroupRequested({
    required this.groupName,
    required this.groupImage,
    required this.description,
  });

  @override
  List<Object?> get props => [groupName, groupImage, description];
}

class LoadAllGroupsRequested extends GroupStudyEvent {}

class LoadUserGroupsRequested extends GroupStudyEvent {

}
