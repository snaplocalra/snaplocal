import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/common/utils/location/widgets/location_search_widget.dart';
import 'package:snap_local/utility/common/search_box/widget/search_text_field.dart';
import 'package:snap_local/utility/common/widgets/theme_app_bar.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:snap_local/utility/location/service/location_service/logic/fetch_address_suggestions_by_query/fetch_address_suggestions_by_query_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/logic/location_service_controller/location_service_controller_cubit.dart';
import 'package:snap_local/utility/location/service/location_service/repository/location_service_repository.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  static const routeName = 'search_location';

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  TextEditingController locationController = TextEditingController();
  final searchFocusNode = FocusNode();

  late FetchAddressSuggestionsByQueryCubit fetchAddressSuggestionsByQueryCubit =
      FetchAddressSuggestionsByQueryCubit(
          context.read<LocationServiceRepository>());

  @override
  void initState() {
    super.initState();
    searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    locationController.dispose();
    searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppBar(
        title: Text(
          tr(LocaleKeys.searchForLocation),
          style: TextStyle(color: ApplicationColours.themeBlueColor),
        ),
      ),
      body: BlocBuilder<FetchAddressSuggestionsByQueryCubit,
          FetchAddressSuggestionsByQueryState>(
        bloc: fetchAddressSuggestionsByQueryCubit,
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: SearchTextField(
                  focusNode: searchFocusNode,
                  dataLoading: state.isLoading,
                  hint: LocaleKeys.search,
                  onQuery: (query) {
                    if (query.isEmpty) {
                      fetchAddressSuggestionsByQueryCubit.showBlankScreen();
                    } else {
                      fetchAddressSuggestionsByQueryCubit
                          .getAddressSuggestions(query);
                    }
                  },
                ),
              ),
              Expanded(
                child: state.showBlankScreen
                    ? const SizedBox.shrink()
                    : (state.addressSugegstions.isEmpty)
                        ? Center(
                            child: Text(
                              tr(LocaleKeys.noAddressFound),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tr(LocaleKeys.searchResult),
                                  style: const TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: state.addressSugegstions.length,
                                    itemBuilder: (context, index) {
                                      final address =
                                          state.addressSugegstions[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: GestureDetector(
                                          onTap: state.isLoading
                                              ? null
                                              : () async {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  fetchAddressSuggestionsByQueryCubit
                                                      .showLoader();

                                                  await context
                                                      .read<
                                                          LocationServiceControllerCubit>()
                                                      .getLocationByPlaceId(
                                                        placeId: state
                                                            .addressSugegstions[
                                                                index]
                                                            .placeId,
                                                      )
                                                      .then((location) {
                                                    if (context.mounted) {
                                                      GoRouter.of(context)
                                                          .pop(location);
                                                    }
                                                  });
                                                },
                                          child: AbsorbPointer(
                                            child: LocationListTile(
                                              title: address.title,
                                              location: address.description,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
              )
            ],
          );
        },
      ),
    );
  }
}
