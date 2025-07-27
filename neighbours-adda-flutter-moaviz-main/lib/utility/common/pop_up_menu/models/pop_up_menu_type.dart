import 'package:flutter/material.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

enum PopUpMenuType {
  edit(name: LocaleKeys.edit, icon: Icons.edit),
  delete(name: LocaleKeys.delete, icon: Icons.delete_outline),
  clear(name: LocaleKeys.clear, icon: Icons.clear),
  save(name: LocaleKeys.save, icon: Icons.save),
  report(name: LocaleKeys.report, icon: Icons.report),
  block(name: LocaleKeys.block, icon: Icons.block),
  blockAndReport(name:LocaleKeys.blockAndReport),
  unBlock(name:LocaleKeys.unBlock , icon: Icons.block);

  final String name;
  final IconData? icon;
  const PopUpMenuType({
    required this.name,
    this.icon,
  });
}
