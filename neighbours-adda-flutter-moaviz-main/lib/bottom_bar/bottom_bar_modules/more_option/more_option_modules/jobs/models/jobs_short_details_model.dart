// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';

import '../../../../../../utility/constant/errors.dart';

class JobsDataModel {
  final JobsListModel jobsByNeighbours;
  final JobsListModel jobsByYou;
  JobsDataModel({
    required this.jobsByNeighbours,
    required this.jobsByYou,
  });
  bool get isEmpty => jobsByNeighbours.data.isEmpty || jobsByYou.data.isEmpty;

  bool get isBothListEmpty =>
      jobsByNeighbours.data.isEmpty && jobsByYou.data.isEmpty;

  JobsDataModel copyWith({
    JobsListModel? jobsByNeighbours,
    JobsListModel? jobsByYou,
  }) {
    return JobsDataModel(
      jobsByNeighbours: jobsByNeighbours ?? this.jobsByNeighbours,
      jobsByYou: jobsByYou ?? this.jobsByYou,
    );
  }
}

class JobsListModel {
  final List<JobShortDetailsModel> data;
  PaginationModel paginationModel;

  JobsListModel({
    required this.data,
    required this.paginationModel,
  });

  factory JobsListModel.emptyModel() =>
      JobsListModel(data: [], paginationModel: PaginationModel.initial());
  factory JobsListModel.fromJson(Map<String, dynamic> json) => JobsListModel(
        data: List<JobShortDetailsModel>.from(
            json["data"].map((x) => JobShortDetailsModel.fromMap(x))),
        paginationModel: PaginationModel.fromMap(json),
      );

  //Use for pagination
  JobsListModel paginationCopyWith({required JobsListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return JobsListModel(data: data, paginationModel: paginationModel);
  }
}

class JobShortDetailsModel {
  final String id;
  final String companyName;
  final int jobPreferenceRadius;
  final String address;
  final String jobDesignation;
  final double minWorkExperience;
  final double maxWorkExperience;
  final double minSalary;
  final double maxSalary;
  final LocationAddressWithLatLng workLocation;
  final String totalView;
  final bool isPostAdmin;
  final bool isSaved;
  final List<String> mustHaveSkills;
  final List<NetworkMediaModel> media;
  final bool isJobApplied;
  final bool isPositionClosed;

  JobShortDetailsModel({
    required this.id,
    required this.companyName,
    required this.jobPreferenceRadius,
    required this.address,
    required this.jobDesignation,
    required this.minWorkExperience,
    required this.maxWorkExperience,
    required this.minSalary,
    required this.maxSalary,
    required this.workLocation,
    required this.totalView,
    required this.mustHaveSkills,
    required this.isPostAdmin,
    required this.isSaved,
    required this.media,
    required this.isJobApplied,
    required this.isPositionClosed,
  });

  factory JobShortDetailsModel.fromMap(Map<String, dynamic> json) {
    if (isDebug) {
      try {
        return _buildJobShortDetails(json);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildJobShortDetails(json);
    }
  }

  static JobShortDetailsModel _buildJobShortDetails(Map<String, dynamic> json) =>
      JobShortDetailsModel(
        id: json["id"],
        companyName: json["company_name"],
        jobPreferenceRadius: json["job_preference_radius"],
        address: json["address"],
        jobDesignation: json["job_designation"],
        minWorkExperience: double.parse(json["min_work_experience"].toString()),
        maxWorkExperience: double.parse(json["max_work_experience"].toString()),
        minSalary: double.parse(json["min_salary"].toString()),
        maxSalary: double.parse(json["max_salary"].toString()),
        workLocation: LocationAddressWithLatLng.fromMap(json["work_location"]),
        totalView: json["total_view"],
        isSaved: json["is_saved"],
        isPostAdmin: json["is_post_admin"],
        mustHaveSkills:
            List<String>.from(json["must_have_skills"].map((x) => x)),
        media: List<NetworkMediaModel>.from(
            json["media"].map((x) => NetworkMediaModel.fromMap(x))),
        isJobApplied: json["job_applied"] ?? false,
        isPositionClosed: json["job_is_closed"] ?? false,
      );

  //Use to push data to firebase firestore for other chat communication
  Map<String, dynamic> toFirebaseMap() => {
        "id": id,
        "company_name": companyName,
        "address": address,
        "job_designation": jobDesignation,
        "min_job_experience": minWorkExperience,
        "max_job_experience": maxWorkExperience,
        "must_have_skills": mustHaveSkills.map((x) => x).toList(),
        "media": media.map((x) => x.toMap()).toList(),
      };

  JobShortDetailsModel copyWith({
    String? id,
    String? companyName,
    int? jobPreferenceRadius,
    String? address,
    String? jobDesignation,
    double? minWorkExperience,
    double? maxWorkExperience,
    double? minSalary,
    double? maxSalary,
    LocationAddressWithLatLng? workLocation,
    String? totalView,
    bool? isPostAdmin,
    bool? isSaved,
    List<String>? mustHaveSkills,
    List<NetworkMediaModel>? media,
    bool? isJobApplied,
    bool? isPositionClosed,
  }) {
    return JobShortDetailsModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobPreferenceRadius: jobPreferenceRadius ?? this.jobPreferenceRadius,
      address: address ?? this.address,
      jobDesignation: jobDesignation ?? this.jobDesignation,
      minWorkExperience: minWorkExperience ?? this.minWorkExperience,
      maxWorkExperience: maxWorkExperience ?? this.maxWorkExperience,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      workLocation: workLocation ?? this.workLocation,
      totalView: totalView ?? this.totalView,
      isPostAdmin: isPostAdmin ?? this.isPostAdmin,
      isSaved: isSaved ?? this.isSaved,
      mustHaveSkills: mustHaveSkills ?? this.mustHaveSkills,
      media: media ?? this.media,
      isJobApplied: isJobApplied ?? this.isJobApplied,
      isPositionClosed: isPositionClosed ?? this.isPositionClosed,
    );
  }

  //search keyword:
  /// Returns true if the search query matches the job designation, company name, must have skills.
  /// If the search query is null, it returns true.
  bool searchKeyword(String? searchQuery) {
    if (searchQuery == null) {
      return true;
    }

    final lowerCaseSearchQuery = searchQuery.toLowerCase();

    return jobDesignation.toLowerCase().contains(lowerCaseSearchQuery) ||
        companyName.toLowerCase().contains(lowerCaseSearchQuery) ||
        //check for must have skills
        mustHaveSkills.any(
            (element) => element.toLowerCase().contains(lowerCaseSearchQuery));
  }
}
