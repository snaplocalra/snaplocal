import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/connections/logic/profile_connection/profile_connection_cubit.dart';
import 'package:snap_local/profile/connections/models/profile_connection_type.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';
import 'package:snap_local/profile/connections/widgets/profile_connections_list_builder.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/logic/language_change_controller/language_change_controller_cubit.dart';

class ProfileConnectionScreen extends StatefulWidget {
  const ProfileConnectionScreen({super.key});
  static const routeName = 'profile_connections';

  @override
  State<ProfileConnectionScreen> createState() =>
      _ProfileConnectionScreenState();
}

class _ProfileConnectionScreenState extends State<ProfileConnectionScreen>
    with TickerProviderStateMixin {
  final profileConnectionsCubit =
      ProfileConnectionsCubit(ProfileConnectionRepository());
  final connectionScrollController = ScrollController();
  late TabController tabController;

  late ProfileConnectionType connectionType;

  List<ProfileConnectionType> connectionTypes = [
    ProfileConnectionType.myConnections,
    ProfileConnectionType.requests,
  ];

  @override
  void initState() {
    super.initState();
    connectionType = connectionTypes.first;
    tabController = TabController(length: connectionTypes.length, vsync: this);

    //Fetch both conenctions data
    profileConnectionsCubit.fetchConnections();

    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        //This will implemented to check whether the user changing the tab by tapping or not.
        //If the user change the tab by tapping then avoid the api calling.Because after tap,when the index will
        //change then the api will call to fetch data.
        // return;
        return;
      } else {
        connectionType = connectionTypes[tabController.index];
        profileConnectionsCubit.fetchConnections(
          allowDataFetch: false,
          profileConnectionType: connectionType,
        );
        return;
      }
    });

    connectionScrollController.addListener(() {
      if (connectionScrollController.position.maxScrollExtent ==
          connectionScrollController.offset) {
        profileConnectionsCubit.fetchConnections(
          loadMoreData: true,
          profileConnectionType: connectionType,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    connectionScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    return BlocBuilder<LanguageChangeControllerCubit,
        LanguageChangeControllerState>(
      builder: (context, _) {
        return BlocProvider.value(
          value: profileConnectionsCubit,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: ThemeAppBar(
              backgroundColor: Colors.white,
              title: Text(
                tr(LocaleKeys.connections),
                style: TextStyle(color: ApplicationColours.themeBlueColor),
              ),
              appBarHeight: 150,
              bottom: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: BlocBuilder<ProfileConnectionsCubit,
                        ProfileConnectionsState>(
                      builder: (context, profileConnectionsState) {
                        return SearchTextField(
                          dataLoading: profileConnectionsState.isSearching,
                          hint: LocaleKeys.search,
                          onQuery: (query) {
                            final connectionCubit =
                                context.read<ProfileConnectionsCubit>();
                            if (query.isNotEmpty) {
                              connectionCubit.setSearchQuery(query);
                              //Search connections
                              connectionCubit.searchConenctionByType(
                                profileConnectionType: connectionType,
                              );
                            } else {
                              connectionCubit.clearSearchQuery();
                              //Fetch the connections with the last selected connection type
                              connectionCubit.fetchConnections(
                                  profileConnectionType: connectionType);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    width: mqSize.width,
                    child:
                        //This decorated box is used to draw the unselected lable color
                        DecoratedBox(
                      //This is responsible for the background of the tabbar, does the magic
                      decoration: const BoxDecoration(
                        //This is for background color
                        color: Colors.transparent,
                        //This is for bottom border that is needed
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
                            connectionTypes.length,
                            (index) => Tab(
                              child: Text(tr(connectionTypes[index].name)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                ProfileConnectionListBuilder(
                  connectionType: ProfileConnectionType.myConnections,
                  connectionScrollController: connectionScrollController,
                ),
                ProfileConnectionListBuilder(
                  connectionType: ProfileConnectionType.requests,
                  connectionScrollController: connectionScrollController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
