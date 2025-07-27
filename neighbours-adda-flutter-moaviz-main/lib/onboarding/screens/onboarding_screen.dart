import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/onboarding/logic/on_boarding/on_boarding_cubit.dart';
import 'package:snap_local/onboarding/repository/on_boarding_repository.dart';
import 'package:snap_local/onboarding/widgets/onboarding_widget.dart';
import 'package:snap_local/utility/localization/widget/localization_builder.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = 'onboarding_screen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnBoardingCubit onBoardingCubit;

  @override
  void initState() {
    super.initState();
    onBoardingCubit = OnBoardingCubit(OnBoardingRepository());
    onBoardingCubit.fetchOnboardingScreenDetails();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageChangeBuilder(
      builder: (context, _) {
        return BlocProvider.value(
          value: onBoardingCubit,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
                listener: (context, state) {
                  if (state is OnBoardingDetailsFetched) {
                    //If the onboarding screens empty then skip the onboarding screens
                    if (state.onBoardingScreens.isEmpty) {
                      context.read<AuthenticationBloc>().add(OpenAuth());
                    }
                  }
                },
                builder: (context, state) {
                  if (state is OnBoardingDetailsFetched) {
                    return OnboardingWidget(
                      onBoardingModel: state.onBoardingScreens,
                      skipClicked: () async {
                        context.read<AuthenticationBloc>().add(OpenAuth());
                        // GoRouter.of(context)
                        //     .pushNamed(ChooseLanguageScreen.routeName);
                      },
                      getStartedClicked: () async {
                        context.read<AuthenticationBloc>().add(OpenAuth());
                      },
                    );
                  } else if (state is OnBoardingError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.error,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const ThemeSpinner();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
