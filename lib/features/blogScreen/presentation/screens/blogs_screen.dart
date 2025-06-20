import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/features/blogScreen/presentation/bloc/blog_bloc.dart';
import 'package:skillwave/features/blogScreen/presentation/widgets/blog_card.dart';

import 'blog_detail_page.dart';

@RoutePage()
class BlogsView extends StatefulWidget {
  const BlogsView({super.key});

  @override
  State<BlogsView> createState() => _BlogsViewState();
}

class _BlogsViewState extends State<BlogsView> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  int page = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<BlogBloc>().add(LoadBlogs(page: page, limit: limit));
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      page++;
      context.read<BlogBloc>().add(LoadBlogs(page: page, limit: limit));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onBlogTap(BlogEntity blog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BlogDetailPage(blog: blog)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final text = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          List<BlogEntity> blogs = [];

          if (state is BlogLoaded) {
            blogs = state.blogs;
          }

          final filteredBlogs = blogs.where((blog) {
            return blog.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              page = 1;
              context.read<BlogBloc>().add(LoadBlogs(page: page, limit: limit));
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  expandedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Explore Blogs',
                      style: text.titleLarge?.copyWith(color: color.onPrimary),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [Colors.black26, Colors.black12]
                              : [SkillWaveAppColors.primary, color.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for blogs...',
                        hintStyle: text.bodyMedium?.copyWith(
                          color: color.onSurface.withOpacity(0.6),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: color.surfaceVariant.withOpacity(0.2),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      style: text.bodyMedium,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Discover a wide range of blog topics.',
                      style: text.bodyLarge?.copyWith(
                        color: color.onBackground.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                if (state is BlogLoading && blogs.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (filteredBlogs.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "No blogs found.",
                        style: text.bodyLarge?.copyWith(
                          color: color.onBackground,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final blog = filteredBlogs[index];
                        return BlogCard(blog: blog, onCardTap: _onBlogTap);
                      }, childCount: filteredBlogs.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 600
                            ? 3
                            : 1,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                      ),
                    ),
                  ),

                if (state is BlogLoading && blogs.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color.primary,
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: Navigate to create blog screen
        },
      ),
    );
  }
}
