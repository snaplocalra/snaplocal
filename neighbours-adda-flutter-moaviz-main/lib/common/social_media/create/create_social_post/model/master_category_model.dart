class MasterCategoryModel {
  final String name;
  final String svgPath;
  final bool isSelected;
  final Future<void> Function() onTap;

  MasterCategoryModel({
    required this.name,
    required this.svgPath,
    this.isSelected = false,
    required this.onTap,
  });
}
