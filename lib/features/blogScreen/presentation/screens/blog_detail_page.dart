import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skillwave/features/blogScreen/domain/entity/blog_entity.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

@RoutePage()
class BlogDetailPage extends StatefulWidget {
  final BlogEntity blog;

  const BlogDetailPage({Key? key, required this.blog}) : super(key: key);

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  String? _localFilePath;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  Future<void> _downloadPDF() async {
    final url = "http://10.0.2.2:3000/uploads/pdfs/${widget.blog.content}";
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${widget.blog.content}';

    try {
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.stream),
      );

      final file = File(filePath);
      final sink = file.openWrite();

      response.data.stream.listen(
        (data) {
          sink.add(data);
        },
        onDone: () async {
          await sink.flush();
          await sink.close();
          setState(() {
            _localFilePath = filePath;
            _isLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        },
        cancelOnError: true,
      );
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  void _shareBlog() {
    final shareContent =
        "Check out this blog: ${widget.blog.title}\n\n"
        "Read more at: http://10.0.2.2:3000/uploads/pdfs/${widget.blog.content}";
    Share.share(shareContent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final colors = theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: Theme.of(context).appBarTheme.elevation ?? 2,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color:
                Theme.of(context).appBarTheme.iconTheme?.color ??
                SkillWaveAppColors.textInverse,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          splashRadius: 20,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite
                  ? SkillWaveAppColors.red
                  : Theme.of(context).appBarTheme.iconTheme?.color ??
                        SkillWaveAppColors.textInverse,
            ),
            onPressed: _toggleFavorite,
            splashRadius: 20,
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareBlog,
            splashRadius: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 100.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Card(
              elevation: 6,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.blog.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 26.sp,
                            letterSpacing: -0.5,
                          ),
                    ),
                    SizedBox(height: 22.h),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: SkillWaveAppColors.shadow,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 22.r,
                            backgroundImage: CachedNetworkImageProvider(
                              "http://10.0.2.2:3000/profile/${widget.blog.userId.profilePicture}",
                            ),
                            backgroundColor:
                                SkillWaveAppColors.lightGreyBackground,
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.blog.userId.name,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 15.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(widget.blog.createdAt),
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontSize: 13.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Icon(
                                    Icons.access_time,
                                    size: 15.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${_calculateReadingTime(widget.blog.title)} min read',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontSize: 13.sp,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (widget.blog.tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: widget.blog.tags.map((tag) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 7.h,
                            ),
                            decoration: BoxDecoration(
                              color: SkillWaveAppColors.primary.withOpacity(
                                0.08,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Text(
                              tag,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: SkillWaveAppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1.2,
            color: SkillWaveAppColors.border.withOpacity(0.18),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _isLoading
                  ? Center(
                      key: const ValueKey('loader'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: SkillWaveAppColors.primary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Loading blog content...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : _hasError
                  ? Center(
                      key: const ValueKey('error'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: SkillWaveAppColors.error,
                            size: 48,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Error loading PDF',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: SkillWaveAppColors.error),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 8.h,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: PDFView(
                          filePath: _localFilePath,
                          enableSwipe: true,
                          swipeHorizontal: false,
                          autoSpacing: false,
                          pageFling: true,
                          pageSnap: true,
                          defaultPage: 0,
                          fitPolicy: FitPolicy.BOTH,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateReadingTime(String content) {
    final words = content.split(' ').length;
    return (words / 200).ceil();
  }
}
