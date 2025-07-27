import 'package:equatable/equatable.dart';

import '../../../../utility/constant/errors.dart';

class LocalJobsResponse extends Equatable {
  final String status;
  final String message;
  final List<LocalJob> data;

  const LocalJobsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LocalJobsResponse.fromMap(Map<String, dynamic> map) {
    return LocalJobsResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      data: List<LocalJob>.from(
        (map['data'] ?? []).map((x) => LocalJob.fromMap(x)),
      ),
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }


  @override
  List<Object?> get props => [status, message, data];
}

class LocalJob extends Equatable {
  final String id;
  final String companyName;
  final String jobDesignation;
  final String address;
  final String jobType;
  final String workType;
  final String cityName;
  final List<String> mustHaveSkills;
  final int minWorkExperience;
  final int maxWorkExperience;
  final int minSalary;
  final int maxSalary;
  final List<JobMedia> media;

  const LocalJob({
    required this.id,
    required this.companyName,
    required this.jobDesignation,
    required this.address,
    required this.jobType,
    required this.workType,
    required this.cityName,
    required this.mustHaveSkills,
    required this.minWorkExperience,
    required this.maxWorkExperience,
    required this.minSalary,
    required this.maxSalary,
    required this.media,
  });


  factory LocalJob.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLocalJob(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalJob(map);
    }
  }

  static LocalJob _buildLocalJob(Map<String, dynamic> map) {
    return LocalJob(
      id: map['id'] ?? '',
      companyName: map['company_name'] ?? '',
      jobDesignation: map['job_designation'] ?? '',
      address: map['address'] ?? '',
      jobType: map['job_type'] ?? '',
      workType: map['work_type'] ?? '',
      cityName: map['city_name'] ?? '',
      mustHaveSkills: List<String>.from(map['must_have_skills'] ?? []),
      minWorkExperience: map['min_work_experience'] ?? 0,
      maxWorkExperience: map['max_work_experience'] ?? 0,
      minSalary: map['min_salary'] ?? 0,
      maxSalary: map['max_salary'] ?? 0,
      media: List<JobMedia>.from(
        (map['media'] ?? []).map((x) => JobMedia.fromMap(x)),
      ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        companyName,
        jobDesignation,
        address,
        jobType,
        workType,
        cityName,
        mustHaveSkills,
        minWorkExperience,
        maxWorkExperience,
        minSalary,
        maxSalary,
        media,
      ];

  toMap() {}
}

class JobMedia extends Equatable {
  final String mediaPath;
  final String mediaType;

  const JobMedia({
    required this.mediaPath,
    required this.mediaType,
  });

  factory JobMedia.fromMap(Map<String, dynamic> map) {
    return JobMedia(
      mediaPath: map['media_path'] ?? '',
      mediaType: map['media_type'] ?? '',
    );
  }

  @override
  List<Object?> get props => [mediaPath, mediaType];
} 