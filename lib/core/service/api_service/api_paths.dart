class ApiPath {
  //authentication

  static const loginUserPath = '/auth/login';

  // onboarding queue
  static const getPendingApplicants = '/applicants/get-pending-review';
  static const getUnderReviewApplicants = '/applicants/get-under-review';
  static const startReview = '/document/start-review';
  static const getProfessionalTags = '/lookup/professional-tags';
}
