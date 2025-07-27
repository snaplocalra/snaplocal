List<OnboardingModel> onboardingModelFromMap(Map<String, dynamic> json) =>
    List.from(json['data'].map((e) => OnboardingModel.fromMap(e)));

class OnboardingModel {
  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  factory OnboardingModel.fromMap(Map<String, dynamic> json) => OnboardingModel(
      image: json["image"],
      title: json["title"],
      description: json["description"]);
}
