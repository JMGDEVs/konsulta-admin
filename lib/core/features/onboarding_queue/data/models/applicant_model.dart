class ApplicantModel {
  final String? id;
  final String? userCode;
  final String? applicantName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? professionalTag;
  final String? phone;
  final String? email;
  final String? documentStatus;
  final String? verificationStatus;
  final String? gender;
  final String? birthDate;
  final String? createdAt;
  final String? updatedAt;

  ApplicantModel({
    this.id,
    this.userCode,
    this.applicantName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.professionalTag,
    this.phone,
    this.email,
    this.documentStatus,
    this.verificationStatus,
    this.gender,
    this.birthDate,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName {
    // Check if applicant_name is available (from verified API)
    if (applicantName != null && applicantName!.isNotEmpty) {
      return applicantName!;
    }
    return [
      firstName,
      middleName,
      lastName,
    ].where((e) => e != null && e.isNotEmpty).join(' ');
  }

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    // Handle both API response structures:
    // 1. Pending/Under Review: {id, first_name, middle_name, last_name, ...}
    // 2. Verified: {user_id, user_code, applicant_name, ...}

    final isVerifiedApi = json.containsKey('user_id');

    if (isVerifiedApi) {
      // Verified API structure
      return ApplicantModel(
        id: json['user_id']?.toString(),
        userCode: json['user_code'],
        applicantName: json['applicant_name'],
        firstName: null,
        middleName: null,
        lastName: null,
        professionalTag: json['professional_tag'],
        phone: json['phone'],
        email: json['email'],
        documentStatus: json['document_status'],
        verificationStatus: json['verification_status'],
        gender: null, // Not in verified API
        birthDate: null, // Not in verified API
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    } else {
      // Pending/Under Review API structure
      return ApplicantModel(
        id: json['id']?.toString(),
        userCode: null,
        applicantName: null,
        firstName: json['first_name'],
        middleName: json['middle_name'],
        lastName: json['last_name'],
        professionalTag: json['professional_tag'],
        phone: json['phone'],
        email: json['email'],
        documentStatus: null,
        verificationStatus: json['verification_status'],
        gender: json['gender'],
        birthDate: json['birthdate'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
    }
  }
}
