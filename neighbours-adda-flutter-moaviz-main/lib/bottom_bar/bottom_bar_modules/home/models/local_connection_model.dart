import 'package:equatable/equatable.dart';

import '../../../../utility/constant/errors.dart';

class LocalConnectionResponse extends Equatable {
  final String status;
  final String message;
  final List<LocalConnectionModel> data;

  const LocalConnectionResponse({
    required this.status,
    required this.message,
    required this.data,
  });


  factory LocalConnectionResponse.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLocalConnection(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalConnection(map);
    }
  }

  static LocalConnectionResponse _buildLocalConnection(Map<String, dynamic> map) {
    return LocalConnectionResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      data: List<LocalConnectionModel>.from(
        (map['data'] ?? []).map((x) => LocalConnectionModel.fromMap(x)),
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

class LocalConnectionModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? mobile;
  final String image;
  final String gender;
  final String dob;
  final String bio;
  final List<Language> languages;
  final String profilePicturePrivacy;
  final String? badgeId;
  final String coverImage;
  final Location location;
  final LevelBadge levelBadge;
  final ComplimentBadge? complimentBadge;
  final ConnectionStatus connectionStatus;

  const LocalConnectionModel({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
    required this.image,
    required this.gender,
    required this.dob,
    required this.bio,
    required this.languages,
    required this.profilePicturePrivacy,
    this.badgeId,
    required this.coverImage,
    required this.location,
    required this.levelBadge,
    this.complimentBadge,
    required this.connectionStatus,
  });


  factory LocalConnectionModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildLocalConnectionModel(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildLocalConnectionModel(map);
    }
  }

  static LocalConnectionModel _buildLocalConnectionModel(Map<String, dynamic> map) {
    return LocalConnectionModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'],
      mobile: map['mobile'],
      image: map['image'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      bio: map['bio'] ?? '',
      languages: List<Language>.from(
        (map['languages'] ?? []).map((x) => Language.fromMap(x)),
      ),
      profilePicturePrivacy: map['profile_picture_privacy'] ?? '',
      badgeId: map['badge_id'],
      coverImage: map['cover_image'] ?? '',
      location: Location.fromMap(map['location'] ?? {}),
      levelBadge: LevelBadge.fromMap(map['level_badge'] ?? {}),
      complimentBadge: map['compliment_badge'] != null 
          ? ComplimentBadge.fromMap(map['compliment_badge'])
          : null,
      connectionStatus: ConnectionStatus.fromMap(map['connection_status'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'image': image,
      'gender': gender,
      'dob': dob,
      'bio': bio,
      'languages': languages.map((x) => x.toMap()).toList(),
      'profile_picture_privacy': profilePicturePrivacy,
      'badge_id': badgeId,
      'cover_image': coverImage,
      'location': location.toMap(),
      'level_badge': levelBadge.toMap(),
      'compliment_badge': complimentBadge?.toMap(),
      'connection_status': connectionStatus.toMap(),
    };
  }

  @override
  List<Object?> get props => [
    id, name, email, mobile, image, gender, dob, bio, languages,
    profilePicturePrivacy, badgeId, coverImage, location, levelBadge,
    complimentBadge, connectionStatus,
  ];
}

class Language extends Equatable {
  final String id;
  final String name;

  const Language({
    required this.id,
    required this.name,
  });

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

class Location extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      address: map['address'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [address, latitude, longitude];
}

class LevelBadge extends Equatable {
  final String image;
  final String points;
  final String type;

  const LevelBadge({
    required this.image,
    required this.points,
    required this.type,
  });

  factory LevelBadge.fromMap(Map<String, dynamic> map) {
    return LevelBadge(
      image: map['image'] ?? '',
      points: map['points'] ?? '',
      type: map['type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'points': points,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [image, points, type];
}

class ComplimentBadge extends Equatable {
  final String id;
  final String name;
  final String image;
  final int count;

  const ComplimentBadge({
    required this.id,
    required this.name,
    required this.image,
    required this.count,
  });

  factory ComplimentBadge.fromMap(Map<String, dynamic> map) {
    return ComplimentBadge(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      count: map['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'count': count,
    };
  }

  @override
  List<Object?> get props => [id, name, image, count];
}

class ConnectionStatus extends Equatable {
  final String? connectionId;
  final bool isConnectionRequestSender;
  final String connectionStatus;

  const ConnectionStatus({
    this.connectionId,
    required this.isConnectionRequestSender,
    required this.connectionStatus,
  });

  factory ConnectionStatus.fromMap(Map<String, dynamic> map) {
    return ConnectionStatus(
      connectionId: map['connection_id']?.toString(),
      isConnectionRequestSender: map['is_connection_request_sender'] ?? false,
      connectionStatus: map['connection_status'] ?? 'not_connected',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'connection_id': connectionId,
      'is_connection_request_sender': isConnectionRequestSender,
      'connection_status': connectionStatus,
    };
  }

  @override
  List<Object?> get props => [connectionId, isConnectionRequestSender, connectionStatus];
}