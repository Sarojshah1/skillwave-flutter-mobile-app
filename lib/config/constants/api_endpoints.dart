class ApiEndpoints {

  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:3000/api";  // for emulator :10.0.2.2

  static const limit = 10;

// user routes
  static const String register = "$baseUrl/user/register";
  static const String login = "$baseUrl/user/login";
  static const String profile = "$baseUrl/user/profile";
  static const String allUsers = "$baseUrl/user";
  static const String changePassword = "$baseUrl/user/change-password";
  static const String updateDetails = "$baseUrl/user/update-details";
  static const String updateProfilePicture = "$baseUrl/user/update-profile-picture";
  static const String sendOtp="$baseUrl/otp";
  static const String verifyOtp="$baseUrl/verify";
  static const String payment="$baseUrl/payment";
  static const String ForgetPassword="$baseUrl/user/update-password-by-email";
//   course routes
  static const String getCourses="$baseUrl/courses/pagination";
// reviews
  static const String addReviews="$baseUrl/review/reviews";
  static String getReviewUrl(String courseId) {
    return "$baseUrl/review/reviews/course/$courseId";
  }
  static String getCourseUrl(String courseId) {
    return "$baseUrl/courses/$courseId";
  }

//   blogs
  static const String getBlogs="$baseUrl/blog/blogs";

  static const String getLearnings="$baseUrl/enroll/user";


//FormPost Api
  static const String createPost="$baseUrl/post";
  static const String getPost="$baseUrl/post";
  static String getpostlikeUrl(String postId) {
    return "$baseUrl/post/$postId/like";
  }
  static String getpostcommentUrl(String postId) {
    return "$baseUrl/post/$postId/comments";
  }
  static String getpostcommentReplyUrl(String postId,String commentId) {
    return "$baseUrl/post/$postId/comments/$commentId/replies";
  }

//   groups chats API'S
  static const String createGroup="$baseUrl/groupstudy/create";
  static const String getAllGroups="$baseUrl/groupstudy";
  static String getGroupMemberUrl(String groupId) {
    return "$baseUrl/groupstudy/$groupId/addMember";
  }
  static String getGroupChatUrl(String groupId) {
    return "$baseUrl/groupstudy/$groupId/sendChat";
  }
  static String getGroupsUrl(String groupId) {
    return "$baseUrl/groupstudy/$groupId/";
  }
  static String getUserGroupsUrl(String userId) {
    return "$baseUrl/groupstudy/user/$userId";
  }





}