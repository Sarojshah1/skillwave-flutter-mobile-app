import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/study_groups/presentation/widgets/messenger_group_card.dart';
import 'package:skillwave/features/study_groups/presentation/view_model/group_study_bloc.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'package:skillwave/features/study_groups/domain/usecases/create_group_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/get_all_groups_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/get_user_groups_usecase.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';
import 'package:skillwave/features/study_groups/presentation/view/group_chat_page.dart';

@RoutePage(name: 'MyStudyGroupsRoute')
class MyStudyGroupsPage extends StatefulWidget {
  const MyStudyGroupsPage({Key? key}) : super(key: key);

  @override
  State<MyStudyGroupsPage> createState() => _MyStudyGroupsPageState();
}

class _MyStudyGroupsPageState extends State<MyStudyGroupsPage> {
  final ScrollController _scrollController = ScrollController();
  String? _userId;

  @override
  void initState() {
    super.initState();
    context.read<GroupStudyBloc>().add(LoadUserGroupsRequested());
    _loadUserIdAndGroups();
  }

  Future<void> _loadUserIdAndGroups() async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      decoration: const BoxDecoration(
        gradient: SkillWaveAppColors.backgroundGradient_2,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('My Study Groups'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (_) => GroupStudyBloc(
            getIt<CreateGroupUseCase>(),
            getIt<GetAllGroupsUseCase>(),
            getIt<GetUserGroupsUseCase>(),
          )..add(LoadUserGroupsRequested()),
          child: BlocBuilder<GroupStudyBloc, GroupStudyState>(
            builder: (context, state) {
              if (state is GroupStudyLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GroupStudyError) {
                return Center(
                  child: Text(
                    state.failure.message,
                    style: textTheme.bodyLarge?.copyWith(
                      color: SkillWaveAppColors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              } else if (state is GroupsLoaded) {
                print("data of view ${state.groups}");
                if (state.groups.isEmpty) {
                  return Center(
                    child: Text(
                      'You have not joined any groups.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: SkillWaveAppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.groups.length,
                  itemBuilder: (context, index) {
                    final group = state.groups[index];
                    return MessengerGroupCard(
                      group: group,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                GroupChatPage(groupName: group.groupName),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
