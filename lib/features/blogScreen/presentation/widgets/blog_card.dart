import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';

class BlogCard extends StatelessWidget {
  final BlogEntity blog;
  final Function(BlogEntity blog) onCardTap;

  const BlogCard({Key? key, required this.blog, required this.onCardTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final text = theme.textTheme;

    final chipBackground = theme.brightness == Brightness.dark
        ? color.primary.withOpacity(0.15)
        : color.primaryContainer.withOpacity(0.3);

    return InkWell(
      onTap: () => onCardTap(blog),
      borderRadius: BorderRadius.circular(24.r),
      splashColor: color.primary.withOpacity(0.08),
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withOpacity(0.13),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Accent bar
            Container(
              width: 6.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  bottomLeft: Radius.circular(24.r),
                ),
                gradient: LinearGradient(
                  colors: [color.primary, color.primary.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(18.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      blog.title,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: color.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: color.primary, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 16.r,
                            backgroundImage: CachedNetworkImageProvider(
                              "http://10.0.2.2:3000/profile/${blog.user.profilePicture}",
                            ),
                            backgroundColor: color.surfaceVariant,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            blog.user.name,
                            style: text.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: color.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: color.onSurface.withOpacity(0.6),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          DateFormat('MMM dd, yyyy').format(blog.createdAt),
                          style: text.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: color.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Wrap(
                      spacing: 12,
                      runSpacing: 20,
                      children: blog.tags.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            color: chipBackground,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: color.primary.withOpacity(0.08),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            tag,
                            style: text.labelSmall?.copyWith(
                              color: color.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
