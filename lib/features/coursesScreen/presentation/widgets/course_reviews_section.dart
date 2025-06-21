import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';

class CourseReviewsSection extends StatefulWidget {
  final List<ReviewEntity> reviews;
  final Function(String, int, String) onSubmitReview;
  final VoidCallback onLoadReviews;

  const CourseReviewsSection({
    Key? key,
    required this.reviews,
    required this.onSubmitReview,
    required this.onLoadReviews,
  }) : super(key: key);

  @override
  State<CourseReviewsSection> createState() => _CourseReviewsSectionState();
}

class _CourseReviewsSectionState extends State<CourseReviewsSection> {
  int visibleReviewCount = 2;
  int _currentPage = 0;
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;

  void _submitReview() {
    final review = _reviewController.text;
    if (review.isNotEmpty && _rating > 0) {
      widget.onSubmitReview('', _rating.round(), review);
      _reviewController.clear();
      setState(() => _rating = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List.of(widget.reviews)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final start = visibleReviewCount * _currentPage;
    final end = (start + visibleReviewCount).clamp(0, sorted.length);
    final visible = sorted.sublist(start, end);
    double overallRating = sorted.isNotEmpty
        ? sorted.map((r) => r.rating).reduce((a, b) => a + b) / sorted.length
        : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star,
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Student Reviews',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Overall Rating
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      overallRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBarIndicator(
                      rating: overallRating,
                      itemBuilder: (context, index) => const Icon(Icons.star),
                      itemCount: 5,
                      itemSize: 24.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.reviews.length} reviews',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Excellent course!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Students love this course for its comprehensive content and practical approach.',
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Reviews Section
          if (widget.reviews.isEmpty) ...[
            const Center(
              child: Text(
                'No reviews for now.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ] else ...[
            const Text(
              'Recent Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...visible.map((review) => _buildReviewCard(review)),
            const SizedBox(height: 16),

            // Pagination
            if (sorted.length > visibleReviewCount)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentPage > 0)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _currentPage--),
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.grey[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  if (_currentPage > 0 && end < sorted.length)
                    const SizedBox(width: 12),
                  if (end < sorted.length)
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _currentPage++),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                ],
              ),
          ],

          const SizedBox(height: 24),

          // Add Review Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Your Review',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Rating
                Row(
                  children: [
                    Text(
                      'Rating: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: _rating,
                      itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Color(0xFFF59E0B)),
                      onRatingUpdate: (rating) =>
                          setState(() => _rating = rating),
                      itemSize: 28,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Review Text
                TextField(
                  controller: _reviewController,
                  decoration: InputDecoration(
                    hintText: 'Share your experience with this course...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB)),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: 4,
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitReview,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Review'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewEntity review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  "http://10.0.2.2:3000/profile/${review.user.profilePicture}",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(review.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              RatingBarIndicator(
                rating: review.rating.toDouble(),
                itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Color(0xFFF59E0B)),
                itemCount: 5,
                itemSize: 16.0,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
