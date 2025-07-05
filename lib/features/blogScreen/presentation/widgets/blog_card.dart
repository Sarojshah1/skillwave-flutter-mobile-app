import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class BlogCard extends StatefulWidget {
  final BlogEntity blog;
  final Function(BlogEntity blog) onCardTap;

  const BlogCard({super.key, required this.blog, required this.onCardTap});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  String _calculateReadingTime(String content) {
    final words = content.split(' ').length;
    final readingTime = (words / 200)
        .ceil(); // Average reading speed: 200 words per minute
    return '${readingTime} min read';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap: () => widget.onCardTap(widget.blog),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Content section
                    Padding(
                      padding: EdgeInsets.all(20.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            widget.blog.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),

                          // Description
                          Text(
                            widget.blog.content,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 12.h),

                          // Tags
                          if (widget.blog.tags.isNotEmpty)
                            Wrap(
                              spacing: 6.w,
                              runSpacing: 6.h,
                              children: widget.blog.tags.take(2).map((tag) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          SizedBox(height: 12.h),

                          // Bottom section with user info and stats
                          Row(
                            children: [
                              // User avatar and name
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16.r,
                                      backgroundImage:
                                          widget
                                              .blog
                                              .user
                                              .profilePicture
                                              .isNotEmpty
                                          ? CachedNetworkImageProvider(
                                              "http://10.0.2.2:3000/profile/${widget.blog.user.profilePicture}",
                                            )
                                          : null,
                                      backgroundColor: SkillWaveAppColors
                                          .primary
                                          .withValues(alpha: 0.1),
                                      child:
                                          widget
                                              .blog
                                              .user
                                              .profilePicture
                                              .isEmpty
                                          ? Text(
                                              widget.blog.user.name
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                color:
                                                    SkillWaveAppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.blog.user.name,
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            DateFormat(
                                              'MMM dd, yyyy',
                                            ).format(widget.blog.createdAt),
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: Colors.grey[600],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),

                              // Reading time and tags
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14.sp,
                                      color: Colors.grey[500],
                                    ),
                                    SizedBox(width: 2.w),
                                    Flexible(
                                      child: Text(
                                        _calculateReadingTime(
                                          widget.blog.content,
                                        ),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.visibility_outlined,
                                      size: 14.sp,
                                      color: Colors.grey[500],
                                    ),
                                    SizedBox(width: 2.w),
                                    Flexible(
                                      child: Text(
                                        '${widget.blog.tags.length}',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
