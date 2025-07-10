import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_post_bloc/create_post_state.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/get_posts_bloc/get_posts_bloc.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_dto.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/get_posts_bloc/get_posts_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/get_posts_bloc/get_posts_state.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/realtime_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/widgets/post_card_widgets/post_card.dart';
import 'package:skillwave/features/dashboardScreen/presentation/widgets/dashboard_widgets/dashboard_app_bar.dart';
import 'package:skillwave/features/dashboardScreen/presentation/widgets/dashboard_widgets/dashboard_search_bar.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'package:skillwave/cores/shared_prefs/user_shared_prefs.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final String _selectedCategory = 'All';
  final List<String> _selectedTags = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;
  List<PostEntity> _allPosts = [];
  late RealtimeCommentBloc _realtimeBloc;
  final UserSharedPrefs _userPrefs = getIt<UserSharedPrefs>();

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _setupScrollListener();
    _initializeRealtimeComments();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMorePosts();
      }
    });
  }

  void _initializeRealtimeComments() async {
    try {
      _realtimeBloc = context.read<RealtimeCommentBloc>();

      // Get user token for socket authentication
      final tokenResult = await _userPrefs.getUserToken();
      final token = tokenResult.fold((_) => null, (token) => token);

      // Initialize socket connection
      _realtimeBloc.add(
        InitializeSocket(baseUrl: ApiEndpoints.baseUrl, token: token),
      );
    } catch (e) {
      // Handle initialization error silently
      print('Failed to initialize real-time comments: $e');
    }
  }

  void _loadPosts() {
    _currentPage = 1;
    _allPosts.clear();
    _hasMorePosts = true;

    final dto = GetPostsDto(
      page: _currentPage,
      limit: 10,
      category: _selectedCategory == 'All' ? null : _selectedCategory,
      search: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      tags: _selectedTags.isEmpty ? null : _selectedTags,
    );

    context.read<GetPostsBloc>().add(GetPosts(dto));
  }

  void _loadMorePosts() {
    if (!_isLoadingMore && _hasMorePosts) {
      setState(() {
        _isLoadingMore = true;
      });

      _currentPage++;
      final dto = GetPostsDto(
        page: _currentPage,
        limit: 10,
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        tags: _selectedTags.isEmpty ? null : _selectedTags,
      );

      context.read<GetPostsBloc>().add(GetPosts(dto));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SkillWaveAppColors.background,
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreatePostBloc, CreatePostState>(
            listener: (context, state) {
              if (state is CreatePostLoaded) {
                _loadPosts();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post created successfully!'),
                    backgroundColor: SkillWaveAppColors.success,
                  ),
                );
              } else if (state is CreatePostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: SkillWaveAppColors.error,
                  ),
                );
              }
            },
          ),
          BlocListener<RealtimeCommentBloc, RealtimeCommentState>(
            listener: (context, state) {
              if (state is RealtimeCommentConnected) {
                // Socket connected successfully
                print('✅ Real-time comments connected');
              } else if (state is RealtimeCommentError) {
                // Socket connection error
                print('❌ Real-time comments error: ${state.message}');
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            _currentPage = 1;
            _allPosts.clear();
            _loadPosts();
          },
          color: SkillWaveAppColors.primary,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Dashboard App Bar
              const DashboardAppBar(),

              // Search Bar Sliver
              SliverToBoxAdapter(
                child: DashboardSearchBar(
                  controller: _searchController,
                  onSearch: _loadPosts,
                ),
              ),
              BlocConsumer<GetPostsBloc, GetPostsState>(
                listener: (context, state) {
                  if (state is GetPostsLoaded) {
                    if (_currentPage == 1) {
                      _allPosts = state.posts.posts;
                    } else {
                      // Load more - append posts
                      _allPosts.addAll(state.posts.posts);
                    }

                    // Check if we have more posts
                    _hasMorePosts = state.posts.posts.length >= 10;

                    setState(() {
                      _isLoadingMore = false;
                    });
                  } else if (state is GetPostsError) {
                    setState(() {
                      _isLoadingMore = false;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is GetPostsLoading && _currentPage == 1) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            SkillWaveAppColors.primary,
                          ),
                        ),
                      ),
                    );
                  } else if (_allPosts.isEmpty && state is! GetPostsLoading) {
                    return SliverFillRemaining(child: _buildEmptyState());
                  } else if (state is GetPostsError && _allPosts.isEmpty) {
                    return SliverFillRemaining(
                      child: _buildErrorWidget(state.message),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == _allPosts.length) {
                            // Show loading indicator at the bottom
                            if (_isLoadingMore) {
                              return _buildLoadingMoreIndicator();
                            } else if (_hasMorePosts) {
                              return _buildLoadMoreButton();
                            } else {
                              return _buildEndOfPostsIndicator();
                            }
                          }

                          final post = _allPosts[index];
                          return PostCard(post: post);
                        },
                        childCount:
                            _allPosts.length +
                            1, // +1 for loading/end indicator
                      ),
                    );
                  }
                },
              ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(
        child: Column(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  SkillWaveAppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading more posts...',
              style: TextStyle(
                color: SkillWaveAppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: ElevatedButton(
          onPressed: _loadMorePosts,
          style: ElevatedButton.styleFrom(
            backgroundColor: SkillWaveAppColors.primary,
            foregroundColor: SkillWaveAppColors.textInverse,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Load More Posts',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildEndOfPostsIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: SkillWaveAppColors.success,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              'You\'ve reached the end!',
              style: TextStyle(
                color: SkillWaveAppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'No more posts to load',
              style: TextStyle(
                color: SkillWaveAppColors.textDisabled,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.post_add,
            size: 64,
            color: SkillWaveAppColors.textDisabled,
          ),
          SizedBox(height: 16),
          Text(
            'No posts found',
            style: TextStyle(
              color: SkillWaveAppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: SkillWaveAppColors.textDisabled,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: SkillWaveAppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading posts',
            style: AppTextStyles.bodyLarge.copyWith(
              color: SkillWaveAppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: SkillWaveAppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPosts,
            style: ElevatedButton.styleFrom(
              backgroundColor: SkillWaveAppColors.primary,
              foregroundColor: SkillWaveAppColors.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
