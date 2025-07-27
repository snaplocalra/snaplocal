// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:snap_local/common/social_media/post/modules/social_post_reaction/model/reaction_emoji_model.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class CommentListModel {
  List<CommentModel> data;
  PaginationModel paginationModel;
  CommentListModel({
    this.data = const [],
    required this.paginationModel,
  });

  factory CommentListModel.emptyModel() =>
      CommentListModel(data: [], paginationModel: PaginationModel.initial());

  //Use for pagination
  CommentListModel paginationCopyWith({required CommentListModel newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;

    return CommentListModel(
      data: data,
      paginationModel: paginationModel,
    );
  }

  factory CommentListModel.fromMap(Map<String, dynamic> map) {
    return CommentListModel(
      data: List<CommentModel>.from(
        map['data'].map<CommentModel>(
          (x) => CommentModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      paginationModel: PaginationModel.fromMap(map),
    );
  }

  CommentListModel copyWith({
    List<CommentModel>? data,
    PaginationModel? paginationModel,
  }) {
    return CommentListModel(
      data: data ?? this.data,
      paginationModel: paginationModel ?? this.paginationModel,
    );
  }
}

class CommentModel {
  final String id;
  final String comment;
  final bool isOwnComment;
  final bool allowDelete;
  final bool allowEdit;
  final bool editedComment;
  final DateTime createdTime;
  final CommentedByUserDetails commentedByUserDetails;
  final List<CommentModel>? reply;
  ReactionEmojiModel? reactionEmojiModel;

  CommentModel({
    required this.id,
    required this.comment,
    required this.isOwnComment,
    required this.allowDelete,
    required this.allowEdit,
    required this.editedComment,
    required this.createdTime,
    required this.commentedByUserDetails,
    this.reply,
    this.reactionEmojiModel,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    final reactionEmojiModel = map["user_reaction"] == null
        ? null
        : ReactionEmojiModel.fromMap(map["user_reaction"]);
    return CommentModel(
      id: map['id'],
      comment: map['comment'],
      isOwnComment: map['is_own_comment'],
      allowDelete: map['allow_delete'],
      allowEdit: map['allow_edit'],
      editedComment: map['comment_edited'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(map['created_time']),
      commentedByUserDetails: CommentedByUserDetails.fromMap(
          map['commented_by_user_details'] as Map<String, dynamic>),
      reply: map['reply'] != null
          ? List<CommentModel>.from(map['reply'].map<CommentModel?>(
              (x) => CommentModel.fromMap(x as Map<String, dynamic>)))
          : null,
      reactionEmojiModel: reactionEmojiModel,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'comment': comment,
  //     'is_own_comment': isOwnComment,
  //     'created_time': createdTime.millisecondsSinceEpoch,
  //     'commented_by_user_details': commentedByUserDetails.toMap(),
  //     "user_reaction": reactionEmojiModel?.toMap(),
  //     'reply': reply?.map((x) => x.toMap()).toList(),
  //   };
  // }

  CommentModel copyWith({
    String? id,
    String? comment,
    bool? isOwnComment,
    bool? allowDelete,
    bool? allowEdit,
    bool? editedComment,
    DateTime? createdTime,
    CommentedByUserDetails? commentedByUserDetails,
    List<CommentModel>? reply,
    ReactionEmojiModel? reactionEmojiModel,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      isOwnComment: isOwnComment ?? this.isOwnComment,
      allowDelete: allowDelete ?? this.allowDelete,
      allowEdit: allowEdit ?? this.allowEdit,
      editedComment: editedComment ?? this.editedComment,
      createdTime: createdTime ?? this.createdTime,
      commentedByUserDetails:
          commentedByUserDetails ?? this.commentedByUserDetails,
      reply: reply ?? this.reply,
      reactionEmojiModel: reactionEmojiModel ?? this.reactionEmojiModel,
    );
  }
}

class CommentedByUserDetails {
  final String id;
  final String name;
  final String image;
  final String address;

  CommentedByUserDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
  });

  factory CommentedByUserDetails.fromMap(Map<String, dynamic> map) {
    return CommentedByUserDetails(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'address': address,
    };
  }
}
