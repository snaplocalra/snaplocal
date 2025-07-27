import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/helpline_numbers/logic/helpline_controller/helpline_controller_cubit.dart';
import 'package:snap_local/common/utils/helpline_numbers/repository/help_line_number_repository.dart';
import 'package:snap_local/common/utils/helpline_numbers/widget/helpline_number_widget.dart';
import 'package:snap_local/utility/common/widgets/error_text_widget.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class HelplineNumbersScreen extends StatelessWidget {
  const HelplineNumbersScreen({super.key});

  static const routeName = 'helpline-numbers';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HelplineControllerCubit(HelpLineNumberRepository())
        ..getHelplineNumbers(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ThemeAppBar(
          appBarHeight: 70,
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Helpline Numbers',
                style: TextStyle(
                  color: ApplicationColours.themeBlueColor,
                  fontSize: 18,
                ),
              ),
              //description
              const Text(
                'For emergencies, ensure you contact the necessary service for help',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        body: BlocBuilder<HelplineControllerCubit, HelplineControllerState>(
          builder: (context, helplineControllerState) {
            if (helplineControllerState is HelplineControllerError) {
              return ErrorTextWidget(error: helplineControllerState.message);
            } else if (helplineControllerState is HelplineControllerLoaded) {
              final logs = helplineControllerState.helplineNumbers;
              if (logs.isEmpty) {
                return const ErrorTextWidget(error: 'No data found');
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: HelplineNumberWidget(
                        helplineNumber: logs[index],
                      ),
                    );
                  },
                );
              }
            } else {
              return const ThemeSpinner();
            }
          },
        ),
      ),
    );
  }
}
