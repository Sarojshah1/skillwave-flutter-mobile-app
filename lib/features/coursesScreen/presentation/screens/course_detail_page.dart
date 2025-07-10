import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';
import 'package:skillwave/features/coursesScreen/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_hero_header.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_tab_navigation.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_overview_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_description_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_reviews_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_includes_section.dart';
import 'package:skillwave/features/coursesScreen/presentation/widgets/course_enroll_button.dart';
import 'package:skillwave/features/coursesScreen/presentation/screens/payment_page.dart';

@RoutePage()
class CourseDetailsPage extends StatefulWidget {
  final CourseEntity course;

  const CourseDetailsPage({super.key, required this.course});

  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  String activeTab = "overview";

  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(LoadReviewsByCourseId(widget.course.id));
  }

  void _handleBuyNow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          amount: widget.course.price,
          courseId: widget.course.id,
          course: widget.course,
        ),
      ),
    );
  }

  void _handleTabChanged(String tab) {
    setState(() {
      activeTab = tab;
    });
  }

  void _handleReviewsTabSelected() {
    context.read<ReviewBloc>().add(LoadReviewsByCourseId(widget.course.id));
  }

  void _handleSubmitReview(String courseId, int rating, String comment) {
    final bloc = context.read<ReviewBloc>();

    bloc.add(
      CreateReview(
        courseId: widget.course.id,
        rating: rating,
        comment: comment,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      bloc.add(LoadReviewsByCourseId(widget.course.id));
    });
  }

  void _handleLoadReviews() {
    context.read<ReviewBloc>().add(LoadReviewsByCourseId(widget.course.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          List<ReviewEntity> reviews = [];
          if (state is ReviewsLoaded) {
            reviews = state.reviews;
          } else if (state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewError) {
            return Center(child: Text('Error: ${state.failure.message}'));
          }
          return CustomScrollView(
            slivers: [
              CourseHeroHeader(course: widget.course),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CourseTabNavigation(
                        activeTab: activeTab,
                        onTabChanged: _handleTabChanged,
                        onReviewsTabSelected: _handleReviewsTabSelected,
                      ),
                      const SizedBox(height: 24),
                      if (activeTab == "overview")
                        CourseOverviewSection(course: widget.course),
                      if (activeTab == "description")
                        CourseDescriptionSection(course: widget.course),
                      if (activeTab == "reviews")
                        CourseReviewsSection(
                          reviews: reviews,
                          onSubmitReview: _handleSubmitReview,
                          onLoadReviews: _handleLoadReviews,
                        ),

                      const SizedBox(height: 24),
                      const CourseIncludesSection(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: CourseEnrollButton(onPressed: _handleBuyNow),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
