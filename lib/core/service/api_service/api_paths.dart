class ApiPath {
  //authentication

  static const loginUserPath = '/auth/login';

  // onboarding queue
  static const getPendingApplicants = '/applicants/get-pending-review';
  static const getUnderReviewApplicants = '/applicants/get-under-review';
  static const getVerifiedApplicants = '/applicants/get-verified';
  static const getRejectedApplicants = '/applicants/get-rejected';
  static const startReview = '/document/start-review';
  static const getProfessionalTags = '/lookup/professional-tags';
}
