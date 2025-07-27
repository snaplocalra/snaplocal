import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';
import 'package:snap_local/utility/localization/model/language_enum.dart';

class NewsPostContentLanguageSelector extends StatefulWidget {
  final LanguageEnum channelLanguage;
  final bool isChannelLanguageSelected;
  final void Function(bool value) onChannelLanguageSelected;

  const NewsPostContentLanguageSelector({
    super.key,
    required this.channelLanguage,
    required this.onChannelLanguageSelected,
    required this.isChannelLanguageSelected,
  });

  @override
  State<NewsPostContentLanguageSelector> createState() =>
      _NewsPostContentLanguageSelectorState();
}

class _NewsPostContentLanguageSelectorState
    extends State<NewsPostContentLanguageSelector> {
  late bool isChannelLanguageSelected = widget.isChannelLanguageSelected;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.channelLanguage != LanguageEnum.english,
      child: Row(
        children: [
          //English language text
          Transform.translate(
            offset: const Offset(0, 2),
            child: Text(
              LanguageEnum.english.nativeName,
              style: TextStyle(
                fontSize: 10,
                color: isChannelLanguageSelected
                    ? Colors.black54
                    : ApplicationColours.themePinkColor,
              ),
            ),
          ),
          //Channel language switch
          Switch(
            value: isChannelLanguageSelected,
            onChanged: (value) {
              setState(() {
                isChannelLanguageSelected = value;
                widget.onChannelLanguageSelected(value);
              });
            },
          ),
          //Channel language text
          Transform.translate(
            offset: const Offset(0, 2),
            child: Text(
              widget.channelLanguage.nativeName,
              style: TextStyle(
                fontSize: 10,
                color: isChannelLanguageSelected
                    ? ApplicationColours.themePinkColor
                    : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
