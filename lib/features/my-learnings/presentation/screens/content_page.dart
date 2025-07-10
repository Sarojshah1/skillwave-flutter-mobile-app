import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';

@RoutePage()
class ContentPage extends StatefulWidget {
  final LessonEntity lesson;
  const ContentPage({super.key, required this.lesson});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String? _localFilePath;
  bool _isLoadingPDF = false;
  bool _hasPDFError = false;

  @override
  void initState() {
    super.initState();
    _downloadPDF();
  }

  Future<void> _downloadPDF() async {
    print(widget.lesson.content);
    final url =
        "${ApiEndpoints.baseUrlForImage}/uploads/pdfs/${widget.lesson.content}";
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${widget.lesson.content}';

    try {
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.stream),
      );

      final file = File(filePath);
      final sink = file.openWrite(); // Create an IOSink for writing

      // Listen to the data stream and write to file
      response.data.stream.listen(
        (data) {
          sink.add(data); // Write data chunks to file
        },
        onDone: () async {
          await sink.flush(); // Ensure all data is written
          await sink.close(); // Close the file
          setState(() {
            _localFilePath = filePath;
            _isLoadingPDF = false;
          });
        },
        onError: (error) {
          setState(() {
            _hasPDFError = true;
            _isLoadingPDF = false;
          });
        },
        cancelOnError: true,
      );
    } catch (e) {
      setState(() {
        _hasPDFError = true;
        _isLoadingPDF = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPDF) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.lesson.title),
          flexibleSpace: Container(color: SkillWaveAppColors.primary),
        ),
        body: Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color(0xFF1A1A3F),
            rightDotColor: const Color(0xFFEA3799),
            size: 50,
          ),
        ),
      );
    }

    if (_hasPDFError) {
      return Scaffold(
        appBar: AppBar(
          title: Text('PDF Viewer'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: Center(child: Text('Error loading PDF.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: SkillWaveAppColors.primary),
        ),
      ),
      body: _localFilePath != null
          ? PDFView(filePath: _localFilePath)
          : Center(child: Text('No PDF file found')),
    );
  }
}
