import 'package:flutter/material.dart';

class ReactionEmojiList {
  final List<ReactionEmojiModel> reactionEmojiList;
  ReactionEmojiList(this.reactionEmojiList);

  factory ReactionEmojiList.fromMap(Map<String, dynamic> map) {
    return ReactionEmojiList(
      List<ReactionEmojiModel>.from(
        (map['data']).map<ReactionEmojiModel>(
          (x) => ReactionEmojiModel.fromMap(x),
        ),
      ),
    );
  }
}

Color _serverColourDecoder(String? colorCode) {
  if (colorCode != null) {
    int? intColour = int.tryParse(colorCode, radix: 16);
    if (intColour != null) {
      // Here the bitwise OR operation between 0xff000000 and intColour to set the alpha value (0xff)
      // at the beginning. This ensures that the resulting color is fully opaque.
      // Adding the opacity (alpha value) to the color
      intColour = 0xff000000 | intColour;
      return Color(intColour);
    }
  }
  //Default color
  return Colors.black;
}

String _serverColourEncoder(Color color) {
  // Extract the integer representation of the color
  int intColour = color.value;

  // Remove the alpha value by bitwise AND operation with 0x00FFFFFF
  intColour = intColour & 0x00FFFFFF;

  // Convert the integer color to a hex string
  String colorCode = intColour.toRadixString(16);

  // Ensure the color code has 6 digits by padding with zeros if needed
  colorCode = colorCode.padLeft(6, '0');

  return colorCode;
}

class ReactionEmojiModel {
  final String id;
  final String name;
  final Color nameColor;
  final String imageUrl;

  ReactionEmojiModel({
    required this.id,
    required this.name,
    required this.nameColor,
    required this.imageUrl,
  });

  factory ReactionEmojiModel.fromMap(Map<String, dynamic> map) {
    return ReactionEmojiModel(
      id: map['id'] as String,
      name: map['name'] as String,
      nameColor: _serverColourDecoder(map['name_color']),
      imageUrl: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': imageUrl,
      'name_color': _serverColourEncoder(nameColor),
    };
  }
}
