import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';

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
    _fadeAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
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
    final readingTime = (words / 200).ceil();
    return '$readingTime min read';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: SkillWaveAppColors.backgroundGradient_2,
                  boxShadow: [
                    BoxShadow(
                      color: SkillWaveAppColors.shadow,
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: SkillWaveAppColors.border.withOpacity(0.18),
                    width: 1.2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Colored header bar
                      Container(
                        height: 8,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              SkillWaveAppColors.primary,
                              SkillWaveAppColors.secondary,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      // Main content area with fixed height for grid safety
                      SizedBox(
                        height: 180, // Adjust as needed for your design
                        child: Padding(
                          padding: EdgeInsets.all(20.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.blog.title,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: SkillWaveAppColors.textPrimary,
                                  fontSize: 18.sp,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Avatar
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: SkillWaveAppColors.primary
                                              .withOpacity(0.12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 18.r,
                                      backgroundColor:
                                          SkillWaveAppColors.textInverse,
                                      backgroundImage:
                                          widget
                                              .blog
                                              .user
                                              .profilePicture
                                              .isNotEmpty
                                          ? CachedNetworkImageProvider(
                                              "${ApiEndpoints.baseUrlForImage}/profile/${widget.blog.user.profilePicture}",
                                            )
                                          : null,
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
                                              style: AppTextStyles.bodyLarge
                                                  .copyWith(
                                                    color: SkillWaveAppColors
                                                        .primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Flexible(
                                    child: Text(
                                      widget.blog.user.name,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: SkillWaveAppColors.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(widget.blog.createdAt),
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: SkillWaveAppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  // Reading time
                                  Icon(
                                    Icons.access_time,
                                    size: 16.sp,
                                    color: SkillWaveAppColors.textSecondary,
                                  ),
                                  SizedBox(width: 2.w),
                                  Flexible(
                                    child: Text(
                                      _calculateReadingTime(
                                        widget.blog.content,
                                      ),
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: SkillWaveAppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  // Views (using tags count as placeholder)
                                  Icon(
                                    Icons.visibility_outlined,
                                    size: 16.sp,
                                    color: SkillWaveAppColors.textSecondary,
                                  ),
                                  SizedBox(width: 2.w),
                                  Flexible(
                                    child: Text(
                                      '${widget.blog.tags.length}',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: SkillWaveAppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
