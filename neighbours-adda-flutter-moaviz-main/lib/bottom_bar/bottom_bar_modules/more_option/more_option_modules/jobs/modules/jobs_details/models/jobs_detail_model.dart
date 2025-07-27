// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_short_details_model.dart';
import 'package:snap_local/common/market_places/models/post_owner_details.dart';
import 'package:snap_local/common/utils/category/v3/model/category_model_v3.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class JobDetailModel {
  final String id;
  final String companyName;
  final double jobPreferenceRadius;
  final String distance;
  final LocationAddressWithLatLng postLocation;
  final String jobDesignation;
  final double minWorkExperience;
  final double maxWorkExperience;
  final double minSalary;
  final double maxSalary;
  final String cityName;
  final CategoryModelV3 category;
  final int interestedPeopleCount;
  final LocationAddressWithLatLng workLocation;
  final bool enableChat;
  final List<String> skills;
  final String jobDescription;
  final DateTime createdAt;
  final bool isPostAdmin;
  final bool isSaved;
  final PostOwnerDetailsModel postOwnerDetails;
  final List<NetworkMediaModel> media;
  final List<JobShortDetailsModel> nearByRecommendation;
  final JobType jobType;
  final WorkType workType;
  final bool isInterested;
  final bool isPositionClosed;
  final bool reportedByUser;
  final int numberOfPositions;
  final String jobQualification;

  JobDetailModel({
    required this.id,
    required this.companyName,
    required this.distance,
    required this.workLocation,
    required this.jobPreferenceRadius,
    required this.postLocation,
    required this.jobDesignation,
    required this.maxWorkExperience,
    required this.minWorkExperience,
    required this.category,
    required this.skills,
    required this.interestedPeopleCount,
    required this.jobDescription,
    required this.createdAt,
    required this.isPostAdmin,
    required this.isSaved,
    required this.postOwnerDetails,
    required this.media,
    required this.nearByRecommendation,
    required this.jobType,
    required this.workType,
    required this.minSalary,
    required this.maxSalary,
    required this.cityName,
    required this.enableChat,
    required this.isInterested,
    required this.isPositionClosed,
    required this.reportedByUser,
    required this.numberOfPositions,
    required this.jobQualification,
  });

  factory JobDetailModel.fromJson(Map<String, dynamic> json) => JobDetailModel(
        id: json["id"],
        companyName: json["company_name"],
        jobPreferenceRadius:
            double.parse(json["job_preference_radius"].toString()),
        jobDesignation: json["job_designation"],
        jobType: JobType.fromValue(json["job_type"]),
        workType: WorkType.fromValue(json["work_type"]),
        skills: List<String>.from(json["must_have_skills"]),
        enableChat: json["enable_chat"] ?? false,
        cityName: json["city_name"],
        minWorkExperience: double.parse(json["min_work_experience"].toString()),
        maxWorkExperience: double.parse(json["max_work_experience"].toString()),
        minSalary: double.parse(json["min_salary"].toString()),
        maxSalary: double.parse(json["max_salary"].toString()),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
        category: CategoryModelV3.fromMap(json["category"]),
        isPostAdmin: json["is_post_admin"],
        isSaved: json["is_saved"],
        interestedPeopleCount: json["interested_people_count"] ?? 0,
        postLocation: LocationAddressWithLatLng.fromMap(json["post_location"]),
        jobDescription: json["job_description"],
        workLocation: LocationAddressWithLatLng.fromMap(json["work_location"]),
        postOwnerDetails: PostOwnerDetailsModel.fromJson(json["user_details"]),
        distance: json["distance"] ?? "N/A",
        media: List<NetworkMediaModel>.from(
          json["media"].map((x) => NetworkMediaModel.fromMap(x)),
        ),
        nearByRecommendation: List<JobShortDetailsModel>.from(
          json["nearby_list"].map((x) => JobShortDetailsModel.fromMap(x)),
        ),
        isInterested: json["job_applied"] ?? false,
        isPositionClosed: json["job_is_closed"] ?? false,
        reportedByUser: json["reported_by_user"] ?? false,
        numberOfPositions: json["number_of_positions"] ?? 0,
        jobQualification: json["job_qualification"] ?? "",
      );

  //Copy with
  JobDetailModel copyWith({
    String? id,
    String? companyName,
    double? jobPreferenceRadius,
    String? distance,
    LocationAddressWithLatLng? postLocation,
    String? jobDesignation,
    double? minWorkExperience,
    double? maxWorkExperience,
    double? minSalary,
    double? maxSalary,
    String? cityName,
    CategoryModelV3? category,
    LocationAddressWithLatLng? workLocation,
    bool? enableChat,
    int? interestedPeopleCount,
    List<String>? skills,
    String? jobDescription,
    DateTime? createdAt,
    bool? isPostAdmin,
    bool? isSaved,
    PostOwnerDetailsModel? postOwnerDetails,
    List<NetworkMediaModel>? media,
    List<JobShortDetailsModel>? nearByRecommendation,
    JobType? jobType,
    WorkType? workType,
    bool? isInterested,
    bool? isPositionClosed,
    bool? reportedByUser,
    int? numberOfPositions,
    String? jobQualification,
  }) {
    return JobDetailModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobPreferenceRadius: jobPreferenceRadius ?? this.jobPreferenceRadius,
      distance: distance ?? this.distance,
      postLocation: postLocation ?? this.postLocation,
      jobDesignation: jobDesignation ?? this.jobDesignation,
      minWorkExperience: minWorkExperience ?? this.minWorkExperience,
      maxWorkExperience: maxWorkExperience ?? this.maxWorkExperience,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      interestedPeopleCount:
          interestedPeopleCount ?? this.interestedPeopleCount,
      cityName: cityName ?? this.cityName,
      category: category ?? this.category,
      workLocation: workLocation ?? this.workLocation,
      enableChat: enableChat ?? this.enableChat,
      skills: skills ?? this.skills,
      jobDescription: jobDescription ?? this.jobDescription,
      createdAt: createdAt ?? this.createdAt,
      isPostAdmin: isPostAdmin ?? this.isPostAdmin,
      isSaved: isSaved ?? this.isSaved,
      postOwnerDetails: postOwnerDetails ?? this.postOwnerDetails,
      media: media ?? this.media,
      nearByRecommendation: nearByRecommendation ?? this.nearByRecommendation,
      jobType: jobType ?? this.jobType,
      workType: workType ?? this.workType,
      isInterested: isInterested ?? this.isInterested,
      isPositionClosed: isPositionClosed ?? this.isPositionClosed,
      reportedByUser: reportedByUser ?? this.reportedByUser,
      numberOfPositions: numberOfPositions ?? this.numberOfPositions,
      jobQualification: jobQualification ?? this.jobQualification,
    );
  }
}

enum JobType {
  fullTime(value: 'full_time', displayValue: LocaleKeys.fullTime),
  contract(value: 'contract', displayValue: LocaleKeys.contract),
  freelance(value: 'freelance', displayValue: LocaleKeys.freelance);

  final String value;
  final String displayValue;
  const JobType({
    required this.value,
    required this.displayValue,
  });

  factory JobType.fromValue(String value) {
    switch (value) {
      case 'full_time':
        return fullTime;
      case 'contract':
        return contract;
      case 'freelance':
        return freelance;
      default:
        throw Exception('Invalid job type value: $value');
    }
  }
}

enum WorkType {
  remote(value: 'remote', displayValue: LocaleKeys.remote),
  hybrid(value: 'hybrid', displayValue: LocaleKeys.hybrid),
  wfo(value: 'wfo', displayValue: LocaleKeys.wfo);

  final String value;
  final String displayValue;
  const WorkType({
    required this.value,
    required this.displayValue,
  });

  factory WorkType.fromValue(String value) {
    switch (value) {
      case 'remote':
        return remote;
      case 'hybrid':
        return hybrid;
      case 'wfo':
        return wfo;
      default:
        throw Exception('Invalid work type value: $value');
    }
  }
}
