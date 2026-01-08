// TODO: REMOVE THIS FILE WHEN REAL DATA IS AVAILABLE IN DATABASE
// This file contains mock data for Under Review screen UI completion
// Created: 2026-01-07
// Updated: 2026-01-08 - Changed to conditional fallback
// Purpose: Temporary mock data as fallback when API returns empty results

import 'package:konsulta_admin/core/features/onboarding_queue/data/models/applicant_model.dart';

/// Enable mock data fallback when API returns empty.
/// When false, shows empty state instead of mock data.
const bool USE_MOCK_UNDER_REVIEW_DATA = true;

/// Mock applicants data for Under Review screen
/// Based on Figma design requirements
final List<ApplicantModel> mockUnderReviewApplicants = [
  ApplicantModel(
    id: 'mock_001',
    firstName: 'Steve',
    middleName: 'Clark',
    lastName: 'Rogers',
    professionalTag: 'Doctor',
    phone: '09XX92X048X',
    email: 'Emailaddress@gmail.com',
    verificationStatus: 'Pending',
    gender: 'Male',
    birthDate: '1990-07-04T00:00:00.000Z',
    createdAt: '2025-12-15T08:30:00.000Z',
  ),
  ApplicantModel(
    id: 'mock_002',
    firstName: 'Steve',
    middleName: 'Clark',
    lastName: 'Rogers',
    professionalTag: 'Doctor',
    phone: '09XX92X048X',
    email: null, // Test null email → displays "---"
    verificationStatus: 'Pending',
    gender: null, // Test null gender → displays "---"
    birthDate: '1988-03-15T00:00:00.000Z',
    createdAt: '2025-12-16T09:15:00.000Z',
  ),
  ApplicantModel(
    id: 'mock_003',
    firstName: 'Steve',
    middleName: 'Clark',
    lastName: 'Rogers',
    professionalTag: 'Doctor',
    phone: '09XX92X048X',
    email: 'Emailaddress@gmail.com',
    verificationStatus: 'Pending',
    gender: 'Male',
    birthDate: '1992-11-20T00:00:00.000Z',
    createdAt: '2025-12-17T10:45:00.000Z',
  ),
  ApplicantModel(
    id: 'mock_004',
    firstName: 'Steve',
    middleName: 'Clark',
    lastName: 'Rogers',
    professionalTag: 'Doctor',
    phone: '09XX92X048X',
    email: null,
    verificationStatus: 'Pending',
    gender: null,
    birthDate: '1995-05-08T00:00:00.000Z',
    createdAt: '2025-12-18T11:20:00.000Z',
  ),
  ApplicantModel(
    id: 'mock_005',
    firstName: 'Steve',
    middleName: 'Clark',
    lastName: 'Rogers',
    professionalTag: 'Doctor',
    phone: '09XX92X048X',
    email: 'Emailaddress@gmail.com',
    verificationStatus: 'Pending',
    gender: 'Female',
    birthDate: '1987-09-30T00:00:00.000Z',
    createdAt: '2025-12-19T14:00:00.000Z',
  ),
  // Additional diverse mock data for testing filters
  ApplicantModel(
    id: 'mock_006',
    firstName: 'Maria',
    middleName: 'Santos',
    lastName: 'Cruz',
    professionalTag: 'Nurse',
    phone: '09123456789',
    email: 'maria.cruz@gmail.com',
    verificationStatus: 'Pending',
    gender: 'Female',
    birthDate: '1993-02-14T00:00:00.000Z',
    createdAt: '2025-12-20T15:30:00.000Z',
  ),
  ApplicantModel(
    id: 'mock_007',
    firstName: 'Juan',
    middleName: 'dela',
    lastName: 'Cruz',
    professionalTag: 'Psychologist',
    phone: '09987654321',
    email: 'juan.delacruz@yahoo.com',
    verificationStatus: 'Pending',
    gender: 'Male',
    birthDate: '1991-08-22T00:00:00.000Z',
    createdAt: '2025-12-21T16:45:00.000Z',
  ),
  ApplicantModel(
    id: 'mock_008',
    firstName: 'Ana',
    middleName: 'Marie',
    lastName: 'Reyes',
    professionalTag: 'Midwife',
    phone: '09456123789',
    email: 'ana.reyes@outlook.com',
    verificationStatus: 'Pending',
    gender: 'Female',
    birthDate: '1994-05-10T00:00:00.000Z',
    createdAt: '2025-12-22T17:20:00.000Z',
  ),
];
