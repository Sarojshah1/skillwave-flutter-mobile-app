import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/features/study_groups/domain/usecases/get_user_groups_usecase.dart';
import 'package:skillwave/features/study_groups/presentation/view_model/group_study_bloc.dart';
import 'package:skillwave/features/study_groups/presentation/widgets/group_card.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'package:skillwave/features/study_groups/domain/usecases/create_group_usecase.dart';
import 'package:skillwave/features/study_groups/domain/usecases/get_all_groups_usecase.dart';

@RoutePage()
class GroupStudyPage extends StatefulWidget {
  const GroupStudyPage({Key? key}) : super(key: key);

  @override
  State<GroupStudyPage> createState() => _GroupStudyPageState();
}

class _GroupStudyPageState extends State<GroupStudyPage> {
  final Set<String> _joinedGroupIds = {};
  final ScrollController _scrollController = ScrollController();

  void _handleJoin(GroupEntity group) {
    setState(() {
      _joinedGroupIds.add(group.id);
    });
    // TODO: Call join group API or Bloc event here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined ${group.groupName}!'),
        backgroundColor: SkillWaveAppColors.success,
      ),
    );
  }

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
        floatingActionButton: SizedBox(
          width: 180,
          height: 56,
          child: FloatingActionButton.extended(
            onPressed: () {
              context.router.push(const CreateGroupRoute());
            },
            icon: const Icon(Icons.add, size: 28),
            label: const Text(
              'Create Group',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            backgroundColor: SkillWaveAppColors.primary,
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocProvider(
          create: (_) => GroupStudyBloc(
            getIt<CreateGroupUseCase>(),
            getIt<GetAllGroupsUseCase>(),
            getIt<GetUserGroupsUseCase>(),
          )..add(LoadAllGroupsRequested()),
          child: BlocBuilder<GroupStudyBloc, GroupStudyState>(
            builder: (context, state) {
              return CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    snap: false,
                    expandedHeight: 120,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            SkillWaveAppColors.primary,
                            SkillWaveAppColors.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: SkillWaveAppColors.primary,
                            blurRadius: 24,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Text(
                              'Study Groups',
                              style: textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                  ),
                  if (state is GroupStudyLoading)
                    SliverToBoxAdapter(child: _buildShimmerLoader(context))
                  else if (state is GroupStudyError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          state.failure.message,
                          style: textTheme.bodyLarge?.copyWith(
                            color: SkillWaveAppColors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else if (state is GroupsLoaded)
                    state.groups.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                'No groups found.',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: SkillWaveAppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final group = state.groups[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: GroupCard(
                                  group: group,
                                  isJoined: _joinedGroupIds.contains(group.id),
                                  onJoin: _joinedGroupIds.contains(group.id)
                                      ? null
                                      : () => _handleJoin(group),
                                ),
                              );
                            }, childCount: state.groups.length),
                          )
                  else if (state is GroupCreated)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: SkillWaveAppColors.success,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Group "${state.group.groupName}" created!',
                              style: textTheme.titleLarge?.copyWith(
                                color: SkillWaveAppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<GroupStudyBloc>().add(
                                  LoadAllGroupsRequested(),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Back to Groups'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SkillWaveAppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const SliverFillRemaining(child: SizedBox.shrink()),
                  // Add bottom padding for FAB
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader(BuildContext context) {
    // Modern shimmer/skeleton loader for group cards
    return Column(
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: SkillWaveAppColors.shadow,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  margin: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 18,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                      Container(
                        width: 180,
                        height: 14,
                        color: Colors.grey[200],
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                      Container(width: 80, height: 12, color: Colors.grey[100]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
