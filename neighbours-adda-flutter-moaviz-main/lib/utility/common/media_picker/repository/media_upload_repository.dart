import 'package:dio/dio.dart';
import 'package:snap_local/utility/api_manager/config/base_api.dart';
import 'package:snap_local/utility/api_manager/helper/isolate_api_call_internet_checker.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_response_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';

import '../../../constant/errors.dart';

class MediaUploadRepository extends BaseApi {
  // List<String> _imageurlNameExtractor(dynamic data) {
  //   return List<String>.from(data.map((imageJson) => imageJson['imageName']));
  // }

  Future<MediaUploadResponse> uploadMedia({
    required MediaUploadType mediaUploadType,
    required List<MediaFileModel> mediaList,
  }) async {
    return await makeIsolateApiCallWithInternetCheck(
      (_) {
        return _uploadMediaIsolate(
          mediaUploadType: mediaUploadType,
          mediaList: mediaList,
        ).then((imageList) => imageList);
      },
      (),
    );
  }

  Future<MediaUploadResponse> _uploadMediaIsolate({
    required MediaUploadType mediaUploadType,
    required List<MediaFileModel> mediaList,
  }) async {
    try {
      List<MultipartFile> formMediaFiles = [];
      List<MultipartFile> formThumbnailFiles = [];

      for (var mediaFile in mediaList) {
        final media = mediaFile is ImageFileMediaModel
            ? mediaFile.imageFile
            : mediaFile is VideoFileMediaModel
                ? mediaFile.videoFile
                : throw ("Unsupported media type");

        formMediaFiles.add(await MultipartFile.fromFile(media.path));

        // Add thumbnail for video files
        if (mediaFile is VideoFileMediaModel) {
          formThumbnailFiles.add(
            await MultipartFile.fromFile(mediaFile.thumbnailFile.path),
          );
        }
      }

      FormData data = FormData.fromMap({
        'file_list[]': formMediaFiles,
        'thumbnail_list[]': formThumbnailFiles,
        'type': mediaUploadType.path,
      });
      final dio = dioClient();
      return await dio.post('v2/file_upload', data: data).then((response) {
        if (response.data['status'] == "valid") {
          return MediaUploadResponse.fromMap(response.data);
        } else {
          throw (response.data['message']);
        }
      });
    } catch (e) {
      // Record the error in Firebase Crashlytics
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          throw (ErrorConstants.serverError);
        } else {
          throw ("Unable to upload");
        }
      } else {
        rethrow;
      }
    }
  }
}
