import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/common/utils/empty_data_handler/models/empty_data_type.dart';

class EmptyDataPlaceHolder extends StatelessWidget {
  final EmptyDataType emptyDataType;
  final Color? backgroundcolor;
  const EmptyDataPlaceHolder({
    super.key,
    required this.emptyDataType,
    this.backgroundcolor,
  });

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.of(context).size;

    return Container(
      color: backgroundcolor ?? Colors.white,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              emptyDataType.svgImagePath,
              height: mqSize.height * 0.35,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 10),
            Text(
              tr(emptyDataType.heading),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
