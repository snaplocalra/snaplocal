// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';

class LanguageChangeBuilder extends StatelessWidget {
  final Widget Function(BuildContext, LanguageChangeControllerState) builder;
  const LanguageChangeBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageChangeControllerCubit,
        LanguageChangeControllerState>(builder: builder);
  }
}
