import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_elevated_button.dart';
import 'package:designer/widgets/theme_spinner.dart';
import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/profile/profile_settings/logic/remove_account/remove_account_cubit.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class RemoveAccountDialog extends StatefulWidget {
  const RemoveAccountDialog({super.key});

  @override
  State<RemoveAccountDialog> createState() => _RemoveAccountDialogState();
}

class _RemoveAccountDialogState extends State<RemoveAccountDialog> {
  final reasonTextController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    reasonTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr(LocaleKeys.removeAccountConfirmation),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromRGBO(
                119,
                114,
                114,
                1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ThemeTextFormField(
              controller: reasonTextController,
              maxLines: 4,
              fillColor: const Color.fromRGBO(
                242,
                242,
                242,
                1,
              ),
              contentPadding: const EdgeInsets.all(10),
              style: const TextStyle(fontSize: 12),
              hint: tr(LocaleKeys.removeAccountRemoveHint),
              textCapitalization: TextCapitalization.sentences,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(119, 114, 114, 0.5),
              ),
            ),
          ),
          BlocBuilder<RemoveAccountCubit, RemoveAccountState>(
            builder: (context, removeAccountState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: removeAccountState.sendOTPLoading
                    ? const ThemeSpinner(size: 40)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ThemeElevatedButton(
                            buttonName: tr(LocaleKeys.no),
                            onPressed: () => GoRouter.of(context).pop(),
                            height: mqSize.height * 0.045,
                            width: mqSize.width * 0.28,
                            textFontSize: 12,
                            backgroundColor: ApplicationColours.themeBlueColor,
                            padding: EdgeInsets.zero,
                          ),
                          SizedBox(width: mqSize.width * 0.05),
                          ThemeElevatedButton(
                            buttonName: tr(LocaleKeys.yes),
                            onPressed: () {
                              final reason = reasonTextController.text.trim();
                              FocusScope.of(context).unfocus();
                              if (!removeAccountState.isLoading) {
                                context
                                    .read<RemoveAccountCubit>()
                                    .removeAccount(removeReason: reason);
                              }
                            },
                            height: mqSize.height * 0.045,
                            width: mqSize.width * 0.28,
                            textFontSize: 12,
                            backgroundColor: ApplicationColours.themePinkColor,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
              );
            },
          )
        ],
      ),
    );
  }
}
