import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class UnSeenCountWidget extends StatelessWidget {
  const UnSeenCountWidget({
    super.key,
    required this.unSeenPostCount,
  });

  final int unSeenPostCount;

  @override
  Widget build(BuildContext context) {
    final isThreeDigit = unSeenPostCount > 99;
    return Visibility(
      visible: unSeenPostCount > 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CircleAvatar(
          radius: isThreeDigit ? 12 : 10,
          backgroundColor: ApplicationColours.themePinkColor,
          foregroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              isThreeDigit ? '99+' : '$unSeenPostCount',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isThreeDigit ? 10 : 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
