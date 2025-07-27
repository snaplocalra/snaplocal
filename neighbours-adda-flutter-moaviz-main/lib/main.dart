import 'dart:io';

import 'package:designer/config/theme_colour.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:internet_handler/logic/internet/internet_cubit.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:snap_local/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:snap_local/authentication/logic/login/login_bloc.dart';
import 'package:snap_local/authentication/logic/social_login/social_login_bloc.dart';
import 'package:snap_local/authentication/repository/auth_repository.dart';
import 'package:snap_local/authentication/repository/firebase_login.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/repository/manage_business_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/repository/business_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_home_data/group_home_data_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/logic/group_list/group_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/create_group_post/repository/manage_group_post_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/modules/group_connection/repository/group_connection_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/group_details/repository/group_details_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/modules/manage_group/repository/manage_group_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/groups/repository/group_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/connection_connect/connection_connect_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/connection_ignore/connection_ignore_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_connections/local_connections_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_banners/home_banners_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_feed_posts/home_feed_posts_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_local_groups/home_local_groups_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/home_local_pages/home_local_pages_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_events/local_events_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_jobs/local_jobs_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_news/local_news_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_offers/local_offers_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/logic/favorite_location_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/modules/favorite_location/repository/favorite_location_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/logic/event_list/event_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/event/event_list/repository/event_post_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_home_data/page_home_data_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/logic/page_list/page_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/manage_page/repository/manage_page_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/create_page_post/repository/manage_page_post_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/modules/page_details/modules/page_connection/repository/page_connection_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/page/repository/page_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/logic/polls_list/polls_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/repository/polls_list_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/check_news_post/logic/check_news_post_limit/check_news_post_limit_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/check_news_post/repository/check_news_post_limit_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/logic/news_language_change_controller/news_language_change_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_channel/repository/manage_news_channel_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/logic/manage_news_post/manage_news_post_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/manage_news_post/repository/manage_news_post_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/logic/channel_overview_controller/channel_overview_controller_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_channel_overview/repository/news_channel_overview_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_channel_details/own_news_channel_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_dashboard_news_list/news_dashboard_news_list_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/logic/news_dashboard_statistics/news_dashboard_statistics_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/logic/news_earnings/news_earnings_cubit.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/modules/news_wallet/repository/news_earnings_repository.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/news/modules/news_dashboard/repository/news_dashboard_repository.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_navigator/bottom_bar_navigator_cubit.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_visibility/bottom_bar_visibility_cubit.dart';
import 'package:snap_local/bottom_bar/logic/user_consent_handler/user_consent_handler_cubit.dart';
import 'package:snap_local/common/social_media/create/create_social_post/repository/manage_general_post_repository.dart';
import 'package:snap_local/common/social_media/post/modules/comment/repository/comment_repository.dart';
import 'package:snap_local/common/social_media/post/modules/social_post_reaction/repository/emoji_repository.dart';
import 'package:snap_local/common/social_media/post/shared_social_post/repository/share_post_details_repository.dart';
import 'package:snap_local/common/social_media/post/video_feed/logic/video_feed_posts/video_feed_posts_cubit.dart';
import 'package:snap_local/common/social_media/profile/language_known/logic/language_known/language_known_cubit.dart';
import 'package:snap_local/common/social_media/profile/language_known/repository/language_known_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/active_users/active_users_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chat_flaged_count/local_chat_flaged_count_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/local_chats_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/reply_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/search_state_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/tab/tab_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_setting_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chat_blocked_users_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chats_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/message_request_status_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/report_local_chat_spam_repository.dart';
import 'package:snap_local/common/utils/local_notification/logic/local_notification_view/local_notification_view_cubit.dart';
import 'package:snap_local/common/utils/local_notification/logic/notification_counter/notification_counter_cubit.dart';
import 'package:snap_local/common/utils/local_notification/repository/local_notification_repository.dart';
import 'package:snap_local/common/utils/share/logic/share/share_cubit.dart';
import 'package:snap_local/firebase_options.dart';
import 'package:snap_local/profile/manage_profile_details/logic/manage_profile_details/manage_profile_details_bloc.dart';
import 'package:snap_local/profile/manage_profile_details/repository/profile_repository.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/level_details/logic/level_details/level_details_cubit.dart';
import 'package:snap_local/profile/profile_details/own_profile/modules/level_details/repository/reward_details_repository.dart';
import 'package:snap_local/profile/profile_privacy/logic/profile_privacy_manager/profile_privacy_manager_cubit.dart';
import 'package:snap_local/profile/profile_privacy/repository/profile_privacy_repository.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';
import 'package:snap_local/profile/profile_settings/logic/update_profile_setting_location_and_feed_radius/update_profile_setting_location_and_feed_radius_cubit.dart';
import 'package:snap_local/profile/profile_settings/repository/profile_settings_repository.dart';
import 'package:snap_local/splash/splash_controller/splash_controller_cubit.dart';
import 'package:snap_local/utility/application_version_checker/logic/application_version_checker/application_version_checker_cubit.dart';
import 'package:snap_local/utility/application_version_checker/repository/version_check_repository.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';
import 'package:snap_local/utility/constant/names.dart';
import 'package:snap_local/utility/download/download_cubit.dart';
import 'package:snap_local/utility/google_gemini/google_gemini_model.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';
import 'package:snap_local/utility/localization/logic/locale_from_location/locale_from_location_cubit.dart';
import 'package:snap_local/utility/localization/model/locale_model.dart';
import 'package:snap_local/utility/localization/translation/codegen_loader.g.dart';
import 'package:snap_local/utility/location/repository/google_location_repository.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';
import 'package:snap_local/utility/location/storage/php_server_location_storage.dart';
import 'package:snap_local/utility/media_player/tools/media_player_controller/media_player_controller_cubit.dart';
import 'package:snap_local/utility/media_player/tools/media_player_volume_controller/media_player_volume_controller_cubit.dart';
import 'package:snap_local/utility/push_notification/firebase_messaging_service/service/notification_service.dart';
import 'package:snap_local/utility/router/go_routes.dart';
import 'package:snap_local/utility/session_checker/logic/cubit/session_checker_cubit.dart';
import 'package:snap_local/utility/session_checker/repository/session_checker_repository.dart';

import 'common/social_media/post/video_feed/repository/video_data_repository.dart';
import 'profile/profile_settings/logic/remove_account/remove_account_cubit.dart';
import 'utility/localization/google_translate/translation_language_database/db/hive/model/hive_translated_language_db_model.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/logic/local_buy_sell/local_buy_sell_cubit.dart';

//To bypass the ssl certificate handshake issue on android 8 below devices
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  //To bypass the ssl certificate handshake issue on android 8 below devices
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  //Google Gemini model initialization
  await GoogleGeminiModel.initialize();

  //Hive database initialization
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(
      HiveTranslatedLanguageDbModelAdapter()); // Register adapter

  //Firebase setup
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  if (kReleaseMode) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    //Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack);
      return true;
    };
  }

  //Easy localization initialization
  await EasyLocalization.ensureInitialized();

  //Hydrated storage initialization
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  //Request for notification permission
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  //Initialize the flutter downloader
  await FlutterDownloader.initialize();

  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [
        LocaleManager.english,
        LocaleManager.hindi,
        LocaleManager.kannada,
        LocaleManager.malayalam,
        LocaleManager.tamil,
        LocaleManager.telugu,
      ],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      fallbackLocale: LocaleManager.english,
      child: ShowCaseWidget(builder: (context) => const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthenticationBloc authenticationBloc;
  late AuthRepository authRepository;
  final firebaseLoginRepository = FirebaseLoginRepository();

  //When the app is in debug mode, this GoRouter instance is created
  final GoRouter debugModeGoRouter = GoRouterManager().router;

  @override
  void initState() {
    super.initState();

    authRepository = AuthRepository();
    authenticationBloc = AuthenticationBloc(
      authRepository: authRepository,
      firebaseLoginRepository: firebaseLoginRepository,
    );
    authenticationBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        //Notification service
        RepositoryProvider(
          create: (context) => NotificationService(
            FlutterLocalNotificationsPlugin(),
          ),
        ),

        //Authentication
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: firebaseLoginRepository),

        //Language known
        RepositoryProvider(create: (context) => LanguageKnownRepository()),

        //Notification
        RepositoryProvider(create: (context) => LocalNotificationRepository()),

        //Profile
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => MediaUploadRepository()),
        RepositoryProvider(create: (context) => ProfilePrivacyRepository()),
        RepositoryProvider(create: (context) => ProfileSettingsRepository()),

        //Posts
        RepositoryProvider(create: (context) => CommentRepository()),
        RepositoryProvider(create: (context) => ReactionRepository()),
        RepositoryProvider(create: (context) => ManageGeneralPostRepository()),
        RepositoryProvider(create: (context) => HomeDataRepository()),
        RepositoryProvider(create: (context) => VideoDataRepository()),
        RepositoryProvider(create: (context) => SharePostDetailsRepository()),

        //Groups
        RepositoryProvider(create: (context) => GroupListRepository()),
        RepositoryProvider(create: (context) => ManageGroupRepository()),
        RepositoryProvider(create: (context) => GroupDetailsRepository()),
        RepositoryProvider(create: (context) => ManageGroupPostRepository()),
        RepositoryProvider(create: (context) => GroupConnectionRepository()),

        //Pages
        RepositoryProvider(create: (context) => PageListRepository()),
        RepositoryProvider(create: (context) => ManagePageRepository()),
        RepositoryProvider(create: (context) => ManagePagePostRepository()),
        RepositoryProvider(create: (context) => PageConnectionRepository()),

        // news
        RepositoryProvider(create: (context) => ManageNewsPostRepository()),

        //Business
        RepositoryProvider(create: (context) => BusinessListRepository()),
        RepositoryProvider(create: (context) => ManageBusinessRepository()),

        //Firebase Chat
        RepositoryProvider(
          create: (context) => FirebaseChatSettingRepository(),
        ),

        RepositoryProvider<ReportLocalChatSpamRepository>(
          create: (context) => ReportLocalChatSpamRepository(),
        ),

        //MessageRequestStatusRepository
        RepositoryProvider(
          create: (context) => MessageRequestStatusRepository(),
        ),

        //Firebase Chat
        RepositoryProvider(
          create: (context) => FirebaseChatRepository(
            context.read<MessageRequestStatusRepository>(),
          ),
        ),

        //Favorite Location
        RepositoryProvider(create: (context) => FavoriteLocationRepository()),

        // Location Service
        RepositoryProvider(
          create: (context) => LocationServiceRepository(
            GoogleLocationRepository(
              PHPServerLocationStorage(),
            ),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SplashControllerCubit()),
          BlocProvider(
            create: (context) => LanguageKnownCubit(
              context.read<LanguageKnownRepository>(),
            ),
          ),

          BlocProvider(create: (context) => LanguageChangeControllerCubit()),

          //Internet cubit
          BlocProvider(
            create: (context) =>
                InternetCubit(enableInitialConnectionCheck: false),
          ),

          //Authentication
          BlocProvider.value(value: authenticationBloc),
          BlocProvider(
            create: (context) => SocialLoginBloc(
              authRepository: context.read<AuthRepository>(),
              authenticationBloc: context.read<AuthenticationBloc>(),
              firebaseLoginRepository: context.read<FirebaseLoginRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
              authRepository: context.read<AuthRepository>(),
              authenticationBloc: context.read<AuthenticationBloc>(),
            ),
          ),

          //Version Checker
          BlocProvider(
            create: (context) => ApplicationVersionCheckerCubit(
              versionCheckRepositoy: VersionCheckRepository(),
            )..checkApplicationVersion(),
          ),

          //Session checker
          BlocProvider(
            create: (context) =>
                SessionCheckerCubit(SessionCheckerRepository()),
          ),

          //Media player volume controller
          BlocProvider(
            create: (context) => MediaPlayerVolumeControllerCubit(),
          ),

          //Audio Player Controller
          BlocProvider(create: (context) => MediaPlayerControllerCubit()),

          //Reaction
          // BlocProvider(
          //   create: (context) => ReactionAudioEffectControllerCubit(
          //     AudioPlayer(),
          //   ),
          // ),

          //Download Cubit
          BlocProvider(create: (context) => DownloadCubit()),

          //Notification
          BlocProvider(
            create: (context) => NotificationCounterCubit(
              context.read<LocalNotificationRepository>(),
            ),
          ),

          //Local Notification
          BlocProvider(
            create: (context) => LocalNotificationViewCubit(
              context.read<LocalNotificationRepository>(),
              context.read<NotificationCounterCubit>(),
            ),
          ),

          //Introduction
          BlocProvider(
            create: (context) =>
                UserConsentHandlerCubit()..checkLanguageAndAgreement(),
          ),

          //Home Social Posts
          BlocProvider(
            create: (context) => HomeSocialPostsCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Video Feed Posts
          BlocProvider(
            create: (context) => VideoSocialPostsCubit(
              context.read<VideoDataRepository>(),
            ),
          ),

          //Home Local Groups
          BlocProvider(
            create: (context) => HomeLocalGroupsCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Home Local Pages
          BlocProvider(
            create: (context) => HomeLocalPagesCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Home Local Buy and Sell
          BlocProvider(
            create: (context) => LocalBuyAndSellCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Home Local Jobs
          BlocProvider(
            create: (context) => LocalJobsCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Home Local Offers
          BlocProvider(
            create: (context) => LocalOffersCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Home Local Events
          BlocProvider(
            create: (context) => LocalEventsCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Home Local News
          BlocProvider(
            create: (context) => LocalNewsCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Home Local Connections
          BlocProvider(
            create: (context) => LocalConnectionsCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Connection Ignore
          BlocProvider(
            create: (context) => ConnectionIgnoreCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Connection Connect
          BlocProvider(
            create: (context) => ConnectionConnectCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => LocalChatsCubit(
              repository: LocalChatsRepository(),
              blockedUsersRepo: context.read<LocalChatBlockedUsersRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => LocalChatFlagedCountCubit(
              repository: context.read<ReportLocalChatSpamRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => MainConversationTabsCubit(),
          ),
          BlocProvider(
            create: (context) => SearchStateCubit(),
          ),

          // Active Users
          BlocProvider(
            create: (context) => ActiveUsersCubit(),
          ),

          //Home Banners
          BlocProvider(
            create: (context) => HomeBannersCubit(
              context.read<HomeDataRepository>(),
            ),
          ),

          //Level Details
          BlocProvider(
            create: (context) => LevelDetailsCubit(LevelDetailsRepository()),
          ),

          //Bottom bar
          BlocProvider(create: (context) => BottomBarVisibilityCubit()),
          BlocProvider(
            create: (context) => BottomBarNavigatorCubit(
              context.read<BottomBarVisibilityCubit>(),
            ),
          ),

          //Own News channel
          BlocProvider(
            create: (context) => OwnNewsChannelCubit(
              ManageNewsChannelRepositoryImpl(),
            ),
          ),

          //News earnings cubit
          BlocProvider(
            create: (context) => NewsEarningsCubit(NewsEarningsRepository()),
          ),

          //Groups
          BlocProvider(
            create: (context) => GroupHomeDataCubit(
              context.read<GroupListRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => GroupListCubit(
              context.read<GroupListRepository>(),
            ),
          ),

          //Pages
          BlocProvider(
            create: (context) => PageHomeDataCubit(
              context.read<PageListRepository>(),
            ),
          ),

          BlocProvider(
            create: (context) => PageListCubit(
              context.read<PageListRepository>(),
            ),
          ),

          //Event
          BlocProvider(
            create: (context) => EventListCubit(EventPostRepository()),
          ),

          //Polls
          BlocProvider(
            create: (context) => PollsListCubit(PollsListRepository()),
          ),

          //Profile
          BlocProvider(
            create: (context) => ManageProfileDetailsBloc(
              profileRepository: context.read<ProfileRepository>(),
              mediaUploadRepository: context.read<MediaUploadRepository>(),
            ),
          ),

          //Profile Privacy Manager
          BlocProvider(
            create: (context) => ProfilePrivacyManagerCubit(
              privacyRepository: context.read<ProfilePrivacyRepository>(),
            ),
          ),

          //Profile Settings
          BlocProvider(
            create: (context) =>
                ProfileSettingsCubit(context.read<ProfileSettingsRepository>()),
          ),

          //Update profile settings location and feed radius
          BlocProvider(
            create: (context) => UpdateProfileSettingLocationAndFeedRadiusCubit(
              profileSettingsRepository:
                  context.read<ProfileSettingsRepository>(),
              profileSettingsCubit: context.read<ProfileSettingsCubit>(),
              profileDetailsBloc: context.read<ManageProfileDetailsBloc>(),
            ),
          ),

          //Favorite Location
          BlocProvider(
            create: (context) => FavoriteLocationCubit(
              favoriteLocationRepository:
                  context.read<FavoriteLocationRepository>(),
              profileSettingsCubit: context.read<ProfileSettingsCubit>(),
              profileDetailsBloc: context.read<ManageProfileDetailsBloc>(),
            ),
          ),

          //Remove Account
          BlocProvider(
            create: (context) => RemoveAccountCubit(
              profileSettingsRepository:
                  context.read<ProfileSettingsRepository>(),
              authenticationBloc: context.read<AuthenticationBloc>(),
            ),
          ),

          //Share Cubit
          BlocProvider(create: (context) => ShareCubit()),

          //News module
          BlocProvider(
            create: (context) =>
                ChannelOverviewControllerCubit(NewsChannelOverviewRepository()),
          ),

          //Check news post limit
          BlocProvider(
            create: (context) => CheckNewsPostLimitCubit(
              CheckNewsPostLimitRepository(),
            ),
          ),

          //news dashboard statistics
          BlocProvider(
              create: (context) =>
                  NewsDashboardStatisticsCubit(NewsDashboardRepository())),

          //news dashboard news list
          BlocProvider(
            create: (context) =>
                NewsDashboardNewsListCubit(NewsDashboardRepository()),
          ),

          //LocaleFromLocationCubit
          BlocProvider(
            create: (context) => LocaleFromLocationCubit(
              context.read<LocationServiceRepository>(),
            ),
          ),

          //news language change controller
          BlocProvider(
              create: (context) => NewsLanguageChangeControllerCubit()),

          //News post cubit
          BlocProvider(
            create: (context) => ManageNewsPostCubit(
              manageNewsRepository: ManageNewsPostRepository(),
              mediaUploadRepository: context.read<MediaUploadRepository>(),
            ),
          )
        ],
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          buildWhen: (previous, current) {
            return current is AuthenticationAuthenticated ||
                current is AuthenticationUnauthenticated;
          },
          builder: (context, authenticationState) {
            //Create the GoRouter instance on every auth bloc change
            //When the app is in release mode, this GoRouter instance is created
            final releaseModeGoRouter = GoRouterManager().router;

            //!!!Do not remove this builder, this builder is catching
            //the rebuild of the app during language change!!!
            return Builder(builder: (context) {
              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig:
                      kReleaseMode ? releaseModeGoRouter : debugModeGoRouter,
                  title: applicationName,
                  locale: context.locale,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  theme: ThemeData(
                    useMaterial3: false,
                    primarySwatch:
                        ThemeColor.primarySwatchThemeColor(0xffC80880),
                    brightness: Brightness.light,
                    textTheme: GoogleFonts.poppinsTextTheme(),
                    appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        statusBarBrightness: Brightness.light,
                        statusBarIconBrightness: Brightness.dark,
                      ),
                    ),
                    scaffoldBackgroundColor:
                        const Color.fromRGBO(246, 246, 246, 1),
                  ),
                  builder: (context, child) => ResponsiveBreakpoints.builder(
                    child: child!,
                    breakpoints: [
                      const Breakpoint(start: 0, end: 250, name: MOBILE),
                      const Breakpoint(start: 251, end: 350, name: MOBILE),
                      const Breakpoint(start: 451, end: 550, name: MOBILE),
                      const Breakpoint(start: 551, end: 650, name: MOBILE),
                      const Breakpoint(start: 651, end: 800, name: TABLET),
                      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                      const Breakpoint(
                          start: 1921, end: double.infinity, name: '4K'),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
