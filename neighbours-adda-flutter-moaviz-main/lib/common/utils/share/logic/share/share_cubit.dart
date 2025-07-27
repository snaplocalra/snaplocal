// ignore_for_file: use_build_context_synchronously

import 'package:designer/widgets/show_snak_bar.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snap_local/common/utils/share/repository/value_compressor_repository.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';

part 'share_state.dart';

class ShareCubit extends Cubit<ShareState> {
  ShareCubit() : super(const ShareState());

  //Encrypting the data and sharing the link
  Future<String> _processEncryptingLink(
    BuildContext context, {
    required String jsonData,
    required String screenURL,
  }) async {
    try {
      //Encrypting the data
      final compressedData =
          await ValueCompressorRepository().compressValue(jsonData);
      //Encode the encrypted data to url component to avoid restriction of special characters. ex: +, / , = , etc
      final encryptedDataUrl = Uri.encodeComponent(compressedData);
      //Share url
      return "$deepLinkURL/$screenURL?id=$encryptedDataUrl";

      //Stop the loading state
    } catch (e) {
      rethrow;
    }
  }

  //General Sharing
  Future<String> _processGeneralLink(
    BuildContext context, {
    required String jsonData,
    required String screenURL,
  }) async {
    try {
      return "$deepLinkURL/$screenURL/?id=$jsonData";
    } catch (e) {
      rethrow;
    }
  }

  //Encryption Sharing
  Future<void> encryptionShare(
    BuildContext context, {
    required String jsonData,
    required String screenURL,
    required String shareSubject,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));

      final shareUrl = await _processEncryptingLink(
        context,
        jsonData: jsonData,
        screenURL: screenURL,
      );

      final RenderBox box = context.findRenderObject() as RenderBox;
      await Share.share(
        shareUrl,
        subject: shareSubject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );

      emit(state.copyWith(requestLoading: false));
    } catch (e) {
      emit(state.copyWith(requestLoading: false));
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ShowSnackBar.showSnackBar(
        context,
        "Error occured while sharing the post!",
        backGroundColor: Colors.red,
      );
    }
  }

  //General Sharing
  Future<void> generalShare(
    BuildContext context, {
    required String data,
    required String screenURL,
    required String shareSubject,
  }) async {
    try {
      emit(state.copyWith(requestLoading: true));

      final shareUrl = await _processGeneralLink(
        context,
        jsonData: data,
        screenURL: screenURL,
      );

      final RenderBox box = context.findRenderObject() as RenderBox;
      await Share.share(
        shareUrl,
        subject: shareSubject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
      emit(state.copyWith(requestLoading: false));
    } catch (e) {
      emit(state.copyWith(requestLoading: false));
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ShowSnackBar.showSnackBar(
        context,
        "Error occured while sharing!",
        backGroundColor: Colors.red,
      );
    }
  }

//Share on whatsapp, accept a bool param to check if the message is encrypted
  Future<void> shareOnWhatsApp(
    BuildContext context, {
    required String jsonData,
    required String screenURL,
    bool isEncrypted = false,
  }) async {
    try {
      final shareUrl = isEncrypted
          ? await _processEncryptingLink(context,
              jsonData: jsonData, screenURL: screenURL)
          : await _processGeneralLink(context,
              jsonData: jsonData, screenURL: screenURL);
      await UrlLauncher().shareOnWhatsApp(shareUrl);
    } catch (e) {
      ShowSnackBar.showSnackBar(
        context,
        "Error occured while sharing!",
        backGroundColor: Colors.red,
      );
    }
  }
}
