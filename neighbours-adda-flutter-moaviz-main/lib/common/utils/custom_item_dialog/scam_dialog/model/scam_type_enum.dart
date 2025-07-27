enum ScamType {
  market(title: "Be aware of scams", information: [
    "SnapLocal doesn't handle or process payments.",
    "Use caution and avoid sharing sensitive information online.",
    "Report any suspicious or scam listings immediately.",
    "Remember, you are responsible for your transactions on the platform.",
  ]),
  job(title: "Be aware of scams", information: [
    "SnapLocal doesn't handle or process payments.",
    "Exercise caution and avoid sharing sensitive information online.",
    "Report any suspicious or scam job postings immediately.",
    "Remember, you are responsible for your interactions on the platform.",
  ]),
  business(title: "Be aware of scams", information: [
    "SnapLocal doesn't handle or process payments.",
    "Use caution and avoid sharing sensitive information online.",
    "Report any suspicious or scam business listings immediately.",
    "Remember, you are responsible for your transactions on the platform.",
  ]),

  news(title: "Be aware of scams", information: [
    "SnapLocal doesn't handle or process payments.",
    "Use caution and avoid sharing sensitive information online.",
    "Report any suspicious or scam news channel listings immediately.",
    "Remember, you are responsible for your transactions on the platform.",
  ]);

  final String title;
  final List<String> information;
  const ScamType({required this.title, required this.information});
}
