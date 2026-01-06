class ApplicantModel {
  final String? id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? professionalTag;
  final String? phone;
  final String? email;
  final String? verificationStatus;
  final String? gender;
  final String? birthDate;
  final String? createdAt;

  ApplicantModel({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.professionalTag,
    this.phone,
    this.email,
    this.verificationStatus,
    this.gender,
    this.birthDate,
    this.createdAt,
  });

  String get fullName {
    return [
      firstName,
      middleName,
      lastName,
    ].where((e) => e != null && e.isNotEmpty).join(' ');
  }

  factory ApplicantModel.fromJson(Map<String, dynamic> json) {
    return ApplicantModel(
      id: json['id']?.toString(),
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      professionalTag: json['professional_tag'],
      phone: json['phone'],
      email: json['email'],
      verificationStatus: json['verification_status'],
      gender: json['gender'],
      birthDate: json['birthdate'],
      createdAt: json['created_at'],
    );
  }
}
