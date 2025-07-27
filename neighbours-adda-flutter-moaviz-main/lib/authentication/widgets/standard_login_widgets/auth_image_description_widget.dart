import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:snap_local/authentication/models/auth_description_type.dart';

class AuthImageDescriptionWidget extends StatelessWidget {
  final AuthDescriptionType authDescriptionType;
  const AuthImageDescriptionWidget({
    super.key,
    required this.authDescriptionType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(authDescriptionType.svgPath),
        const SizedBox(height: 10),
        Text(
          tr(authDescriptionType.description),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(115, 115, 118, 1),
          ),
        ),
      ],
    );
  }
}
