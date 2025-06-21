import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/routes/app_router.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/course_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_card.dart';

@RoutePage()
class CoursesView extends StatefulWidget {
  const CoursesView({super.key});

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';
  int page = 1;
  final int limit = 10;
  bool _isLoadingMore = false;
  bool _isSearchFocused = false;
  bool _showFilters = false;

  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  final List<String> _categories = [
    'All',
    'Programming',
    'Design',
    'Business',
    'Marketing',
    'Music',
    'Photography',
  ];
  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    );

    context.read<CourseBloc>().add(LoadCourses(page: page, limit: limit));

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<CourseBloc>();
      final state = bloc.state;
      if (state is CourseLoaded && !state.hasReachedMax && !_isLoadingMore) {
        _isLoadingMore = true;
        page++;
        bloc.add(LoadCourses(page: page, limit: limit));
      }
    }
  }

  Future<void> _onRefresh() async {
    page = 1;
    _isLoadingMore = false;
    context.read<CourseBloc>().add(LoadCourses(page: page, limit: limit));
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    if (_showFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onLevelChanged(String level) {
    setState(() {
      _selectedLevel = level;
    });
  }

  List<CourseEntity> _filterCourses(List<CourseEntity> courses) {
    return courses.where((course) {
      final matchesSearch =
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          course.createdBy.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesCategory =
          _selectedCategory == 'All' ||
          course.title.toLowerCase().contains(_selectedCategory.toLowerCase());

      final matchesLevel =
          _selectedLevel == 'All' ||
          course.level.toLowerCase() == _selectedLevel.toLowerCase();

      return matchesSearch && matchesCategory && matchesLevel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: SkillWaveAppColors.background,
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          List<CourseEntity> courses = [];
          if (state is CourseLoaded) {
            courses = state.courses;
            _isLoadingMore = false;
          }

          final filteredCourses = _filterCourses(courses);

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              key: ValueKey('scroll_${isTablet ? "tablet" : "mobile"}'),
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  expandedHeight: 120.h,
                  backgroundColor: SkillWaveAppColors.primary,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Explore Courses',
                      style: textTheme.titleLarge?.copyWith(
                        color: SkillWaveAppColors.textInverse,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        color: SkillWaveAppColors.primary,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: _toggleFilters,
                      icon: AnimatedRotation(
                        turns: _showFilters ? 0.125 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.tune,
                          color: SkillWaveAppColors.textInverse,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                  ],
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: SkillWaveAppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: SkillWaveAppColors.shadow.withOpacity(0.1),
                          blurRadius: 10.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: _isSearchFocused
                              ? SkillWaveAppColors.primary
                              : SkillWaveAppColors.border,
                          width: _isSearchFocused ? 2 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search courses, instructors, or topics...',
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: SkillWaveAppColors.textSecondary,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: _isSearchFocused
                                ? SkillWaveAppColors.primary
                                : SkillWaveAppColors.textSecondary,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    _searchFocusNode.unfocus();
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: SkillWaveAppColors.textSecondary,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: SkillWaveAppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_showFilters)
                  SliverToBoxAdapter(
                    child: SizeTransition(
                      sizeFactor: _filterAnimation,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: SkillWaveAppColors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: SkillWaveAppColors.shadow.withOpacity(0.1),
                              blurRadius: 10.r,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Filters',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: SkillWaveAppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Category',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: SkillWaveAppColors.textSecondary,
                              ),
                            ),
                          SizedBox(height: 8.h),

                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: _categories.map((category) {
                                final isSelected =
                                    _selectedCategory == category;
                                return GestureDetector(
                                  onTap: () => _onCategoryChanged(category),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? SkillWaveAppColors.primary
                                          : SkillWaveAppColors
                                                .lightGreyBackground,
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? SkillWaveAppColors.primary
                                            : SkillWaveAppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: isSelected
                                            ? SkillWaveAppColors.textInverse
                                            : SkillWaveAppColors.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Level',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: SkillWaveAppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: _levels.map((level) {
                                final isSelected = _selectedLevel == level;
                                return GestureDetector(
                                  onTap: () => _onLevelChanged(level),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? SkillWaveAppColors.secondary
                                          : SkillWaveAppColors
                                                .lightGreyBackground,
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? SkillWaveAppColors.secondary
                                            : SkillWaveAppColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      level,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: isSelected
                                            ? SkillWaveAppColors.textInverse
                                            : SkillWaveAppColors.textPrimary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filteredCourses.length} courses found',
                          style: textTheme.bodyMedium?.copyWith(
                            color: SkillWaveAppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty ||
                            _selectedCategory != 'All' ||
                            _selectedLevel != 'All')
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _selectedCategory = 'All';
                                _selectedLevel = 'All';
                                _searchController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.clear_all,
                              size: 16.r,
                              color: SkillWaveAppColors.primary,
                            ),
                            label: Text(
                              'Clear filters',
                              style: textTheme.bodySmall?.copyWith(
                                color: SkillWaveAppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 8.h)),


                // Loading State
                if (state is CourseLoading && courses.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                // Empty State
                else if (filteredCourses.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80.r,
                            color: SkillWaveAppColors.textSecondary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _searchQuery.isNotEmpty ||
                                    _selectedCategory != 'All' ||
                                    _selectedLevel != 'All'
                                ? 'No courses match your filters'
                                : 'No courses available',
                            style: textTheme.titleMedium?.copyWith(
                              color: SkillWaveAppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h)
                          ,

                          Text(
                            _searchQuery.isNotEmpty ||
                                    _selectedCategory != 'All' ||
                                    _selectedLevel != 'All'
                                ? 'Try adjusting your search or filters'
                                : 'Check back later for new courses',
                            style: textTheme.bodyMedium?.copyWith(
                              color: SkillWaveAppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_searchQuery.isNotEmpty ||
                              _selectedCategory != 'All' ||
                              _selectedLevel != 'All')
                            Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _selectedCategory = 'All';
                                    _selectedLevel = 'All';
                                    _searchController.clear();
                                  });
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Clear filters'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SkillWaveAppColors.primary,
                                  foregroundColor:
                                      SkillWaveAppColors.textInverse,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                // Courses Grid/List
                else
                  SliverPadding(
                    padding: EdgeInsets.all(16.w),
                    sliver: isTablet
                        ? SliverGrid(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final course = filteredCourses[index];
                              return CourseCard(
                                key: ValueKey('${course.id}_${isTablet ? "tablet" : "mobile"}'),
                                course: course,
                                onEnroll: () {
                                  context.router
                                      .push(CourseDetailsRoute(course: course))
                                      .then((shouldRefresh) {
                                        if (shouldRefresh == true) {
                                          context.read<CourseBloc>().add(
                                            LoadCourses(page: 1, limit: 10),
                                          );
                                        }
                                      });
                                },
                              );
                            }, childCount: filteredCourses.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.w,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 0.75,
                                ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final course = filteredCourses[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: CourseCard(
                                  key: ValueKey(course.id),
                                  course: course,
                                  onEnroll: () {
                                    context.router
                                        .push(
                                          CourseDetailsRoute(course: course),
                                        )
                                        .then((shouldRefresh) {
                                          if (shouldRefresh == true) {
                                            context.read<CourseBloc>().add(
                                              LoadCourses(page: 1, limit: 10),
                                            );
                                          }
                                        });
                                  },
                                ),
                              );
                            }, childCount: filteredCourses.length),
                          ),
                  ),

                // Loading More Indicator
                if (state is CourseLoading && courses.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(
                              color: SkillWaveAppColors.primary,
                            ),
                            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                            Text(
                              'Loading more courses...',
                              style: textTheme.bodyMedium?.copyWith(
                                color: SkillWaveAppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            ),
          );
        },
      ),
    );
  }
}
