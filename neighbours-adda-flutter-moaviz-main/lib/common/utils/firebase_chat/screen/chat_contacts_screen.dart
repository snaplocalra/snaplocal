import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/data_filter/logic/data_filter/data_filter_cubit.dart';
import 'package:snap_local/common/utils/data_filter/logic/filter_controller/filter_controller_cubit.dart';
import 'package:snap_local/common/utils/data_filter/model/data_filter/sort_filter.dart';
import 'package:snap_local/common/utils/data_filter/widget/filters/data_filter_menu_widget.dart';
import 'package:snap_local/common/utils/data_filter/widget/search_box_with_data_filter.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/chat_contact/chat_contact_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/local_chats_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/tab/tab_cubit.dart';
import 'package:snap_local/common/utils/firebase_chat/model/chat_contacts_list_type.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_communication_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chat_blocked_users_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chats_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/chat_contact_list_builder.dart';
import 'package:snap_local/common/utils/firebase_chat/widget/local_chats_widget.dart';
import 'package:snap_local/common/utils/widgets/chat_page_heading.dart';
import 'package:snap_local/common/utils/widgets/page_heading.dart';
import 'package:snap_local/utility/common/search_box/logic/search/search_cubit.dart';
import 'package:snap_local/utility/common/search_box/logic/show_search_bar/show_search_bar_cubit.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class ChatContactsScreen extends StatefulWidget {
  const ChatContactsScreen({super.key});

  static const routeName = 'chat_contact';

  @override
  State<ChatContactsScreen> createState() => _ChatContactsScreenState();
}

class _ChatContactsScreenState extends State<ChatContactsScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  ChatContactCubit? chatContactCubit;
  DataFilterCubit? dataFilterCubit;
  LocalChatsCubit? localChatsCubit;
  late MainConversationTabsCubit tabCubit;

  List<ChatContactsListType> chatContactsListTypes = [
    ChatContactsListType.users,
    ChatContactsListType.localChat,
    ChatContactsListType.other,
  ];

  @override
  void initState() {
    super.initState();
    tabCubit = MainConversationTabsCubit();
    tabController =
        TabController(initialIndex:1,length: chatContactsListTypes.length, vsync: this);
    tabController.addListener(() {
      print(
          'TabController listener: index=${tabController.index}, isChanging=${tabController.indexIsChanging}');
      if (!tabController.indexIsChanging) {
        tabCubit.changeTab(tabController.index);
      }
    });

    // Initialize cubits after widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        chatContactCubit = ChatContactCubit(
          firebaseChatContactRepository: FirebaseChatCommunicationRepository(),
          firebaseChatRepository: context.read<FirebaseChatRepository>(),
        );

        localChatsCubit = LocalChatsCubit(
          repository: LocalChatsRepository(),
          blockedUsersRepo: LocalChatBlockedUsersRepository(),
        );

        dataFilterCubit = DataFilterCubit([
          //Sort filter
          SortFilter(
            filterName: tr(LocaleKeys.sort),
            sortFilterOptions: [
              SortFilterOption(sortType: SortFilterType.newMessages),
              SortFilterOption(sortType: SortFilterType.oldMessages),
              SortFilterOption(sortType: SortFilterType.unread),
            ],
          ),
        ]);
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    chatContactCubit?.close();
    dataFilterCubit?.close();
    localChatsCubit?.close();
    tabCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: chatContactCubit!),
        BlocProvider.value(value: dataFilterCubit!),
        BlocProvider.value(value: localChatsCubit!),
        BlocProvider.value(value: tabCubit),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => ShowSearchBarCubit()),
        BlocProvider(create: (context) => FilterControllerCubit()),
      ],
      child: Builder(builder: (context) {
        return BlocConsumer<ShowSearchBarCubit, ShowSearchBarState>(
          listener: (context, showSearchBarState) {
            if (!showSearchBarState.visible) {
              context.read<SearchCubit>().clearSearchQuery();
            }
          },
          builder: (context, showSearchBarState) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: ThemeAppBar(
                backgroundColor: Colors.white,
                title: Text(
                  tr(LocaleKeys.chat),
                  style: TextStyle(color: ApplicationColours.themeBlueColor),
                ),
                //This is commited as per client request
                // actions: [
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 5),
                //     child: SearchIcon(
                //       onTap: () {
                //         context.read<ShowSearchBarCubit>().toggleVisible();
                //       },
                //     ),
                //   ),
                // ],
                appBarHeight: 150,
                bottom: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        tabController.animateTo(1);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: ChatPageHeading(
                          svgPath: SVGAssetsImages.conversation,
                          heading: LocaleKeys.joinTheConversation,
                          subHeading: LocaleKeys.connectChatwithYourNeighbours,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: mqSize.width,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                              bottom: BorderSide(
                            color: Color.fromRGBO(175, 173, 173, 0.6),
                            width: 2.5,
                          )),
                        ),
                        child: TabBar(
                          controller: tabController,
                          labelColor: ApplicationColours.themeBlueColor,
                          indicatorWeight: 2.5,
                          indicatorColor: ApplicationColours.themeBlueColor,
                          labelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelColor:
                              ApplicationColours.unselectedLabelColor,
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: [
                            ...List<Widget>.generate(
                              chatContactsListTypes.length,
                              (index) => Tab(
                                child:
                                    Text(tr(chatContactsListTypes[index].name)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  BlocBuilder<MainConversationTabsCubit, int>(
                    buildWhen: (previous, current) {
                      print(
                          'BlocBuilder buildWhen: previous=$previous, current=$current');
                      return true;
                    },
                    builder: (context, tabIndex) {
                      print('BlocBuilder building with tabIndex: $tabIndex');
                      return Visibility(
                        visible: tabIndex != 1,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SearchWithDataFilterWidget(
                                    searchHint: tr(LocaleKeys.search),
                                    onQuery: (query) {
                                      if (query.isNotEmpty) {
                                        context
                                            .read<SearchCubit>()
                                            .setSearchQuery(query);
                                      } else {
                                        context
                                            .read<SearchCubit>()
                                            .clearSearchQuery();
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                  DataFilterMenu(
                                    onFilterApply: () {
                                      final filterJson = context
                                          .read<DataFilterCubit>()
                                          .state
                                          .filterJson;
                                      context
                                          .read<FilterControllerCubit>()
                                          .setFilter(filterJson);
                                    },
                                  ),
                                ],
                              ),
                            )),
                      );
                    },
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: const [
                        ChatContactListBuilder(
                          chatContactsListType: ChatContactsListType.users,
                        ),
                        LocalChatsWidget(),
                        ChatContactListBuilder(
                          chatContactsListType: ChatContactsListType.other,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
