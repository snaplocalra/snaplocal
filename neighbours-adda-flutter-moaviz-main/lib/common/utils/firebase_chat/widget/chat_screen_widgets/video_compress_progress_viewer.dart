import 'package:designer/widgets/theme_spinner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/common/data_upload_status/data_upload_status_cubit.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:video_compress/video_compress.dart';

class VideoCompressProgressViewer extends StatefulWidget {
  const VideoCompressProgressViewer({super.key});

  @override
  State<VideoCompressProgressViewer> createState() =>
      _VideoCompressProgressViewerState();
}

class _VideoCompressProgressViewerState
    extends State<VideoCompressProgressViewer> {
  late Subscription _videoProgressSubscription;

  final dataUploadStatusCubit = DataUploadStatusCubit();

  @override
  void initState() {
    super.initState();
    _videoProgressSubscription =
        VideoCompress.compressProgress$.subscribe((progress) {
      dataUploadStatusCubit.showProgress(
          progrssValue: progress, message: "Preparing video...");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoProgressSubscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
      },
      child: BlocBuilder<DataUploadStatusCubit, DataUploadStatusState>(
        bloc: dataUploadStatusCubit,
        builder: (context, dataUploadStatusState) {
          if (dataUploadStatusState.dataUploadStatus ==
              DataUploadStatus.uploading) {
            final waitingText =
                "${dataUploadStatusState.message} ${dataUploadStatusState.progressValue?.toStringAsFixed(2)}%";

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ThemeSpinner(),
                  const SizedBox(height: 5),
                  Text(
                    waitingText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      await VideoCompress.cancelCompression().whenComplete(() {
                        dataUploadStatusCubit.stop();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text(
                      tr(LocaleKeys.cancel),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
