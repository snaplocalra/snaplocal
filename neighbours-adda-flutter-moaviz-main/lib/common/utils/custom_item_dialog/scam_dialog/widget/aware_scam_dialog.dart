import 'package:easy_localization/easy_localization.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/custom_item_dialog/scam_dialog/model/scam_type_enum.dart';
import 'package:snap_local/utility/common/widgets/circular_tick.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class AwareScamDialog extends StatelessWidget {
  final String? title;
  final List<String> information;

  const AwareScamDialog({
    super.key,
    this.title,
    required this.information,
  });

  get isSelected => null;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              tr(LocaleKeys.beAwareOfScams),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: ApplicationColours.themeBlueColor,
              ),
            ),
          ),
          const Divider(
            height: 10,
            thickness: 2,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: information.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: CircularTick(
                          showTick: true,
                          enablePlaceHolder: true,
                          tickSize: 13,
                          placeHolderHeight: 6,
                          placeHolderWidth: 6,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          information[index],
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(tr(LocaleKeys.okay)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> showScamDialog(BuildContext context,
    {required ScamType scamType}) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AwareScamDialog(
        title: scamType.title,
        information: scamType.information,
      );
    },
  );
}
