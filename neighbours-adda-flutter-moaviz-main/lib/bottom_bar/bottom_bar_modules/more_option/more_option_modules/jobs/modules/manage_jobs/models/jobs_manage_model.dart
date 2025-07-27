import 'dart:convert';

import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';
import 'package:snap_local/common/utils/category/v3/model/category_model_v3.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

class JobManageModel {
  final String? id;
  final CategoryModelV3 category;
  final String companyName;
  final String jobDesignation;
  final String jobDescription;
  final double minWorkExperience;
  final double maxWorkExperience;
  final double minSalary;
  final double maxSalary;
  final String cityName;
  final JobType jobType;
  final WorkType workType;
  final List<String> musHaveSkills;
  final double jobPreferenceRadius;
  final LocationAddressWithLatLng workLocation;
  final LocationAddressWithLatLng postLocation;
  final List<NetworkMediaModel> media;
  final bool enableChat;
  final int? numberOfPositions;
  final String jobQualification;

  JobManageModel({
    this.id,
    required this.category,
    required this.companyName,
    required this.jobDesignation,
    required this.jobDescription,
    required this.minWorkExperience,
    required this.maxWorkExperience,
    required this.minSalary,
    required this.maxSalary,
    required this.cityName,
    required this.jobType,
    required this.workType,
    required this.musHaveSkills,
    required this.jobPreferenceRadius,
    required this.workLocation,
    required this.postLocation,
    required this.media,
    required this.enableChat,
    required this.numberOfPositions,
    required this.jobQualification,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category.toJson(),
      'company_name': companyName,
      'job_designation': jobDesignation,
      'job_description': jobDescription,
      'min_work_experience': minWorkExperience,
      'max_work_experience': maxWorkExperience,
      'min_salary': minSalary,
      'max_salary': maxSalary,
      'city_name': cityName,
      'job_type': jobType.value,
      'work_type': workType.value,
      'enable_chat': enableChat,
      'number_of_positions': numberOfPositions,
      'job_qualification': jobQualification,
      'job_preference_radius': jobPreferenceRadius,
      'work_location': workLocation.toJson(),
      'post_location': postLocation.toJson(),
      'must_have_skills': jsonEncode(musHaveSkills),
      'media': jsonEncode(media.map((x) => x.toMap()).toList()),
    };
  }
}
