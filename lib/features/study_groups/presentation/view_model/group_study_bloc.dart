import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';
import 'package:skillwave/features/study_groups/domain/usecases/create_group_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/get_all_groups_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/get_user_groups_usecase.dart';
import 'package:skillwave/cores/failure/failure.dart';

part 'group_study_event.dart';
part 'group_study_state.dart';

@injectable
class GroupStudyBloc extends Bloc<GroupStudyEvent, GroupStudyState> {
  final CreateGroupUseCase _createGroupUseCase;
  final GetAllGroupsUseCase _getAllGroupsUseCase;
  final GetUserGroupsUseCase _getUserGroupsUseCase;

  GroupStudyBloc(
    this._createGroupUseCase,
    this._getAllGroupsUseCase,
    this._getUserGroupsUseCase,
  ) : super(GroupStudyInitial()) {
    on<CreateGroupRequested>(_onCreateGroupRequested);
    on<LoadAllGroupsRequested>(_onLoadAllGroupsRequested);
    on<LoadUserGroupsRequested>(_onLoadUserGroupsRequested);
  }

  Future<void> _onCreateGroupRequested(
    CreateGroupRequested event,
    Emitter<GroupStudyState> emit,
  ) async {
    emit(GroupStudyLoading());
    final result = await _createGroupUseCase(
      groupName: event.groupName,
      groupImage: event.groupImage,
      description: event.description,
    );
    result.fold(
      (failure) => emit(GroupStudyError(failure)),
      (group) => emit(GroupCreated(group!)),
    );
  }

  Future<void> _onLoadAllGroupsRequested(
    LoadAllGroupsRequested event,
    Emitter<GroupStudyState> emit,
  ) async {
    emit(GroupStudyLoading());
    final result = await _getAllGroupsUseCase();
    result.fold(
      (failure) => emit(GroupStudyError(failure)),
      (groups) => emit(GroupsLoaded(groups ?? [])),
    );
  }

  Future<void> _onLoadUserGroupsRequested(
    LoadUserGroupsRequested event,
    Emitter<GroupStudyState> emit,
  ) async {
    emit(GroupStudyLoading());
    final result = await _getUserGroupsUseCase();
    print(result);
    result.fold(
      (failure) => emit(GroupStudyError(failure)),
      (groups) => emit(GroupsLoaded(groups!)),
    );
  }
}
