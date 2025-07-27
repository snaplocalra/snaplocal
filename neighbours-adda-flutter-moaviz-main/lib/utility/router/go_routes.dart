import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/authentication/models/signup_screen_payload.dart';
import 'package:snap_local/authentication/screens/choose_authentication_method_screen.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/change_password_screen.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/forgot_password_screen.dart.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/signup_screen.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/standard_login_screen.dart';
import 'package:snap_local/authentication/screens/standard_authentication_screens/verify_otp_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/models/business_view_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/screen/create_or_update_business_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/models/business_details_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/view_business/screen/business_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/screens/business_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/explore/screen/explore_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/models/group_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/models/group_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/screen/manage_group_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/logic/private_group_join_requests/private_group_join_requests_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/screens/private_group_join_request_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/screen/group_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/screen/create_or_update_group_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/group_chat_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/group_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/group_see_all_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/screens/search_group_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/model/favorite_location_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/screen/favorite_location_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/screens/home_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/models/sales_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/manage_sale_post/screen/manage_sales_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/models/sales_post_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/modules/sales_post_details/screen/sales_post_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/buy_sell/screens/buy_sell_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/model/feed_post_category_type_enum.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/category_wise_feed_post/screen/category_wise_feed_posts_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/create_event/screen/manage_event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/screen/event_attending_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_details/screen/event_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/models/event_post_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/screens/event_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/common/screen/hall_of_fame_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/interested_languages/interested_languages_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/logic/interested_topics/interested_topics_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/screen/interested_language_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/hall_of_fame/contests/screen/interested_topics_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/help_and_support/screen/help_and_support_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/logic/job_short_view_controller/job_short_view_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/models/jobs_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/models/jobs_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/jobs_details/screen/jobs_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/modules/manage_jobs/screen/manage_jobs_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/jobs/screens/jobs_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/models/page_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/screen/create_or_update_page_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/models/page_detail_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/screen/manage_page_post_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/screen/page_details.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/page_seeall_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/screens/search_page_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/models/polls_list_type.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/modules/poll_manage/screens/manage_poll_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/screen/polls_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/saved_items/screen/saved_items_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/model/manage_news_channel_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/screen/create_news_channel_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/model/post_news_preview_screen_payload.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/screen/manage_post_news.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/screen/post_news_preview_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/screen/channel_overview_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/bank_details/screen/manage_bank_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/screens/my_wallet_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/screen/my_dashboard_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_post_details/screen/news_post_view_details_screen.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/screen/join_news_community.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/screen/news_list_screen.dart';
import 'package:snap_local/bottom_bar/screen/test_taturial.dart';
import 'package:snap_local/common/market_places/interested_people_list/screen/interested_people_list_screen.dart';
import 'package:snap_local/common/market_places/models/market_place_type.dart';
import 'package:snap_local/common/market_places/owner_activity_details/model/owner_activity_details_enum.dart';
import 'package:snap_local/common/market_places/owner_activity_details/screen/owner_acitvity_details_screen.dart';
import 'package:snap_local/common/review_module/model/review_type_enum.dart';
import 'package:snap_local/common/review_module/screen/review_ratings_details.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/lost_found_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/regular_post_screen.dart';
import 'package:snap_local/common/social_media/create/create_social_post/screen/safety_alerts_post_screen.dart';
import 'package:snap_local/common/social_media/post/carousel_view/screen/carousel_view_screen.dart';
import 'package:snap_local/common/social_media/post/master_post/model/post_type_enum.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/give_reaction/give_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/logic/show_reaction/show_reaction_cubit.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/repository/emoji_repository.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/comment_view_controller/comment_view_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/logic/post_details_controller/post_details_controller_cubit.dart';
import 'package:snap_local/common/social_media/post/post_details/screens/post_details_view_screen.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/model/share_post_data_model.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/screen/share_post_details_screen.dart';
import 'package:snap_local/common/social_media/post/video_feed/repository/video_data_repository.dart';
import 'package:snap_local/common/utils/analytics/model/analytics_module_type.dart';
import 'package:snap_local/common/utils/analytics/screen/analytics_overview_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/model/other_communication_type/other_communication_model.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_contacts_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/chat_screen.dart';
import 'package:snap_local/common/utils/follower_list/model/follower_list_impl.dart';
import 'package:snap_local/common/utils/follower_list/screen/follower_list_screen.dart';
import 'package:snap_local/common/utils/helpline_numbers/screen/helpline_numbers_screen.dart';
import 'package:snap_local/common/utils/hide/logic/hide_post/hide_post_cubit.dart';
import 'package:snap_local/common/utils/hide/repository/hide_post_repository.dart';
import 'package:snap_local/common/utils/introduction/screen/introduction_screen.dart';
import 'package:snap_local/common/utils/local_notification/screen/local_notification_screen.dart';
import 'package:snap_local/common/utils/location/model/location_address_with_latlong.dart';
import 'package:snap_local/common/utils/location/model/location_manage_type_enum.dart';
import 'package:snap_local/common/utils/location/model/location_type_enum.dart';
import 'package:snap_local/common/utils/location/screens/location_manage_map_screen.dart';
import 'package:snap_local/common/utils/location/screens/search_location_screen.dart';
import 'package:snap_local/common/utils/location/screens/tag_location_screen.dart';
import 'package:snap_local/common/utils/post_action/logic/post_action/post_action_cubit.dart';
import 'package:snap_local/common/utils/post_action/repository/post_action_repository.dart';
import 'package:snap_local/common/utils/report/logic/report/report_cubit.dart';
import 'package:snap_local/common/utils/report/model/report_screen_payload.dart';
import 'package:snap_local/common/utils/report/repository/report_repository.dart';
import 'package:snap_local/common/utils/report/screen/report_screen.dart';
import 'package:snap_local/home_route.dart';
import 'package:snap_local/onboarding/screens/onboarding_screen.dart';
import 'package:snap_local/profile/connections/logic/profile_connection_action/profile_connection_action_cubit.dart';
import 'package:snap_local/profile/connections/screens/profile_connections_screen.dart';
import 'package:snap_local/profile/manage_profile_details/screens/edit_profile_screen.dart';
import 'package:snap_local/profile/profile_details/neighbours_profile/screen/neigbours_profile_screen.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/refer_earn/screen/refer_earn_screen.dart';
import 'package:snap_local/profile/profile_details/own_profile/screen/own_profile_screen.dart';
import 'package:snap_local/profile/profile_privacy/screens/profile_privacy_screen.dart';
import 'package:snap_local/profile/profile_settings/modules/reset_password/screen/reset_password_screen.dart.dart';
import 'package:snap_local/profile/profile_settings/screens/profile_settings_screen.dart';
import 'package:snap_local/profile/profile_settings/screens/settings_menu_screen.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/extension_functions/string_converter.dart';
import 'package:snap_local/utility/localization/screen/choose_language_screen.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/media_player/video/video_player_screen.dart';
import 'package:snap_local/utility/router/animated_page_route.dart';
import 'package:snap_local/common/utils/firebase_chat/screen/report_local_chat_spam_user_screen.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/report_local_chat_spam/report_local_chat_spam_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/report_local_chat_spam_repository.dart';

import '../../common/social_media/post/video_feed/logic/video_feed_posts/video_feed_posts_cubit.dart';
import '../../common/social_media/post/video_feed/screens/video_screen.dart';
import '../../common/utils/follower_list/screen/influencer_follower_list_screen.dart';

class GoRouterManager {
  /// The route configuration.
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  //Link auth checker
  static FutureOr<String?> checkAuthAndRedirect(
      BuildContext context, GoRouterState state) {
    // Access the AuthenticationBloc here
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final authState = authBloc.state;

    if (authState is AuthenticationAuthenticated) {
      //If id is null then go to home screen
      //Id is use to carry the share link data
      if (state.uri.queryParameters['id'] == null) {
        //Go to home screen
        return "/";
      } else {
        //Go to share post details screen
        return null;
      }
    } else {
      return "/${ChooseAuthenticationMethodScreen.routeName}";
    }
  }

  GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: "/",
    //extraCodec: const ScreenPayloadCodec(),
    routes: <RouteBase>[
      //Onboarding
      GoRoute(
        name: OnboardingScreen.routeName,
        path: "/${OnboardingScreen.routeName}",
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),

      //Authentication
      GoRoute(
        name: ChooseAuthenticationMethodScreen.routeName,
        path: "/${ChooseAuthenticationMethodScreen.routeName}",
        builder: (BuildContext context, GoRouterState state) {
          return const ChooseAuthenticationMethodScreen();
        },
        routes: [
          //Signup
          GoRoute(
            name: SignupScreen.routeName,
            path: SignupScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return SignupScreen(
                payLoad: state.extra as SignupScreenPayload,
              );
            },
          ),

          //Login
          GoRoute(
            name: LoginScreen.routeName,
            path: LoginScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen(
                userName: state.uri.queryParameters['username']!,
                userDisplayName:
                    state.uri.queryParameters['user_display_name']!,
              );
            },
            routes: [
              //ForgotPassword
              GoRoute(
                name: ForgotPasswordScreen.routeName,
                path: ForgotPasswordScreen.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  return ForgotPasswordScreen(
                    preSelectedUserName: state.uri.queryParameters['username']!,
                  );
                },
              ),

              //ChangePassword
              GoRoute(
                name: ChangePasswordScreen.routeName,
                path: ChangePasswordScreen.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  return ChangePasswordScreen(
                    userName: state.uri.queryParameters['username']!,
                  );
                },
              ),

              //VerifyOTP
              GoRoute(
                name: VerifyOTPScreen.routeName,
                path: VerifyOTPScreen.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  final isForgotPassword =
                      state.uri.queryParameters['is_forgot_password'];

                  return VerifyOTPScreen(
                    userName: state.uri.queryParameters['username']!,
                    isForgetPassword: isForgotPassword == null
                        ? false
                        : isForgotPassword.toBool(),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/video',
        name: 'video', // <- THIS must match VideoScreen.routeName
        builder: (context, state) => BlocProvider(
          create: (_) => VideoSocialPostsCubit(VideoDataRepository()),
          child: VideoScreen(index: state.extra as int?,),
        ),
      ),


      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        name: "/",
        path: "/",
        builder: (context, state) => const HomeRoute(),
        routes: [
          // CarouselViewScreen
          GoRoute(
            name: CarouselViewScreen.routeName,
            path: CarouselViewScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final mediaList = state.extra as List<NetworkMediaModel>;
              final selectedMediaIndex = int.tryParse(
                  state.uri.queryParameters['selected_media_index']!);

              return animatedPageRoute(
                pageKey: state.pageKey,
                child: CarouselViewScreen(
                  mediaList: mediaList,
                  selectedMediaIndex: selectedMediaIndex ?? 0,
                ),
              );
            },
          ),
          //Home
          GoRoute(
            name: HomeScreen.routeName,
            path: HomeScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
            routes: [
              GoRoute(
                name: FavoriteLocationScreen.routeName,
                path: FavoriteLocationScreen.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  return const FavoriteLocationScreen();
                },
              ),
              GoRoute(
                name: ChooseLanguageScreen.routeName,
                path: ChooseLanguageScreen.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  return const ChooseLanguageScreen(allowPop: true);
                },
              ),
              GoRoute(
                name: IntroductionScreen.routeName,
                path: IntroductionScreen.routeName,
                builder: (BuildContext context, GoRouterState state) {
                  return const IntroductionScreen();
                },
              ),

              GoRoute(
                name: ExploreScreen.routeName,
                path: ExploreScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  navigationDirection: NavigationDirection.top,
                  pageKey: state.pageKey,
                  child: ExploreScreen(
                    isPushedRoute:
                        state.extra != null ? state.extra as bool : false,
                  ),
                ),
              ),

              GoRoute(
                name: RegularPostScreen.routeName,
                path: RegularPostScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final objMap = state.extra != null
                      ? state.extra as Map<String, dynamic>
                      : null;

                  PostType regularPostType = PostType.general;
                  PostDetailsControllerCubit? postDetailsControllerCubit;
                  if (objMap != null) {
                    postDetailsControllerCubit =
                        objMap['postDetailsControllerCubit'] == null
                            ? null
                            : objMap['postDetailsControllerCubit']
                                as PostDetailsControllerCubit;
                    regularPostType = objMap['postType'] as PostType;

                    postDetailsControllerCubit =
                        objMap['postDetailsControllerCubit'] == null
                            ? null
                            : objMap['postDetailsControllerCubit']
                                as PostDetailsControllerCubit;
                  }

                  return animatedPageRoute(
                    navigationDirection: NavigationDirection.bottom,
                    pageKey: state.pageKey,
                    child: RegularPostScreen(
                      postDetailsControllerCubit: postDetailsControllerCubit,
                      regularPostType: regularPostType,
                    ),
                  );
                },
              ),

              GoRoute(
                name: LostFoundPostScreen.routeName,
                path: LostFoundPostScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final objMap = state.extra;
                  PostDetailsControllerCubit? postDetailsControllerCubit;

                  if (objMap != null) {
                    postDetailsControllerCubit =
                        objMap as PostDetailsControllerCubit;
                  }

                  return animatedPageRoute(
                    navigationDirection: NavigationDirection.bottom,
                    pageKey: state.pageKey,
                    child: LostFoundPostScreen(
                      postDetailsControllerCubit: postDetailsControllerCubit,
                    ),
                  );
                },
              ),
              GoRoute(
                name: SafetyAlertPostScreen.routeName,
                path: SafetyAlertPostScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final objMap = state.extra;
                  PostDetailsControllerCubit? postDetailsControllerCubit;

                  if (objMap != null) {
                    postDetailsControllerCubit =
                        objMap as PostDetailsControllerCubit;
                  }

                  return animatedPageRoute(
                    navigationDirection: NavigationDirection.bottom,
                    pageKey: state.pageKey,
                    child: SafetyAlertPostScreen(
                      postDetailsControllerCubit: postDetailsControllerCubit,
                    ),
                  );
                },
              ),
              GoRoute(
                name: PostDetailsViewScreen.routeName,
                path: PostDetailsViewScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final data = state.extra! as Map<String, dynamic>;

                  final String? allowNavigation = data['allowNavigation'];
                  final String? modifyWithPostType = data['modifyWithPostType'];

                  final reportCubit = data["reportCubit"] as ReportCubit;
                  final showReactionCubit =
                      data['showReactionCubit'] as ShowReactionCubit;
                  final postActionCubit =
                      data['postActionCubit'] as PostActionCubit;
                  final postDetailsControllerCubit =
                      data['postDetailsControllerCubit']
                          as PostDetailsControllerCubit;

                  final commentViewControllerCubit =
                      data['commentViewControllerCubit']
                          as CommentViewControllerCubit;

                  final hidePostCubit = data['hidePostCubit'] as HidePostCubit;

                  return animatedPageRoute(
                    pageKey: state.pageKey,
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: postDetailsControllerCubit),
                        BlocProvider.value(value: showReactionCubit),
                        BlocProvider.value(value: postActionCubit),
                        BlocProvider.value(value: reportCubit),
                        BlocProvider.value(value: hidePostCubit),
                        BlocProvider.value(value: commentViewControllerCubit),
                      ],
                      child: PostDetailsViewScreen(
                        allowNavigation: allowNavigation == null
                            ? true
                            : allowNavigation.toBool(),
                        modifyWithPostType: modifyWithPostType == null
                            ? false
                            : modifyWithPostType.toBool(),
                      ),
                    ),
                  );
                },
              ),

              //Profile Module
              GoRoute(
                name: OwnProfilePostsScreen.routeName,
                path: OwnProfilePostsScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  child: const OwnProfilePostsScreen(),
                ),
                routes: [
                  GoRoute(
                    name: SettingsMenuScreen.routeName,
                    path: SettingsMenuScreen.routeName,
                    builder: (BuildContext context, GoRouterState state) {
                      return const SettingsMenuScreen();
                    },
                  ),
                  GoRoute(
                    name: EditProfileScreen.routeName,
                    path: EditProfileScreen.routeName,
                    builder: (BuildContext context, GoRouterState state) {
                      return const EditProfileScreen();
                    },
                  ),
                  GoRoute(
                    name: ProfilePrivacyScreen.routeName,
                    path: ProfilePrivacyScreen.routeName,
                    builder: (BuildContext context, GoRouterState state) {
                      return const ProfilePrivacyScreen();
                    },
                  ),
                  GoRoute(
                    name: ProfileSettingsScreen.routeName,
                    path: ProfileSettingsScreen.routeName,
                    builder: (BuildContext context, GoRouterState state) {
                      return const ProfileSettingsScreen();
                    },
                    routes: [
                      GoRoute(
                        name: TagLocationScreen.routeName,
                        path: TagLocationScreen.routeName,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final preSelectedLocation = state.extra != null
                              ? state.extra as LocationAddressWithLatLng
                              : null;
                          return animatedPageRoute(
                            pageKey: state.pageKey,
                            child: TagLocationScreen(
                              preSelectedLocation: preSelectedLocation,
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: LocationManageMapScreen.routeName,
                        path: LocationManageMapScreen.routeName,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          final extraDataMap =
                              state.extra as Map<String, dynamic>;

                          final LocationType locationType =
                              extraDataMap['locationType'] as LocationType;

                          final LocationManageType locationManageType =
                              extraDataMap['locationManageType']
                                  as LocationManageType;

                          final FavLocationInfoModel? favLocationInfoModel =
                              extraDataMap['favLocationInfoModel'] == null
                                  ? null
                                  : extraDataMap['favLocationInfoModel']
                                      as FavLocationInfoModel;

                          final allowPop =
                              state.uri.queryParameters['allow_pop'];

                          return animatedPageRoute(
                            pageKey: state.pageKey,
                            child: LocationManageMapScreen(
                              allowPop:
                                  allowPop == null ? true : allowPop.toBool(),
                              locationType: locationType,
                              locationManageType: locationManageType,
                              favLocationInfoModel: favLocationInfoModel,
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: SearchLocationScreen.routeName,
                        path: SearchLocationScreen.routeName,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) {
                          return animatedPageRoute(
                            navigationDirection: NavigationDirection.top,
                            pageKey: state.pageKey,
                            child: BlocProvider.value(
                              value:
                                  state.extra as LocationServiceControllerCubit,
                              child: const SearchLocationScreen(),
                            ),
                          );
                        },
                      ),
                      GoRoute(
                        name: ResetPasswordScreen.routeName,
                        path: ResetPasswordScreen.routeName,
                        pageBuilder:
                            (BuildContext context, GoRouterState state) =>
                                animatedPageRoute(
                          pageKey: state.pageKey,
                          child: const ResetPasswordScreen(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    name: ProfileConnectionScreen.routeName,
                    path: ProfileConnectionScreen.routeName,
                    builder: (BuildContext context, GoRouterState state) {
                      return const ProfileConnectionScreen();
                    },
                  ),
                ],
              ),
            ],
          ),

          //Group
          GoRoute(
            name: GroupScreen.routeName,
            path: GroupScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return GroupScreen(
                groupListType: state.extra as GroupListType,
              );
            },
          ),

          GoRoute(
            name: GroupSeeAllScreen.routeName,
            path: GroupSeeAllScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const GroupSeeAllScreen();
            },
          ),
          GoRoute(
            name: CreateOrUpdateGroupDetailsScreen.routeName,
            path: CreateOrUpdateGroupDetailsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: CreateOrUpdateGroupDetailsScreen(
                  existGroupViewData: state.extra == null
                      ? null
                      : state.extra as GroupProfileDetailsModel,
                ),
                navigationDirection: NavigationDirection.bottom,
              );
            },
          ),
          GoRoute(
            name: GroupChatScreen.routeName,
            path: GroupChatScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              // 'groupName': 'BTM Pet lovers Group',
              // 'groupType': 'Public Community Group · BTM',
              // 'memberCount': 1050,
              // 'groupImageUrl': 'https://your-image-url.com/image.jpg',
              final groupName = 'BTM Pet lovers Group';
              final groupType = 'Public Community Group · BTM';
              final memberCount = 1050;
              final groupImageUrl = 'https://your-image-url.com/image.jpg';
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: GroupChatScreen(
                  groupName: groupName,
                  groupType: groupType,
                  memberCount: memberCount,
                  groupImageUrl: groupImageUrl,
                ),
                navigationDirection: NavigationDirection.right,
              );
            },
          ),

          GoRoute(
            name: SearchGroupScreen.routeName,
            path: SearchGroupScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: const SearchGroupScreen(),
                navigationDirection: NavigationDirection.bottom,
              );
            },
          ),

          //Group details
          GoRoute(
            name: GroupDetailsScreen.routeName,
            path: GroupDetailsScreen.routeName,
            redirect: (context, state) {
              // Access the AuthenticationBloc here
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              final authState = authBloc.state;
              if (authState is AuthenticationAuthenticated) {
                return null;
              } else {
                return "/${ChooseAuthenticationMethodScreen.routeName}";
              }
            },
            pageBuilder: (BuildContext context, GoRouterState state) {
              final groupIndex =
                  state.extra != null ? state.extra as int : null;
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: GroupDetailsScreen(
                  groupId: state.uri.queryParameters['id']!,
                  groupIndex: groupIndex,
                ),
                navigationDirection: NavigationDirection.right,
              );
            },
          ),

          //Group post manage screen
          GoRoute(
            name: ManageGroupPostScreen.routeName,
            path: ManageGroupPostScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final postDetailsControllerCubit = state.extra == null
                  ? null
                  : state.extra as PostDetailsControllerCubit;
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: ManageGroupPostScreen(
                  groupId: state.uri.queryParameters['group_id']!,
                  postDetailsControllerCubit: postDetailsControllerCubit,
                ),
                navigationDirection: NavigationDirection.right,
              );
            },
          ),

          //private group join request screen
          GoRoute(
            name: PrivateGroupJoinRequestScreen.routeName,
            path: PrivateGroupJoinRequestScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: PrivateGroupJoinRequestScreen(
                  groupId: state.uri.queryParameters['group_id']!,
                  privateGroupJoinRequestsCubit: state.extra == null
                      ? null
                      : state.extra as PrivateGroupJoinRequestsCubit,
                ),
                navigationDirection: NavigationDirection.right,
              );
            },
          ),

          //Page details
          GoRoute(
            name: PageDetailsScreen.routeName,
            path: PageDetailsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: PageDetailsScreen(
                  pageId: state.uri.queryParameters['id']!,
                ),
                navigationDirection: NavigationDirection.right,
              );
            },
            redirect: (context, state) {
              // check for the authentication status
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              final authState = authBloc.state;
              if (authState is AuthenticationAuthenticated) {
                return null;
              } else {
                return "/${ChooseAuthenticationMethodScreen.routeName}";
              }
            },
          ),
          //Page post manage screen
          GoRoute(
            name: ManagePagePostScreen.routeName,
            path: ManagePagePostScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final postDetailsControllerCubit = state.extra == null
                  ? null
                  : state.extra as PostDetailsControllerCubit;
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: ManagePagePostScreen(
                  pageId: state.uri.queryParameters['page_id']!,
                  postDetailsControllerCubit: postDetailsControllerCubit,
                ),
                navigationDirection: NavigationDirection.right,
              );
            },
          ),

          //More

          //CategoryWiseFeedPosts
          GoRoute(
            name: CategoryWiseFeedPostsScreen.routeName,
            path: CategoryWiseFeedPostsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: CategoryWiseFeedPostsScreen(
                  categoryType: state.extra as FeedPostCategoryType,
                ),
                navigationDirection: NavigationDirection.right,
              );
            },
          ),

          //Event
          GoRoute(
              name: EventDetailsScreen.routeName,
              path: EventDetailsScreen.routeName,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final extraData = state.extra == null
                    ? null
                    : state.extra as Map<String, dynamic>;

                final postActionCubit = extraData?['postActionCubit'] == null
                    ? PostActionCubit(PostActionRepository())
                    : extraData!['postActionCubit'] as PostActionCubit;
                final postDetailsControllerCubit =
                    extraData?['postDetailsControllerCubit'] == null
                        ? null
                        : extraData!['postDetailsControllerCubit']
                            as PostDetailsControllerCubit;

                return animatedPageRoute(
                  pageKey: state.pageKey,
                  child: BlocProvider.value(
                    value: postActionCubit,
                    child: EventDetailsScreen(
                      eventId: state.uri.queryParameters['id']!,
                      postDetailsControllerCubit: postDetailsControllerCubit,
                    ),
                  ),
                );
              },
              routes: [
                GoRoute(
                  name: EventAttendingScreen.routeName,
                  path: EventAttendingScreen.routeName,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return animatedPageRoute(
                      pageKey: state.pageKey,
                      child: EventAttendingScreen(
                        eventId: state.uri.queryParameters['event_id']!,
                      ),
                    );
                  },
                ),
              ]),

          GoRoute(
            name: CreateEventScreen.routeName,
            path: CreateEventScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final objMap = state.extra;
              PostDetailsControllerCubit? postDetailsControllerCubit;

              if (objMap != null) {
                postDetailsControllerCubit =
                    objMap as PostDetailsControllerCubit;
              }

              return animatedPageRoute(
                navigationDirection: NavigationDirection.bottom,
                pageKey: state.pageKey,
                child: CreateEventScreen(
                  postDetailsControllerCubit: postDetailsControllerCubit,
                ),
              );
            },
          ),

          GoRoute(
            name: EventScreen.routeName,
            path: EventScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return EventScreen(
                eventPostListType: state.extra as EventPostListType,
              );
            },
          ),

          //Page
          GoRoute(
            name: PageSeeAllScreen.routeName,
            path: PageSeeAllScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const PageSeeAllScreen();
            },
          ),
          GoRoute(
            name: PageScreen.routeName,
            path: PageScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return PageScreen(
                pageListType: state.extra as PageListType,
              );
            },
            routes: [
              GoRoute(
                  name: CreateOrUpdatePageDetailsScreen.routeName,
                  path: CreateOrUpdatePageDetailsScreen.routeName,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return animatedPageRoute(
                      pageKey: state.pageKey,
                      child: CreateOrUpdatePageDetailsScreen(
                        existPageViewData: state.extra == null
                            ? null
                            : state.extra as PageProfileDetailsModel,
                      ),
                      navigationDirection: NavigationDirection.bottom,
                    );
                  },
                  routes: [
                    GoRoute(
                      name: ReferEarnScreen.routeName,
                      path: ReferEarnScreen.routeName,
                      builder: (BuildContext context, GoRouterState state) {
                        return const ReferEarnScreen();
                      },
                    ),
                  ]),
              GoRoute(
                name: SearchPageScreen.routeName,
                path: SearchPageScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return animatedPageRoute(
                    pageKey: state.pageKey,
                    child: const SearchPageScreen(),
                    navigationDirection: NavigationDirection.bottom,
                  );
                },
              ),
            ],
          ),

          //Jobs
          GoRoute(
            name: JobsScreen.routeName,
            path: JobsScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              final jobsListType = state.extra == null
                  ? JobsListType.byNeighbours
                  : state.extra as JobsListType;
              return JobsScreen(jobsListType: jobsListType);
            },
            routes: [
              GoRoute(
                name: ManageJobsScreen.routeName,
                path: ManageJobsScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  navigationDirection: NavigationDirection.right,
                  child: ManageJobsScreen(
                    existJobsDetailModel: state.extra == null
                        ? null
                        : state.extra as JobDetailModel,
                  ),
                ),
              ),
            ],
          ),

          //Job details
          GoRoute(
              name: JobDetailsScreen.routeName,
              path: JobDetailsScreen.routeName,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final openEditScreen =
                    state.uri.queryParameters['open_edit_screen'];
                return animatedPageRoute(
                  pageKey: state.pageKey,
                  child: JobDetailsScreen(
                    jobId: state.uri.queryParameters['id']!,
                    jobTitle: state.uri.queryParameters['job_title'],
                    openEditScreen: openEditScreen == null
                        ? false
                        : openEditScreen.toBool(),
                    jobShortViewControllerCubit: state.extra == null
                        ? null
                        : state.extra as JobShortViewControllerCubit,
                  ),
                );
              }),

          //Polls
          GoRoute(
            name: PollsScreen.routeName,
            path: PollsScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return PollsScreen(
                pollsListType: state.extra as PollsListType,
              );
            },
            routes: [
              GoRoute(
                  name: ManagePollScreen.routeName,
                  path: ManagePollScreen.routeName,
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    final postDetailsControllerCubit = state.extra == null
                        ? null
                        : state.extra as PostDetailsControllerCubit;

                    return animatedPageRoute(
                      pageKey: state.pageKey,
                      navigationDirection: NavigationDirection.right,
                      child: ManagePollScreen(
                        postDetailsControllerCubit: postDetailsControllerCubit,
                      ),
                    );
                  }),
            ],
          ),

          //Hall of fame
          GoRoute(
            name: HallOfFameScreen.routeName,
            path: HallOfFameScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              final navigateToWinnerTab =
                  state.uri.queryParameters['navigate_to_winner_tab'];
              return HallOfFameScreen(
                navigateToWinnerTab: navigateToWinnerTab == null
                    ? false
                    : navigateToWinnerTab.toBool(),
              );
            },
            routes: [
              GoRoute(
                name: InterestedTopicsScreen.routeName,
                path: InterestedTopicsScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  navigationDirection: NavigationDirection.right,
                  child: InterestedTopicsScreen(
                    interestedTopicsCategoryCubit:
                        state.extra as InterestedTopicsCategoryCubit,
                  ),
                ),
              ),
              GoRoute(
                name: InterestedLanguageScreen.routeName,
                path: InterestedLanguageScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  navigationDirection: NavigationDirection.right,
                  child: InterestedLanguageScreen(
                    interestedLanguagesCubit:
                        state.extra as InterestedLanguagesCubit,
                  ),
                ),
              ),
            ],
          ),

          //Saved items
          GoRoute(
            name: SavedItemScreen.routeName,
            path: SavedItemScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const SavedItemScreen();
            },
          ),

          //Help and support
          GoRoute(
            name: HelpAndSupportScreen.routeName,
            path: HelpAndSupportScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const HelpAndSupportScreen();
            },
          ),

          //Business
          GoRoute(
            name: BusinessScreen.routeName,
            path: BusinessScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return BusinessScreen(
                businessViewType: state.extra == null
                    ? BusinessViewType.business //default type
                    : state.extra as BusinessViewType,
              );
            },
            routes: [
              GoRoute(
                name: CreateOrUpdateBusinessScreen.routeName,
                path: CreateOrUpdateBusinessScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  navigationDirection: NavigationDirection.right,
                  child: CreateOrUpdateBusinessScreen(
                    existBusinessData: state.extra == null
                        ? null
                        : state.extra as BusinessDetailsModel,
                  ),
                ),
              ),
            ],
          ),
          //business details screen
          GoRoute(
            name: BusinessDetailsScreen.routeName,
            path: BusinessDetailsScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              final onBusinessFetch = state.extra as VoidCallback?;
              return BusinessDetailsScreen(
                onBusinessFetch: onBusinessFetch ?? () {}, // fallback to empty function
                businessId: state.uri.queryParameters['id']!,
              );
            },
            routes: [
              GoRoute(
                name: RatingsReviewDetailsScreen.routeName,
                path: RatingsReviewDetailsScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  child: RatingsReviewDetailsScreen(
                    id: state.uri.queryParameters['id']!,
                    ratingType: state.extra as RatingType,
                  ),
                ),
              ),
            ],
          ),

          //Buy-Sell
          GoRoute(
            name: BuySellScreen.routeName,
            path: BuySellScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return BuySellScreen(
                salesPostListType: state.extra as SalesPostListType,
              );
            },
            routes: [
              GoRoute(
                name: ManageSalesPostScreen.routeName,
                path: ManageSalesPostScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  navigationDirection: NavigationDirection.right,
                  child: ManageSalesPostScreen(
                    existSalesPostDetailModel: state.extra == null
                        ? null
                        : state.extra as SalesPostDetailModel,
                  ),
                ),
              ),
            ],
          ),
          //Sales post details screen
          GoRoute(
            name: SalesPostDetailsScreen.routeName,
            path: SalesPostDetailsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: SalesPostDetailsScreen(
                  salesPostId: state.uri.queryParameters['id']!,
                ),
              );
            },
          ),

          //Market place owner activity
          GoRoute(
            name: OwnerActivityDetailsScreen.routeName,
            path: OwnerActivityDetailsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                animatedPageRoute(
              pageKey: state.pageKey,
              child: OwnerActivityDetailsScreen(
                postId: state.uri.queryParameters['post_id']!,
                appBarTitle: state.uri.queryParameters['app_bar_title'],
                ownerActivityType: state.extra as OwnerActivityType,
              ),
            ),
          ),
          //Owner activity details screen from link
          GoRoute(
            name: ShareOwnerActivityDetails.routeName,
            path: ShareOwnerActivityDetails.routeName,
            builder: (BuildContext context, GoRouterState state) {
              final data = state.uri.queryParameters['id']!;
              final encryptedData = Uri.decodeFull(data);
              return ShareOwnerActivityDetails(encryptedData: encryptedData);
            },
            redirect: checkAuthAndRedirect,
          ),

          //interested people list screen
          GoRoute(
            name: InterestedPeopleListScreen.routeName,
            path: InterestedPeopleListScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: InterestedPeopleListScreen(
                  postId: state.uri.queryParameters['id']!,
                  marketPlaceType: state.extra as MarketPlaceType,
                ),
              );
            },
          ),
          //user list screen
          GoRoute(
            name: FollowerListScreen.routeName,
            path: FollowerListScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: FollowerListScreen(
                  followerListImpl: state.extra as FollowerListImpl,
                  postId: state.uri.queryParameters['id']!,
                ),
              );
            },
          ),
          //Influencer Follower List Screen
          GoRoute(
            name: InfluencerFollowerListScreen.routeName,
            path: InfluencerFollowerListScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: InfluencerFollowerListScreen(
                  userId: state.uri.queryParameters['id']!,
                ),
              );
            },
          ),
          //Chat Contact Screen
          GoRoute(
            name: ChatContactsScreen.routeName,
            path: ChatContactsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                animatedPageRoute(
              pageKey: state.pageKey,
              child: const ChatContactsScreen(),
            ),
            routes: [
              GoRoute(
                name: ChatScreen.routeName,
                path: ChatScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  child: ChatScreen(
                    receiverUserId:
                        state.uri.queryParameters['receiver_user_id']!,
                    otherCommunicationPost: state.extra == null
                        ? null
                        : state.extra as OtherCommunicationPost,
                  ),
                ),
              ),
            ],
          ),

          //Media player
          GoRoute(
            name: VideoPlayerScreen.routeName,
            path: VideoPlayerScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                animatedPageRoute(
              pageKey: state.pageKey,
              child: VideoPlayerScreen(
                initialFullScreen: state.uri.queryParameters['initialFullScreen']=="true",
                videoUrl: state.uri.queryParameters['video_url'],
                videoFile: state.extra == null ? null : state.extra as File,
              ),
            ),
          ),

          //Neighbours profile
          GoRoute(
            name: NeighboursProfileAndPostsScreen.routeName,
            path: NeighboursProfileAndPostsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                animatedPageRoute(
              pageKey: state.pageKey,
              child: NeighboursProfileAndPostsScreen(
                userid: state.uri.queryParameters['id']!,
                profileConnectionActionCubit: state.extra != null
                    ? state.extra as ProfileConnectionActionCubit
                    : null,
              ),
            ),
          ),

          //Shared post details screen by link
          GoRoute(
            name: SharedSocialPostDetailsByLink.routeName,
            path: SharedSocialPostDetailsByLink.routeName,
            builder: (BuildContext context, GoRouterState state) {
              final data = state.uri.queryParameters['id']!;
              final encryptedData = Uri.decodeFull(data);
              return SharedSocialPostDetailsByLink(
                encryptedData: encryptedData,
              );
            },
            redirect: checkAuthAndRedirect,
          ),

          //Shared post details screen by notification
          GoRoute(
            name: GeneralSharedSocialPostDetails.routeName,
            path: GeneralSharedSocialPostDetails.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return GeneralSharedSocialPostDetails(
                sharedPostDataModel: state.extra as SharedPostDataModel,
              );
            },
            redirect: (context, state) {
              // Access the AuthenticationBloc here
              final authBloc = BlocProvider.of<AuthenticationBloc>(context);
              final authState = authBloc.state;

              if (authState is AuthenticationAuthenticated) {
                return null;
              } else {
                return "/${ChooseAuthenticationMethodScreen.routeName}";
              }
            },
          ),

          //Local notification view screen
          GoRoute(
            name: LocalNotificationViewScreen.routeName,
            path: LocalNotificationViewScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const LocalNotificationViewScreen();
            },
          ),

          //Report
          GoRoute(
            name: ReportScreen.routeName,
            path: ReportScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              final reportScreenPayload = state.extra as ReportScreenPayload;
              return BlocProvider.value(
                value: reportScreenPayload.reportCubit,
                child: ReportScreen(
                  payload: state.extra as ReportScreenPayload,
                ),
              );
            },
          ),

          //Report Local Chat Spam User
          GoRoute(
            name: ReportLocalChatSpamUserScreen.routeName,
            path: '${ReportLocalChatSpamUserScreen.routeName}/:userId/:reportMessage',
            builder: (BuildContext context, GoRouterState state) {
              final userId = state.pathParameters['userId']!;
              final reportMessage = Uri.decodeComponent(state.pathParameters['reportMessage'] ?? '');
              final screenshot = state.extra as String?;
              return BlocProvider(
                create: (context) => ReportLocalChatSpamCubit(ReportLocalChatSpamRepository()),
                child: ReportLocalChatSpamUserScreen(
                  userId: userId,
                  reportMessage: reportMessage,
                  screenshot: screenshot,
                ),
              );
            },
          ),

          //News
          GoRoute(
            name: NewsListScreen.routeName,
            path: NewsListScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const NewsListScreen();
            },
            routes: [
              GoRoute(
                name: CreateNewsChannelScreen.routeName,
                path: CreateNewsChannelScreen.routeName,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    animatedPageRoute(
                  pageKey: state.pageKey,
                  navigationDirection: NavigationDirection.right,
                  child: CreateNewsChannelScreen(
                    existingManageNewsChannelModel: state.extra == null
                        ? null
                        : state.extra as ManageNewsChannelModel,
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            name: JoinNewsCommunityScreen.routeName,
            path: JoinNewsCommunityScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const JoinNewsCommunityScreen();
            },
          ),
          GoRoute(
            name: ManagePostNewsScreen.routeName,
            path: ManagePostNewsScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const ManagePostNewsScreen();
            },
          ),
          GoRoute(
            name: MyDashboardScreen.routeName,
            path: MyDashboardScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return const MyDashboardScreen();
            },
          ),
          GoRoute(
            name: PostNewsPreviewScreen.routeName,
            path: PostNewsPreviewScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final payLoad = state.extra as PostNewsPreviewScreenPayload;
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: PostNewsPreviewScreen(
                  postNewsPreviewScreenPayload: payLoad,
                ),
              );
            },
          ),

          //My wallet
          GoRoute(
            name: MyWalletScreen.routeName,
            path: MyWalletScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: const MyWalletScreen(),
              );
            },
          ),

          //add bank account screen
          GoRoute(
            name: ManageBankDetailsScreen.routeName,
            path: ManageBankDetailsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: const ManageBankDetailsScreen(),
              );
            },
          ),
          GoRoute(
            name: ChannelOverViewScreen.routeName,
            path: ChannelOverViewScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final channelId = state.uri.queryParameters['id']!;

              return animatedPageRoute(
                pageKey: state.pageKey,
                child: ChannelOverViewScreen(
                  channelId: channelId,
                  postDetailsControllerCubit: (state.extra != null &&
                          state.extra is PostDetailsControllerCubit)
                      ? state.extra as PostDetailsControllerCubit
                      : null,
                ),
              );
            },
          ),
          GoRoute(
            name: NewsPostViewDetailsScreen.routeName,
            path: NewsPostViewDetailsScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final data = state.extra != null
                  ? state.extra as Map<String, dynamic>
                  : null;

              final postDetailsControllerCubit =
                  data?['postDetailsControllerCubit'] == null
                      ? null
                      : data?['postDetailsControllerCubit']
                          as PostDetailsControllerCubit;

              final showReactionCubit = data?['showReactionCubit'] == null
                  ? ShowReactionCubit()
                  : data?['showReactionCubit'] as ShowReactionCubit;

              final postActionCubit = data?['postActionCubit'] == null
                  ? PostActionCubit(PostActionRepository())
                  : data?['postActionCubit'] as PostActionCubit;

              final reportCubit = data?['reportCubit'] == null
                  ? ReportCubit(ReportRepository())
                  : data?['reportCubit'] as ReportCubit;

              final commentViewControllerCubit =
                  data?['commentViewControllerCubit'] == null
                      ? CommentViewControllerCubit()
                      : data?['commentViewControllerCubit']
                          as CommentViewControllerCubit;

              final hidePostCubit = data?['hidePostCubit'] == null
                  ? HidePostCubit(HidePostRepository())
                  : data?['hidePostCubit'] as HidePostCubit;

              return animatedPageRoute(
                pageKey: state.pageKey,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: showReactionCubit),
                    BlocProvider.value(value: postActionCubit),
                    BlocProvider.value(value: reportCubit),
                    BlocProvider.value(value: hidePostCubit),
                    BlocProvider.value(value: commentViewControllerCubit),
                    BlocProvider(
                      create: (context) =>
                          GiveReactionCubit(context.read<ReactionRepository>()),
                    ),
                  ],
                  child: NewsPostViewDetailsScreen(
                    postId: state.uri.queryParameters['id']!,
                    existingPostDetailsControllerCubit:
                        postDetailsControllerCubit,
                  ),
                ),
              );
            },
          ),

          // Analytics overview screen
          GoRoute(
            name: AnalyticsOverviewScreen.routeName,
            path: AnalyticsOverviewScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              final String moduleId = state.uri.queryParameters['module_id']!;
              final moduleType = AnalyticsModuleType.fromString(
                  state.uri.queryParameters['module_type']!);
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: AnalyticsOverviewScreen(
                  moduleId: moduleId,
                  moduleType: moduleType,
                ),
              );
            },
          ),
          //Helpline Numbers
          GoRoute(
            name: HelplineNumbersScreen.routeName,
            path: HelplineNumbersScreen.routeName,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return animatedPageRoute(
                pageKey: state.pageKey,
                child: const HelplineNumbersScreen(),
              );
            },
          ),
        ],
      ),
    ],
  );
}
